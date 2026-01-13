export class RouteError extends Error {
  public status: number;

  public constructor(status: number, message: string) {
    super(message);
    this.status = status;
  }
}

export class ValidationError extends RouteError {
  public constructor(errors: unknown[]) {
    super(400, JSON.stringify({ message: 'Validation error', errors }));
  }
}
