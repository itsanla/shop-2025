import { Router } from 'express';
import Paths from '../common/constants/Paths';
import UserRoutes from './UserRoutes';

const apiRouter = Router();
const userRouter = Router();

userRouter.get(Paths.Users.Get, UserRoutes.getAll);
userRouter.post(Paths.Users.Add, UserRoutes.add);
userRouter.put(Paths.Users.Update, UserRoutes.update);
userRouter.delete(Paths.Users.Delete, UserRoutes.delete);

apiRouter.use(Paths.Users._, userRouter);

export default apiRouter;
