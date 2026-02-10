package it.univaq.webengineering.soccorsoweb.service;

import it.univaq.webengineering.soccorsoweb.model.entity.Missione;
import it.univaq.webengineering.soccorsoweb.model.entity.User;
import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

@Slf4j
@Service
public class EmailService {

    private final JavaMailSender mailSender;

    @Value("${spring.mail.username}")
    private String fromEmail;

    public EmailService(JavaMailSender mailSender) {
        this.mailSender = mailSender;
    }

    public void inviaEmailConvalida(String toEmail, String nomeSegnalante, String linkConvalida) {
        String htmlContent = """
                <!DOCTYPE html>
                <html>
                <head>
                    <meta charset="UTF-8">
                    <style>
                        body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
                        .container { max-width: 600px; margin: 0 auto; padding: 20px; }
                        .header { background-color: #dc3545; color: white; padding: 20px; text-align: center; border-radius: 5px 5px 0 0; }
                        .content { background-color: #f8f9fa; padding: 30px; border-radius: 0 0 5px 5px; }
                        .button { display: inline-block; padding: 15px 30px; background-color: #28a745; color: white; text-decoration: none; border-radius: 5px; margin: 20px 0; font-weight: bold; }
                        .footer { margin-top: 20px; font-size: 12px; color: #666; text-align: center; }
                        .link-box { background-color: #e9ecef; padding: 10px; border-radius: 5px; word-break: break-all; font-size: 12px; margin-top: 10px; }
                    </style>
                </head>
                <body>
                    <div class="container">
                        <div class="header">
                            <h1>🚨 SoccorsoWeb</h1>
                        </div>
                        <div class="content">
                            <h2>Ciao %s,</h2>
                            <p>Abbiamo ricevuto la tua <strong>richiesta di soccorso</strong>.</p>
                            <p>Per attivarla, clicca sul pulsante qui sotto:</p>

                            <div style="text-align: center;">
                                <a href="%s" class="button">✅ CONFERMA RICHIESTA</a>
                            </div>

                            <p><strong>Oppure</strong> copia questo link:</p>
                            <div class="link-box">%s</div>

                            <p style="margin-top: 30px; color: #856404; background-color: #fff3cd; padding: 10px; border-radius: 5px;">
                                ⚠️ <strong>Importante:</strong> Se non hai effettuato questa richiesta, ignora questa email.
                            </p>
                        </div>
                        <div class="footer">
                            <p>Questa è un'email automatica.</p>
                            <p>&copy; 2026 SoccorsoWeb</p>
                        </div>
                    </div>
                </body>
                </html>
                """
                .formatted(nomeSegnalante, linkConvalida, linkConvalida);

        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setFrom(fromEmail);
            helper.setTo(toEmail);
            helper.setSubject("⚠️ Conferma la tua richiesta di soccorso");
            helper.setText(htmlContent, true);

            mailSender.send(message);
            log.info("✅ Email inviata a: {}", toEmail);
        } catch (MessagingException e) {
            log.error("❌ Errore invio email: {}", e.getMessage(), e);
            throw new RuntimeException("Impossibile inviare email di convalida", e);
        }
    }

    public void inviaCredenziali(String toEmail, String email, String password) {
        String htmlContent = """
                <!DOCTYPE html>
                <html>
                <head>
                    <meta charset="UTF-8">
                    <style>
                        body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
                        .container { max-width: 600px; margin: 0 auto; padding: 20px; }
                        .header { background-color: #dc3545; color: white; padding: 20px; text-align: center; border-radius: 5px 5px 0 0; }
                        .content { background-color: #f8f9fa; padding: 30px; border-radius: 0 0 5px 5px; }
                        .button { display: inline-block; padding: 15px 30px; background-color: #28a745; color: white; text-decoration: none; border-radius: 5px; margin: 20px 0; font-weight: bold; }
                        .footer { margin-top: 20px; font-size: 12px; color: #666; text-align: center; }
                        .credential-box { background-color: #fff; padding: 15px; border-left: 5px solid #dc3545; margin: 20px 0; }
                    </style>
                </head>
                <body>
                    <div class="container">
                        <div class="header">
                            <h1>🚨 SoccorsoWeb</h1>
                        </div>
                        <div class="content">
                            <h2>Ciao,</h2>
                            <p>Ecco le tue nuove credenziali di accesso al portale <strong>Soccorso Web</strong>.</p>

                            <div class="credential-box">
                                <p><strong>Username:</strong> %s</p>
                                <p><strong>Password:</strong> %s</p>
                            </div>

                            <p>Per la tua sicurezza, ti chiediamo di cambiare la password al primo accesso.</p>

                            <div style="text-align: center; margin: 30px 0;">
                                <a href="http://localhost:8080/auth/login?action=change-password" class="button">🔄 Accedi e Cambia Password</a>
                            </div>

                            <p style="margin-top: 30px; color: #856404; background-color: #fff3cd; padding: 10px; border-radius: 5px;">
                                <strong>Importante:</strong> Non condividere queste credenziali con nessuno.
                            </p>
                        </div>
                        <div class="footer">
                            <p>Questa è un'email automatica.</p>
                            <p>&copy; 2026 SoccorsoWeb</p>
                        </div>
                    </div>
                </body>
                </html>
                """
                .formatted(email, password);

        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setFrom(fromEmail);
            helper.setTo(toEmail);
            helper.setSubject("🔐 Le tue credenziali per Soccorso Web");
            helper.setText(htmlContent, true);

            mailSender.send(message);
            log.info("✅ Email Credenziali inviata a: {}", toEmail);
        } catch (MessagingException e) {
            log.error("❌ Errore invio email: {}", e.getMessage(), e);
            throw new RuntimeException("Impossibile inviare email credenziali", e);
        }
    }

    public void inviaNotificaMissione(User operatore, Missione missione) {
        String htmlContent = """
                <!DOCTYPE html>
                <html>
                <head>
                    <meta charset="UTF-8">
                    <style>
                        body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
                        .container { max-width: 600px; margin: 0 auto; padding: 20px; }
                        .header { background-color: #007bff; color: white; padding: 20px; text-align: center; border-radius: 5px 5px 0 0; }
                        .content { background-color: #f8f9fa; padding: 30px; border-radius: 0 0 5px 5px; }
                        .info-box { background-color: white; padding: 15px; border-left: 5px solid #007bff; margin: 20px 0; border-radius: 0 4px 4px 0; box-shadow: 0 2px 4px rgba(0,0,0,0.05); }
                        .footer { margin-top: 20px; font-size: 12px; color: #666; text-align: center; }
                        .badge { display: inline-block; padding: 4px 8px; background-color: #e7f1ff; color: #007bff; border-radius: 4px; font-weight: bold; font-size: 12px; }
                    </style>
                </head>
                <body>
                    <div class="container">
                        <div class="header">
                            <h1>🚑 Nuova Missione Assegnata</h1>
                        </div>
                        <div class="content">
                            <h2>Ciao %s,</h2>
                            <p>Ti è stata assegnata una nuova missione di soccorso.</p>

                            <div class="info-box">
                                <p><strong>ID Missione:</strong> <span class="badge">#%d</span></p>
                                <p><strong>Obiettivo:</strong> %s</p>
                                <p><strong>Data Inizio:</strong> %s</p>
                            </div>

                            <p>Per maggiori dettagli e per iniziare le operazioni, accedi al portale.</p>

                            <div style="text-align: center; margin: 30px 0;">
                                <a href="http://localhost:8080/operatore/missioni" style="display: inline-block; padding: 15px 30px; background-color: #007bff; color: white; text-decoration: none; border-radius: 5px; font-weight: bold;">Vai alla Missione</a>
                            </div>
                        </div>
                        <div class="footer">
                            <p>Questa è un'email automatica del sistema SoccorsoWeb.</p>
                            <p>&copy; 2026 SoccorsoWeb</p>
                        </div>
                    </div>
                </body>
                </html>
                """
                .formatted(
                        operatore.getNome(),
                        missione.getId(),
                        missione.getObiettivo(),
                        missione.getInizioAt() != null ? missione.getInizioAt().toString() : "N/D");

        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setFrom(fromEmail);
            helper.setTo(operatore.getEmail());
            helper.setSubject("🚨 Nuova Missione Assegnata: #" + missione.getId());
            helper.setText(htmlContent, true);

            mailSender.send(message);
            log.info("✅ Notifica missione inviata a: {}", operatore.getEmail());
        } catch (MessagingException e) {
            log.error("❌ Errore invio notifica missione: {}", e.getMessage());
        }
    }

    /**
     * Invia una notifica di aggiornamento missione a un membro della squadra.
     */
    public void inviaNotificaAggiornamento(User membro, Missione missione, String testoAggiornamento) {
        String htmlContent = """
                <!DOCTYPE html>
                <html>
                <head>
                    <meta charset="UTF-8">
                    <style>
                        body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
                        .container { max-width: 600px; margin: 0 auto; padding: 20px; }
                        .header { background-color: #f59e0b; color: white; padding: 20px; text-align: center; border-radius: 5px 5px 0 0; }
                        .content { background-color: #f8f9fa; padding: 30px; border-radius: 0 0 5px 5px; }
                        .info-box { background-color: white; padding: 15px; border-left: 5px solid #f59e0b; margin: 20px 0; border-radius: 0 4px 4px 0; box-shadow: 0 2px 4px rgba(0,0,0,0.05); }
                        .footer { margin-top: 20px; font-size: 12px; color: #666; text-align: center; }
                        .badge { display: inline-block; padding: 4px 8px; background-color: #fef3c7; color: #92400e; border-radius: 4px; font-weight: bold; font-size: 12px; }
                    </style>
                </head>
                <body>
                    <div class="container">
                        <div class="header">
                            <h1>📋 Aggiornamento Missione</h1>
                        </div>
                        <div class="content">
                            <h2>Ciao %s,</h2>
                            <p>C'è un nuovo aggiornamento per la missione a cui sei assegnato.</p>

                            <div class="info-box">
                                <p><strong>Missione:</strong> <span class="badge">#%d</span></p>
                                <p><strong>Obiettivo:</strong> %s</p>
                                <p><strong>Aggiornamento:</strong></p>
                                <p style="margin-top: 8px; padding: 10px; background: #f3f4f6; border-radius: 4px;">%s</p>
                            </div>

                            <div style="text-align: center; margin: 30px 0;">
                                <a href="http://localhost:8080/operatore/missioni" style="display: inline-block; padding: 15px 30px; background-color: #f59e0b; color: white; text-decoration: none; border-radius: 5px; font-weight: bold;">Vedi Dettagli</a>
                            </div>
                        </div>
                        <div class="footer">
                            <p>Questa è un'email automatica del sistema SoccorsoWeb.</p>
                            <p>&copy; 2026 SoccorsoWeb</p>
                        </div>
                    </div>
                </body>
                </html>
                """
                .formatted(
                        membro.getNome(),
                        missione.getId(),
                        missione.getObiettivo(),
                        testoAggiornamento);

        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setFrom(fromEmail);
            helper.setTo(membro.getEmail());
            helper.setSubject("📋 Aggiornamento Missione #" + missione.getId());
            helper.setText(htmlContent, true);

            mailSender.send(message);
            log.info("✅ Notifica aggiornamento inviata a: {}", membro.getEmail());
        } catch (MessagingException e) {
            log.error("❌ Errore invio notifica aggiornamento: {}", e.getMessage());
        }
    }
}
