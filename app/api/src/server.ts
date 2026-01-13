import express, { Request, Response, NextFunction } from 'express';
import cors from 'cors';
import helmet from 'helmet';
import { env } from './common/env';
import emailRouter from './routes/email';
import paymentRouter from './routes/payment';
import { bullBoardRouter } from './config/bull-board';

const app = express();

app.use(cors());
app.use(helmet());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.get('/', (req: Request, res: Response) => {
  res.json({
    message: 'Marketplace API v1',
    env: env.NODE_ENV,
    timestamp: new Date().toISOString(),
  });
});

app.use('/api/email', emailRouter);
app.use('/api/payment', paymentRouter);
app.use('/admin/queues', bullBoardRouter);

app.use((err: Error, req: Request, res: Response, next: NextFunction) => {
  console.error(err.stack);
  res.status(500).json({
    status: 'error',
    message: err.message || 'Internal Server Error',
  });
});

export default app;
