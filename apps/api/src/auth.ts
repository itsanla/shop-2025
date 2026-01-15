import { Router, Request, Response } from 'express';
import prisma from './config/prisma';

const router = Router();

// ini untuk verify Firebase token dan simpan atau update user buk
router.post('/verify', async (req: Request, res: Response) => {
  const { uid, email, name, phone } = req.body;

  // ini untuk cari atau buat user baru buk
  const user = await prisma.user.upsert({
    where: { firebaseUid: uid },
    update: { email, name, phone },
    create: { firebaseUid: uid, email, name, phone },
  });

  res.json({ success: true, userId: user.id });
});

export default router;
