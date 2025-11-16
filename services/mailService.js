import nodemailer from 'nodemailer';
import { createTransport } from 'nodemailer';

const createMailer = async () => {
  // If SMTP config provided via env, use it. Otherwise, use a test account.
  if (process.env.SMTP_HOST && process.env.SMTP_USER && process.env.SMTP_PASS) {
    return createTransport({
      host: process.env.SMTP_HOST,
      port: process.env.SMTP_PORT ? Number(process.env.SMTP_PORT) : 587,
      secure: false,
      auth: {
        user: process.env.SMTP_USER,
        pass: process.env.SMTP_PASS,
      },
    });
  }

  // Fallback: use ethereal test account
  const testAccount = await nodemailer.createTestAccount();
  return createTransport({
    host: 'smtp.ethereal.email',
    port: 587,
    secure: false,
    auth: {
      user: testAccount.user,
      pass: testAccount.pass,
    },
  });
};

export const mailService = {
  sendVerificationEmail: async (toEmail, token) => {
    const transporter = await createMailer();
    const appUrl = process.env.APP_URL || 'http://localhost:3000';
    const verifyLink = `${appUrl}/verify-email?token=${token}`;

    const mailOptions = {
      from: process.env.MAIL_FROM || 'no-reply@educourse.app',
      to: toEmail,
      subject: 'Verify your EduCourse account',
      text: `Silakan verifikasi akun Anda dengan mengunjungi: ${verifyLink}`,
      html: `<p>Silakan verifikasi akun Anda dengan mengklik link berikut:</p><p><a href="${verifyLink}">${verifyLink}</a></p>`,
    };

    const info = await transporter.sendMail(mailOptions);

    // If using ethereal, log preview URL
    if (nodemailer.getTestMessageUrl(info)) {
      console.log('Preview URL: %s', nodemailer.getTestMessageUrl(info));
    }

    return info;
  }
};

export default mailService;
