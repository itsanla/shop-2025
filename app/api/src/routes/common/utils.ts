import { ValidationError } from '../../common/utils/route-errors';

type Schema = Record<string, (val: unknown) => unknown>;

export function parseReq<U extends Schema>(schema: U) {
  return (data: Record<string, unknown>) => {
    const result: Record<string, unknown> = {};
    const errors: string[] = [];
    
    for (const [key, validator] of Object.entries(schema)) {
      try {
        result[key] = validator(data[key]);
      } catch (err) {
        errors.push(`${key}: ${err}`);
      }
    }
    
    if (errors.length > 0) {
      throw new ValidationError(errors);
    }
    
    return result;
  };
}
