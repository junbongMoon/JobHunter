package com.jobhunter.util;

import java.io.InputStream;

import org.springframework.beans.factory.InitializingBean;
import org.springframework.stereotype.Component;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;

@Component
public class FirebaseInitializer implements InitializingBean {

    @Override
    public void afterPropertiesSet() {
        try {
            InputStream serviceAccount = getClass()
                    .getClassLoader()
                    .getResourceAsStream("config/jobhunter-672dd-firebase-adminsdk-fbsvc-d8db3a4148.json");

            if (serviceAccount == null) {
                throw new IllegalStateException("Firebase 서비스 계정 키 파일을 찾을 수 없습니다.");
            }

            FirebaseOptions options = FirebaseOptions.builder()
                    .setCredentials(GoogleCredentials.fromStream(serviceAccount))
                    .build();

            if (FirebaseApp.getApps().isEmpty()) {
                FirebaseApp.initializeApp(options);
                System.out.println("[Firebase] FirebaseApp 초기화 완료");
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new IllegalStateException("[Firebase 초기화 실패]", e);
        }
    }
}
