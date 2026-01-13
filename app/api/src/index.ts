import EnvVars from '@src/common/constants/EnvVars';
import server from './server';

const SERVER_START_MSG = (
  'Express server started on port: ' + EnvVars.Port.toString()
);

server.listen(EnvVars.Port, () => {
  console.info(SERVER_START_MSG);
});
