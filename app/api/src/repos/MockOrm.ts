import { promises as fs } from 'fs';
import path from 'path';
import { IUser } from '../models/User';
import EnvVars from '../common/constants/EnvVars';
import { NodeEnvs } from '../common/constants';

const DB_FILE = EnvVars.NodeEnv === NodeEnvs.TEST ? 'database.test.json' : 'database.json';

interface IDatabase {
  users: IUser[];
}

async function openDb(): Promise<IDatabase> {
  const data = await fs.readFile(path.join(__dirname, DB_FILE), 'utf-8');
  return JSON.parse(data);
}

async function saveDb(db: IDatabase): Promise<void> {
  await fs.writeFile(path.join(__dirname, DB_FILE), JSON.stringify(db, null, 2));
}

export default { openDb, saveDb };
