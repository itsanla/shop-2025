import { RouteError } from '../../common/utils/route-errors';
import UserRepo from '../../repos/UserRepo';
import { IUser } from '../../models/User';
import { USER_NOT_FOUND_ERROR } from './constants';

function getAll(): Promise<IUser[]> {
  return UserRepo.getAll();
}

function addOne(user: IUser): Promise<void> {
  return UserRepo.add(user);
}

async function updateOne(user: IUser): Promise<void> {
  const persists = await UserRepo.persists(user.id);
  if (!persists) {
    throw new RouteError(404, USER_NOT_FOUND_ERROR);
  }
  return UserRepo.update(user);
}

async function __delete__(id: number): Promise<void> {
  const persists = await UserRepo.persists(id);
  if (!persists) {
    throw new RouteError(404, USER_NOT_FOUND_ERROR);
  }
  return UserRepo.delete(id);
}

export default { getAll, addOne, updateOne, delete: __delete__ };
