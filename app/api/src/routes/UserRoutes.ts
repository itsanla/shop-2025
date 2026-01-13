import HttpStatusCodes from '@src/common/constants/HttpStatusCodes';
import UserService from '@src/services/UserService';
import User, { IUser } from '@src/models/User';

import { IReq, IRes } from './common/types';
import { parseReq } from './common/utils';

const isNumber = (val: unknown): val is number => typeof val === 'number' && !isNaN(val);
const transform = <T>(fn: (v: unknown) => T, validator: (v: T) => boolean) => (val: unknown) => {
  const transformed = fn(val);
  if (!validator(transformed)) throw new Error('Validation failed');
  return transformed;
};

const validateUser = (val: unknown): IUser => {
  if (!User.isComplete(val)) throw new Error('Invalid user');
  return val;
};

const Validators = {
  add: parseReq({ user: validateUser }),
  update: parseReq({ user: validateUser }),
  delete: parseReq({ id: transform(Number, isNumber) }),
} as const;

/******************************************************************************
                                Functions
******************************************************************************/

/**
 * Get all users.
 */
async function getAll(_: IReq, res: IRes) {
  const users = await UserService.getAll();
  res.status(HttpStatusCodes.OK).json({ users });
}

/**
 * Add one user.
 */
async function add(req: IReq, res: IRes) {
  const result = Validators.add(req.body);
  await UserService.addOne(result.user as IUser);
  res.status(HttpStatusCodes.CREATED).end();
}

/**
 * Update one user.
 */
async function update(req: IReq, res: IRes) {
  const result = Validators.update(req.body);
  await UserService.updateOne(result.user as IUser);
  res.status(HttpStatusCodes.OK).end();
}

/**
 * Delete one user.
 */
async function __delete__(req: IReq, res: IRes) {
  const result = Validators.delete(req.params);
  await UserService.delete(result.id as number);
  res.status(HttpStatusCodes.OK).end();
}

/******************************************************************************
                                Export default
******************************************************************************/

export default {
  getAll,
  add,
  update,
  delete: __delete__,
} as const;
