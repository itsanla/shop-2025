import HttpStatusCodes from '@src/common/constants/HttpStatusCodes';

export class RouteError extends Error {
  public status: HttpStatusCodes;

  public constructor(status: HttpStatusCodes, message: string) {
    super(message);
    this.status = status;
  }
}

export class ValidationError extends RouteError {
  public static MESSAGE = 'Validation error';

  public constructor(errors: unknown[]) {
    const msg = JSON.stringify({
      message: ValidationError.MESSAGE,
      errors,
    });
    super(400, msg);
  }
}
