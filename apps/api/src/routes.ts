import { Router, Request, Response } from 'express';
import prisma from './config/prisma';

const router = Router();

// GET all products with optional sorting
router.get('/products', async (req: Request, res: Response) => {
  const { sort, category } = req.query;
  
  const products = await prisma.productItem.findMany({
    where: category ? { category: category as string } : undefined,
    orderBy: sort === 'price_asc' ? { price: 'asc' } : 
             sort === 'price_desc' ? { price: 'desc' } : undefined,
  });
  
  res.json(products);
});

// POST add new product
router.post('/products', async (req: Request, res: Response) => {
  const product = await prisma.productItem.create({ data: req.body });
  res.json({ id: product.id });
});

// GET search products
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
      ],
    },
  });
  
  res.json(products);
});

// POST create payment
router.post('/payment/create', async (req: Request, res: Response) => {
  const { amount, items } = req.body;
  const orderId = `ORDER-${Date.now()}`;

  const snap = await fetch('https://app.sandbox.midtrans.com/snap/v1/transactions', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Basic ${Buffer.from(process.env.MIDTRANS_SERVER_KEY + ':').toString('base64')}`,
    },
    body: JSON.stringify({
      transaction_details: {
        order_id: orderId,
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

  const data = await snap.json() as { token: string };
  res.json({ snapToken: data.token });
});

export default router;
