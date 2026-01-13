import IORedis from 'ioredis';
import { env } from '../src/common/env';

export const redisConnection = new IORedis({
  host: env.REDIS_HOST,
  port: parseInt(env.REDIS_PORT),
  maxRetriesPerRequest: null,
});

redisConnection.on('error', (err) => {
  console.error('Redis Error:', err);
});
