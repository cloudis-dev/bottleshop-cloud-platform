export interface Mail {
  to: string;
  message: { subject: string; text?: string; html?: string };
}
