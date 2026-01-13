import { Router, Request, Response } from 'express';
import { paymentQueue } from '../config/queue';

const router = Router();

router.post('/process', async (req: Request, res: Response) => {
  const { orderId, amount, customerEmail } = req.body;
  
  await paymentQueue.add('process-payment', { 
    orderId, 
    amount, 
    customerEmail,
    gateway: 'midtrans',
  });
  
  res.json({ message: 'Payment queued successfully', orderId });
});

export default router;
