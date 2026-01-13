import { Queue, Worker, Job } from 'bullmq';
import { redisConnection } from './redis';

export const emailQueue = new Queue('email', { connection: redisConnection });
export const paymentQueue = new Queue('payment', { connection: redisConnection });

const emailWorker = new Worker('email', async (job: Job) => {
  console.info(`Processing email job ${job.id}:`, job.data);
  await new Promise(resolve => setTimeout(resolve, 1000));
  console.info(`Email sent to ${job.data.to}`);
}, { connection: redisConnection });

const paymentWorker = new Worker('payment', async (job: Job) => {
  console.info(`Processing payment job ${job.id}:`, job.data);
  await new Promise(resolve => setTimeout(resolve, 2000));
  console.info(`Payment processed for order ${job.data.orderId}`);
}, { connection: redisConnection });

emailWorker.on('completed', (job) => {
  console.info(`✅ Email job ${job.id} completed`);
});

emailWorker.on('failed', (job, err) => {
  console.error(`❌ Email job ${job?.id} failed:`, err.message);
});

paymentWorker.on('completed', (job) => {
  console.info(`✅ Payment job ${job.id} completed`);
});

paymentWorker.on('failed', (job, err) => {
  console.error(`❌ Payment job ${job?.id} failed:`, err.message);
});
