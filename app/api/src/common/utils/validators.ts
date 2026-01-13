export const transformIsDate = (arg: unknown) => {
  const date = new Date(arg as string);
  if (isNaN(date.getTime())) throw new Error('Invalid date');
  return date;
};
