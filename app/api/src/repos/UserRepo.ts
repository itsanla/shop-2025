import { IUser } from '../models/User';
import { getRandomInt } from '../common/utils/misc';
import orm from './MockOrm';

async function getOne(email: string): Promise<IUser | null> {
  const db = await orm.openDb();
  return db.users.find(user => user.email === email) || null;
}

async function persists(id: number): Promise<boolean> {
  const db = await orm.openDb();
  return db.users.some(user => user.id === id);
}

async function getAll(): Promise<IUser[]> {
  const db = await orm.openDb();
  return db.users;
}

async function add(user: IUser): Promise<void> {
  const db = await orm.openDb();
  user.id = getRandomInt();
  db.users.push(user);
  return orm.saveDb(db);
}

async function update(user: IUser): Promise<void> {
  const db = await orm.openDb();
  const index = db.users.findIndex(u => u.id === user.id);
  if (index !== -1) {
    db.users[index] = { ...db.users[index], name: user.name, email: user.email };
    return orm.saveDb(db);
  }
}

async function __delete__(id: number): Promise<void> {
  const db = await orm.openDb();
  const index = db.users.findIndex(u => u.id === id);
  if (index !== -1) {
    db.users.splice(index, 1);
    return orm.saveDb(db);
  }
}

export default { getOne, persists, getAll, add, update, delete: __delete__ };
