import { Queue, Worker, Job } from 'bullmq';
import { redisConnection } from './redis';

export const emailQueue = new Queue('email', { connection: redisConnection });

const emailWorker = new Worker('email', async (job: Job) => {
  console.info(`Processing email job ${job.id}:`, job.data);
  await new Promise(resolve => setTimeout(resolve, 1000));
  console.info(`Email sent to ${job.data.to}`);
}, { connection: redisConnection });

emailWorker.on('completed', (job) => {
  console.info(`✅ Job ${job.id} completed`);
});

emailWorker.on('failed', (job, err) => {
  console.error(`❌ Job ${job?.id} failed:`, err.message);
});
