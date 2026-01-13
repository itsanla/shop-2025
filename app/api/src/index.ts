import dotenv from 'dotenv';
import path from 'path';

const NODE_ENV = process.env.NODE_ENV ?? 'development';
dotenv.config({ path: path.join(__dirname, `../config/.env.${NODE_ENV}`) });

import app from './server';
import { env } from './common/env';

app.listen(env.PORT, () => {
  console.info(`🚀 Server running on port ${env.PORT}`);
  console.info(`   Environment: ${env.NODE_ENV}`);
});
