import { Queue, Worker, Job } from 'bullmq';
import { redisConnection } from './redis';
import nodemailer from 'nodemailer';

const transporter = nodemailer.createTransport({
  host: process.env.SMTP_HOST,
  port: Number(process.env.SMTP_PORT),
  secure: false,
  auth: {
    user: process.env.SMTP_USER,
    pass: process.env.SMTP_PASS,
  },
});

// ini untuk verifikasi koneksi SMTP waktu startup buk
transporter.verify((error, success) => {
  if (error) {
    console.error('Error koneksi SMTP:', error.message);
  } else {
    console.info('SMTP server siap mengirim email');
  }
});

export const emailQueue = new Queue('email', { connection: redisConnection });
export const paymentQueue = new Queue('payment', { connection: redisConnection });

const emailWorker = new Worker('email', async (job: Job) => {
  console.info(`Memproses email job ${job.id}:`, {
    to: job.data.to,
    subject: job.data.subject,
    jobName: job.name,
  });
  
  try {
    const info = await transporter.sendMail({
      from: process.env.SMTP_FROM,
      to: job.data.to,
      subject: job.data.subject,
      html: job.data.html,
    });
    
    console.info(`Email berhasil dikirim ke ${job.data.to}`);
    console.info(`Message ID: ${info.messageId}`);
    console.info(`Response: ${info.response}`);
    return { success: true, messageId: info.messageId };
  } catch (error: any) {
    console.error(`Gagal mengirim email ke ${job.data.to}:`, error.message);
    console.error(`Detail error:`, error);
    throw error; // ini biar BullMQ retry lagi buk
  }
}, { connection: redisConnection });

const paymentWorker = new Worker('payment', async (job: Job) => {
  console.info(`Memproses payment job ${job.id}:`, job.data);
  await new Promise(resolve => setTimeout(resolve, 2000));
  console.info(`Payment diproses untuk order ${job.data.orderId}`);
}, { connection: redisConnection });

emailWorker.on('completed', (job) => {
  console.info(`Email job ${job.id} selesai`);
});

emailWorker.on('failed', (job, err) => {
  console.error(`Email job ${job?.id} gagal:`, err.message);
  console.error(`Percobaan: ${job?.attemptsMade}/${job?.opts.attempts}`);
});

emailWorker.on('error', (err) => {
  console.error('Email worker error:', err.message);
});

paymentWorker.on('completed', (job) => {
  console.info(`Payment job ${job.id} selesai`);
});

paymentWorker.on('failed', (job, err) => {
  console.error(`Payment job ${job?.id} gagal:`, err.message);
});
