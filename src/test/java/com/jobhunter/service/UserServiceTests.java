package com.jobhunter.service;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.jobhunter.dao.user.UserDAO;

import lombok.RequiredArgsConstructor;

@RunWith(SpringJUnit4ClassRunner.class) // 아래의 객체가 Junit4 클래스와 함께 동작하도록
@ContextConfiguration( // 설정 파일의 위치 (여기에서는 dataSource객체가 생성된 root-context.xml의 위치)
      locations = { "file:src/main/webapp/WEB-INF/spring/**/root-context.xml" })

public class UserServiceTests {
	
	
	
}
