import { Response, Request } from 'express';

type PlainObject = Record<string, unknown>;

export type IReq = Request<PlainObject, void, PlainObject, PlainObject>;
export type IRes = Response<unknown, PlainObject>;

