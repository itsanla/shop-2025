import HttpStatusCodes from '../common/constants/HttpStatusCodes';
import UserService from '../services/UserService';
import User, { IUser } from '../models/User';
import { IReq, IRes } from './common/types';
import { parseReq } from './common/utils';

const validateUser = (val: unknown): IUser => {
  if (!User.isComplete(val)) throw new Error('Invalid user');
  return val;
};

const validateId = (val: unknown): number => {
  const id = Number(val);
  if (isNaN(id)) throw new Error('Invalid ID');
  return id;
};

const Validators = {
  add: parseReq({ user: validateUser }),
  update: parseReq({ user: validateUser }),
  delete: parseReq({ id: validateId }),
};

async function getAll(_: IReq, res: IRes) {
  const users = await UserService.getAll();
  res.status(200).json({ users });
}

async function add(req: IReq, res: IRes) {
  const result = Validators.add(req.body);
  await UserService.addOne(result.user as IUser);
  res.status(201).end();
}

async function update(req: IReq, res: IRes) {
  const result = Validators.update(req.body);
  await UserService.updateOne(result.user as IUser);
  res.status(200).end();
}

async function __delete__(req: IReq, res: IRes) {
  const result = Validators.delete(req.params);
  await UserService.delete(result.id as number);
  res.status(200).end();
}

export default { getAll, add, update, delete: __delete__ };
