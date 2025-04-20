package com.jobhunter.aop;

import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.*;
import org.springframework.stereotype.Component;

@Slf4j
@Aspect
@Component
public class LogAspect {

    @Before("execution(* com.jobhunter.service..*(..))")
    public void logBefore(JoinPoint joinPoint) {
        log.info("🔍 AOP 실행: {}", joinPoint.getSignature().toShortString());
    }

    
}
