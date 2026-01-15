import { Router, Request, Response } from 'express';
import prisma from './config/prisma';
import { emailQueue } from './config/queue';

const router = Router();

// ini untuk ambil semua produk dengan sorting opsional buk
router.get('/products', async (req: Request, res: Response) => {
  const { sort, category } = req.query;
  
  const products = await prisma.productItem.findMany({
    where: category ? { category: category as string } : undefined,
    orderBy: sort === 'price_asc' ? { price: 'asc' } : 
             sort === 'price_desc' ? { price: 'desc' } : undefined,
  });
  
  res.json(products);
});

// ini untuk tambah produk baru buk
router.post('/products', async (req: Request, res: Response) => {
  const product = await prisma.productItem.create({ data: req.body });
  res.json({ id: product.id });
});

// ini untuk search produk buk
router.get('/search', async (req: Request, res: Response) => {
  const q = req.query.q as string;
  
  if (!q) {
    res.json([]);
    return;
  }
  
  const products = await prisma.productItem.findMany({
    where: {
      OR: [
        { name: { contains: q, mode: 'insensitive' } },
        { category: { contains: q, mode: 'insensitive' } },
        { vendors: { contains: q, mode: 'insensitive' } },
        { description: { contains: q, mode: 'insensitive' } },
      ],
    },
  });
  
  res.json(products);
});

// ini untuk buat payment buk
router.post('/payment/create', async (req: Request, res: Response) => {
  try {
    const { amount, items, userEmail, orderId } = req.body;
    const finalOrderId = orderId || `ORDER-${Date.now()}`;

    console.log('Request pembuatan payment:', { orderId: finalOrderId, amount, userEmail, itemCount: items?.length });

    // ini untuk simpan transaksi ke database pakai Prisma buk
    const transaction = await prisma.transaction.create({
      data: {
        order_id: finalOrderId,
        user_email: userEmail,
        gross_amount: amount,
        transaction_status: 'pending',
        items: items,
      },
    });

    console.log('Transaksi tersimpan di DB:', transaction.id);

    const snap = await fetch('https://app.sandbox.midtrans.com/snap/v1/transactions', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Basic ${Buffer.from(process.env.MIDTRANS_SERVER_KEY + ':').toString('base64')}`,
      },
      body: JSON.stringify({
        transaction_details: {
          order_id: finalOrderId,
          gross_amount: amount,
        },
        item_details: items.map((item: any) => ({
          id: item.id,
          name: item.name,
          price: item.price,
          quantity: item.quantity,
        })),
      }),
    });

    if (!snap.ok) {
      const errorText = await snap.text();
      console.error('Error Midtrans API:', snap.status, errorText);
      throw new Error(`Midtrans API error: ${snap.status}`);
    }

    const data = await snap.json() as { token: string };
    console.log('Snap token berhasil dibuat:', data.token?.substring(0, 20) + '...');
    res.json({ snapToken: data.token, orderId: finalOrderId });
  } catch (error: any) {
    console.error('Error pembuatan payment:', error.message);
    res.status(500).json({ error: 'Failed to create payment', details: error.message });
  }
});

// ini untuk webhook dari Midtrans buk
router.post('/payment/webhook', async (req: Request, res: Response) => {
  try {
    const { order_id, transaction_status, gross_amount } = req.body;
    
    console.log('Webhook diterima:', { order_id, transaction_status, gross_amount });
    
    if (transaction_status === 'settlement' || transaction_status === 'capture') {
      // ini untuk ambil data transaksi dari database pakai Prisma buk
      const transaction = await prisma.transaction.findUnique({
        where: { order_id },
      });
      
      if (transaction) {
        // ini untuk update status transaksi buk
        await prisma.transaction.update({
          where: { order_id },
          data: { transaction_status },
        });

        console.log(`Status transaksi diupdate: ${order_id} -> ${transaction_status}`);
        console.log(`Menambahkan email ke queue untuk: ${transaction.user_email}`);
        
        // ini untuk masukin email job ke queue buk
        await emailQueue.add('payment-success', {
          to: transaction.user_email,
          subject: 'Pembayaran Berhasil - Anla Shop',
          html: `
            <h2>Pembayaran Berhasil!</h2>
            <p>Pembayaran Anda telah dikonfirmasi.</p>
            <p>ID Pesanan: <strong>${order_id}</strong></p>
            <p>Total: <strong>Rp ${Number(transaction.gross_amount || gross_amount).toLocaleString('id-ID')}</strong></p>
            <p>Terima kasih telah berbelanja di Anla Shop!</p>
            <p>Salam,<br>Tim Anla Shop</p>
          `,
        });
        console.log('Email job ditambahkan ke queue');
      } else {
        console.warn(`Transaksi tidak ditemukan: ${order_id}`);
      }
    }
    
    res.json({ status: 'ok' });
  } catch (error) {
    console.error('Webhook error:', error);
    res.status(500).json({ status: 'error', message: String(error) });
  }
});

// ini dipanggil dari mobile waktu payment berhasil buk
router.post('/payment/confirm', async (req: Request, res: Response) => {
  try {
    const { order_id } = req.body;
    
    console.log('Konfirmasi payment dari mobile:', order_id);
    
    const transaction = await prisma.transaction.findUnique({
      where: { order_id },
    });
    
    if (!transaction) {
      console.warn('Transaksi tidak ditemukan:', order_id);
      return res.status(404).json({ success: false, message: 'Transaction not found' });
    }

    console.log('Status transaksi saat ini:', transaction.transaction_status);
    
    // ini untuk update status kalau belum settlement buk
    if (transaction.transaction_status !== 'settlement') {
      await prisma.transaction.update({
        where: { order_id },
        data: { transaction_status: 'settlement' },
      });
      console.log('Status transaksi diupdate ke settlement');
    }

    // ini selalu queue email buk, walaupun udah settlement buat handle retry
    console.log('Menambahkan email ke queue untuk:', transaction.user_email);
    await emailQueue.add('payment-success', {
      to: transaction.user_email,
      subject: 'Pembayaran Berhasil - Anla Shop',
      html: `
        <h2>Pembayaran Berhasil!</h2>
        <p>Pembayaran Anda telah dikonfirmasi.</p>
        <p>ID Pesanan: <strong>${order_id}</strong></p>
        <p>Total: <strong>Rp ${Number(transaction.gross_amount).toLocaleString('id-ID')}</strong></p>
        <p>Terima kasih telah berbelanja di Anla Shop!</p>
        <p>Salam,<br>Tim Anla Shop</p>
      `,
    });
    
    console.log('Email job berhasil ditambahkan ke queue');
    res.json({ success: true, message: 'Email queued' });
  } catch (error) {
    console.error('Error konfirmasi payment:', error);
    res.status(500).json({ error: 'Failed to confirm payment', details: String(error) });
  }
});

// ini untuk test email buk
router.post('/test-email', async (req: Request, res: Response) => {
  const { email } = req.body;
  await emailQueue.add('test-email', {
    to: email || 'anlaharpanda@gmail.com',
    subject: 'Test Email - Anla Shop',
    html: '<h2>Test email berhasil!</h2><p>Konfigurasi SMTP sudah benar.</p>',
  });
  res.json({ message: 'Email queued' });
});

export default router;
