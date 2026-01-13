import { NodeEnvs } from '.';

const EnvVars = {
  NodeEnv: process.env.NODE_ENV || NodeEnvs.DEV,
  Port: Number(process.env.PORT) || 3000,
};

export default EnvVars;
