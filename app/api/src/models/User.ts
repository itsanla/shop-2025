import { IModel } from './common/types';

const GetDefaults = (): IUser => ({
  id: 0,
  name: '',
  email: '',
  created: new Date(),
});

export interface IUser extends IModel {
  name: string;
  email: string;
}

function __new__(user?: Partial<IUser>): IUser {
  return { ...GetDefaults(), ...user };
}

function isComplete(obj: unknown): obj is IUser {
  const u = obj as IUser;
  return (
    typeof u?.id === 'number' &&
    typeof u?.name === 'string' && u.name.length > 0 &&
    typeof u?.email === 'string' && u.email.length > 0 &&
    u?.created instanceof Date
  );
}

export default {
  new: __new__,
  isComplete,
} as const;