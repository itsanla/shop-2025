import helmet from 'helmet';
import express, { Request, Response, NextFunction } from 'express';

import BaseRouter from './routes';
import Paths from './common/constants/Paths';
import EnvVars from './common/constants/EnvVars';
import HttpStatusCodes from './common/constants/HttpStatusCodes';
import { RouteError } from './common/utils/route-errors';
import { NodeEnvs } from './common/constants';

const app = express();

app.use(express.json());
app.use(express.urlencoded({extended: true}));

if (EnvVars.NodeEnv === NodeEnvs.PRODUCTION) {
  app.use(helmet());
}

app.use(Paths._, BaseRouter);

app.use((err: Error, _: Request, res: Response, next: NextFunction) => {
  if (EnvVars.NodeEnv !== NodeEnvs.TEST) {
    console.error(err);
  }
  let status: HttpStatusCodes = 400;
  if (err instanceof RouteError) {
    status = err.status;
    res.status(status).json({ error: err.message });
  }
  return next(err);
});

export default app;
