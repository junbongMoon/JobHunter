package com.jobhunter.util;

import java.io.IOException;
import java.util.Properties;

import javax.mail.Authenticator;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMessage.RecipientType;

public class SendMailService {
	private String mailTo; // 수신자
	private String authCode; // 인증 코드

	public SendMailService(String mailTo, String authCode) {
		super();
		this.mailTo = mailTo;
		this.authCode = authCode;
	}

	public void send() throws IOException, MessagingException {
		String subject = "jobhunter.com에서 보내는 이메일 인증번호입니다";
		String message = "인증번호 : [" + this.authCode + "]를 입력하시고, 인증 버튼을 눌러 인증을 완료해주세요.";

		// SMTP(Send Mail Transfer Protocol) 설정을 위해
		Properties props = new Properties();

		props.put("mail.smtp.host", "smtp.naver.com"); // smtp 호스트 주소 등록
		props.put("mail.smtp.port", "465"); // naver smtp의 포트번호
		props.put("mail.smtp.ssl.protocols", "TLSv1.2");
		props.put("mail.smtp.ssl.enable", "true"); // SSL 사용
		props.put("mail.smtp.auth", "true"); // 인증 과정을 거치겠다.

		// SMTP서버에 인증
		// 메일주소, 비밀번호를 properties 파일에서 얻어오도록...

		String mailId = PropertiesTask.getPropertiesValue("config/mail.properties", "mailID");
		String mailPwd = PropertiesTask.getPropertiesValue("config/mail.properties", "mailPwd");
		
		// 메일 서버에 로그인 할 수 잇는 세션을 얻어옴
		Session mailServerSession = Session.getInstance(props, new Authenticator() {

			@Override
			protected PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication(mailId, mailPwd);
			}

		});


		if (mailServerSession != null) {
			MimeMessage mime = new MimeMessage(mailServerSession);

			mime.setFrom(new InternetAddress(mailId)); // 발신자 메일주소
			mime.addRecipient(RecipientType.TO, new InternetAddress(mailTo)); // 수신자 메일주소

			// 제목, 본문 설정
			mime.setSubject(subject, "utf-8");
			mime.setText(message, "utf-8");

			Transport trans = mailServerSession.getTransport("smtp");
			trans.connect(mailId, mailPwd);
			trans.send(mime);
			trans.close();
		}

	}

}
