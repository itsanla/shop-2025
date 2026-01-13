import { Router, Request, Response } from 'express';
import { emailQueue } from '../config/queue';

const router = Router();

router.post('/send', async (req: Request, res: Response) => {
  const { to, subject, body } = req.body;
  
  await emailQueue.add('send-email', { to, subject, body });
  
  res.json({ message: 'Email queued successfully' });
});

export default router;
