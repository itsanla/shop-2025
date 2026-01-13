import path from 'path';
import dotenv from 'dotenv';
import EnvVars from './common/constants/EnvVars';
import server from './server';

const NODE_ENV = (process.env.NODE_ENV ?? 'development');
dotenv.config({ path: path.join(__dirname, `../config/.env.${NODE_ENV}`) });

server.listen(EnvVars.Port, () => {
  console.info('Express server started on port: ' + EnvVars.Port);
});
