import { Router, Request, Response } from 'express';
import prisma from './config/prisma';

const router = Router();

// Endpoint untuk verify Firebase token dan simpan/update user
router.post('/verify', async (req: Request, res: Response) => {
  const { uid, email, name, phone } = req.body;

  // Cari atau buat user baru
  const user = await prisma.user.upsert({
    where: { firebaseUid: uid },
    update: { email, name, phone },
    create: { firebaseUid: uid, email, name, phone },
  });

  res.json({ success: true, userId: user.id });
});

export default router;
