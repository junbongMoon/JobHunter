package com.jobhunter.scheduler;

import org.springframework.stereotype.Component;

@Component
//@EnableScheduling
public class SampleScheduler {
   
   

   // 스케쥴러 : 백그라운드 작업 스케쥴링 기능(특정 시간 간격이나 지정된 시간에 배치처리, 데이터백업, 로깅 처리)등을 실행할 수 있도록..
   // fixedRate : 일정시간 간격마다 실행(ms 단위)
   // cron 표현식 : 초 분  시  일  월  요일 
//   @Scheduled(cron="0 0 1 5 * *")
//   public void sampleScheduling() {
//      System.out.println("스케쥴링!");
//   
//   }
   
}
