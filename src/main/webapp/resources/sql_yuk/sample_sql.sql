use koreaite;
CREATE TABLE `advantage` (
  `advantageNo` int(11) NOT NULL AUTO_INCREMENT,
  `advantageType` varchar(100) NOT NULL,
  `recruitmentNoticeUid` int(11) DEFAULT NULL,
  PRIMARY KEY (`advantageNo`),
  KEY `fk_advantage_recruitmentNotice_idx` (`recruitmentNoticeUid`),
  CONSTRAINT `fk_advantage_recruitmentNotice` FOREIGN KEY (`recruitmentNoticeUid`) REFERENCES `recruitmentnotice` (`uid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `application` (
  `applicationNo` int(11) NOT NULL AUTO_INCREMENT,
  `method` enum('ONLINE','EMAIL','PHONE','TEXT') NOT NULL,
  `detail` text NOT NULL,
  `recruitmentNoticeUid` int(11) DEFAULT NULL,
  PRIMARY KEY (`applicationNo`),
  KEY `fk_application_recruitmentNotice_idx` (`recruitmentNoticeUid`),
  CONSTRAINT `fk_application_recruitmentNotice` FOREIGN KEY (`recruitmentNoticeUid`) REFERENCES `recruitmentnotice` (`uid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `company` (
  `uid` int(11) NOT NULL AUTO_INCREMENT,
  `companyName` varchar(30) DEFAULT NULL,
  `companyId` varchar(30) DEFAULT NULL,
  `password` varchar(50) DEFAULT NULL,
  `businessNum` varchar(20) DEFAULT NULL,
  `representative` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `mobile` varchar(16) DEFAULT NULL,
  `addr` varchar(190) DEFAULT NULL,
  `accountType` enum('COMPANY') NOT NULL DEFAULT 'COMPANY',
  `regDate` datetime DEFAULT CURRENT_TIMESTAMP,
  `autoLogin` varchar(190) DEFAULT NULL,
  `requiresVerification` varchar(1) DEFAULT 'N',
  `blockDeadline` datetime DEFAULT NULL,
  `deleteDeadline` datetime DEFAULT NULL,
  `blockReason` varchar(100) DEFAULT NULL,
  `loginCnt` int(11) DEFAULT '0',
  `lastLoginDate` datetime DEFAULT CURRENT_TIMESTAMP,
  `introduce` text,
  `scale` varchar(20) DEFAULT NULL,
  `homePage` varchar(190) DEFAULT NULL,
  PRIMARY KEY (`uid`),
  UNIQUE KEY `companyId` (`companyId`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `mobile` (`mobile`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

CREATE TABLE `contact` (
  `contactNo` int(11) NOT NULL AUTO_INCREMENT,
  `contactType` varchar(50) NOT NULL,
  `contactValue` varchar(100) NOT NULL,
  `companyUid` int(11) NOT NULL,
  PRIMARY KEY (`contactNo`),
  KEY `fk_contact_company` (`companyUid`),
  CONSTRAINT `fk_contact_company` FOREIGN KEY (`companyUid`) REFERENCES `company` (`uid`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `education` (
  `educationNo` int(11) NOT NULL AUTO_INCREMENT,
  `educationLevel` enum('HIGH_SCHOOL','JUNIOR_COLLEGE','UNIVERSITY','GRADUATE') NOT NULL,
  `educationStatus` enum('GRADUATED','ENROLLED','ON_LEAVE','DROPPED_OUT') NOT NULL,
  `customInput` varchar(190) NOT NULL,
  `resumeNo` int(11) DEFAULT NULL,
  PRIMARY KEY (`educationNo`),
  KEY `education_resumeNo_fk_idx` (`resumeNo`),
  CONSTRAINT `education_resumeNo_fk` FOREIGN KEY (`resumeNo`) REFERENCES `resume` (`resumeNo`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `jobform` (
  `jobFormNo` int(11) NOT NULL AUTO_INCREMENT,
  `Form` enum('FULL_TIME','CONTRACT','DISPATCH','PART_TIME','COMMISSION','FREELANCE') NOT NULL,
  `resumeNo` int(11) DEFAULT NULL,
  PRIMARY KEY (`jobFormNo`),
  KEY `jobform_refResumeNo_fk_idx` (`resumeNo`),
  CONSTRAINT `jobform_ResumeNo_fk` FOREIGN KEY (`resumeNo`) REFERENCES `resume` (`resumeNo`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8;

CREATE TABLE `jobtype_recruit_major` (
  `jt_rec_majorNo` int(11) NOT NULL AUTO_INCREMENT,
  `refRecNo` int(11) NOT NULL,
  `refMajorNo` int(11) NOT NULL,
  PRIMARY KEY (`jt_rec_majorNo`),
  KEY `JTRECMJ_refMajorNo_fk` (`refMajorNo`),
  KEY `JTRECMJ_refRecNo_fk` (`refRecNo`),
  CONSTRAINT `JTRECMJ_refMajorNo_fk` FOREIGN KEY (`refMajorNo`) REFERENCES `majorcategory` (`MajorcategoryNo`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `JTRECMJ_refRecNo_fk` FOREIGN KEY (`refRecNo`) REFERENCES `recruitmentnotice` (`uid`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `jobtype_recruit_sub` (
  `jt_rec_subNo` int(11) NOT NULL AUTO_INCREMENT,
  `refRecNo` int(11) NOT NULL,
  `refSubNo` int(11) NOT NULL,
  PRIMARY KEY (`jt_rec_subNo`),
  KEY `JTRECSUB_refRecNo_fk` (`refRecNo`),
  KEY `JTRECSUB_refSubNo_fk` (`refSubNo`),
  CONSTRAINT `JTRECSUB_refRecNo_fk` FOREIGN KEY (`refRecNo`) REFERENCES `recruitmentnotice` (`uid`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `JTRECSUB_refSubNo_fk` FOREIGN KEY (`refSubNo`) REFERENCES `subcategory` (`subcategoryNo`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `jobtype_resume_major` (
  `jt_resume_majorNo` int(11) NOT NULL AUTO_INCREMENT,
  `refResumeNo` int(11) NOT NULL,
  `refMajorNo` int(11) NOT NULL,
  PRIMARY KEY (`jt_resume_majorNo`),
  KEY `JTREMJ_refResumeNo_fk_idx` (`refResumeNo`),
  KEY `JTREMJ_refMJNo_fk_idx` (`refMajorNo`),
  CONSTRAINT `JTREMJ_refMJNo_fk` FOREIGN KEY (`refMajorNo`) REFERENCES `majorcategory` (`MajorcategoryNo`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `JTREMJ_refResumeNo_fk` FOREIGN KEY (`refResumeNo`) REFERENCES `resume` (`resumeNo`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `jobtype_resume_sub` (
  `jt_resume_subNo` int(11) NOT NULL AUTO_INCREMENT,
  `refResumeNo` int(11) NOT NULL,
  `refSubNo` int(11) NOT NULL,
  PRIMARY KEY (`jt_resume_subNo`),
  KEY `JTRESUB_refResumeNo_fk` (`refResumeNo`),
  KEY `JTRESUB_refSubNo_fk` (`refSubNo`),
  CONSTRAINT `JTRESUB_refResumeNo_fk` FOREIGN KEY (`refResumeNo`) REFERENCES `resume` (`resumeNo`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `JTRESUB_refSubNo_fk` FOREIGN KEY (`refSubNo`) REFERENCES `subcategory` (`subcategoryNo`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;

CREATE TABLE `licence` (
  `licenceNo` int(11) NOT NULL AUTO_INCREMENT,
  `licenceName` varchar(190) NOT NULL,
  `licencecol` datetime DEFAULT NULL,
  `resumeNo` int(11) DEFAULT NULL,
  PRIMARY KEY (`licenceNo`),
  KEY `licence_resumeNo_fk_idx` (`resumeNo`),
  CONSTRAINT `licence_resumeNo_fk` FOREIGN KEY (`resumeNo`) REFERENCES `resume` (`resumeNo`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `majorcategory` (
  `majorcategoryNo` int(11) NOT NULL AUTO_INCREMENT,
  `jobName` varchar(100) NOT NULL,
  PRIMARY KEY (`majorcategoryNo`)
) ENGINE=InnoDB AUTO_INCREMENT=134 DEFAULT CHARSET=utf8;

CREATE TABLE `merit` (
  `meritNo` int(11) NOT NULL AUTO_INCREMENT,
  `meritContent` varchar(100) NOT NULL,
  `resumeNo` int(11) DEFAULT NULL,
  PRIMARY KEY (`meritNo`),
  KEY `merit_refResumeNo_fk_idx` (`resumeNo`),
  CONSTRAINT `merit_refResumeNo_fk` FOREIGN KEY (`resumeNo`) REFERENCES `resume` (`resumeNo`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `personalhistory` (
  `historyNo` int(11) NOT NULL AUTO_INCREMENT,
  `companyName` varchar(190) NOT NULL,
  `position` varchar(100) NOT NULL,
  `jobDescription` varchar(100) NOT NULL,
  `startDate` date NOT NULL,
  `endDate` date DEFAULT NULL,
  `resumeNo` int(11) DEFAULT NULL,
  PRIMARY KEY (`historyNo`),
  KEY `personalHistory_resumeNo_idx` (`resumeNo`),
  CONSTRAINT `personalHistory_resumeNo` FOREIGN KEY (`resumeNo`) REFERENCES `resume` (`resumeNo`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `recruitmentnotice` (
  `uid` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(190) DEFAULT NULL,
  `workType` varchar(45) DEFAULT NULL,
  `payType` varchar(20) DEFAULT NULL,
  `pay` int(11) DEFAULT NULL,
  `period` varchar(20) DEFAULT NULL,
  `personalHistory` varchar(45) DEFAULT NULL,
  `militaryService` enum('NOT_SERVED','SERVED','EXEMPTED') DEFAULT NULL,
  `detail` text,
  `manager` varchar(100) DEFAULT NULL,
  `miniTitle` varchar(190) DEFAULT NULL,
  `dueDate` datetime DEFAULT NULL,
  `status` varchar(1) DEFAULT NULL,
  `count` int(11) DEFAULT '0',
  `refCompany` int(11) DEFAULT NULL,
  PRIMARY KEY (`uid`),
  KEY `fk_recruitmentNotice_refCompany` (`refCompany`),
  CONSTRAINT `fk_recruitmentNotice_refCompany` FOREIGN KEY (`refCompany`) REFERENCES `company` (`uid`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

CREATE TABLE `recruitmentnoticeboardupfiles` (
  `boardUpFileNo` int(11) NOT NULL AUTO_INCREMENT,
  `originalFileName` text NOT NULL,
  `newFileName` text NOT NULL,
  `ext` varchar(4) DEFAULT NULL,
  `size` int(11) DEFAULT NULL,
  `base64Image` text,
  `refrecruitmentnoticeNo` int(11) DEFAULT NULL,
  PRIMARY KEY (`boardUpFileNo`),
  KEY `recboardupfiles_refRecNo_fk_idx` (`refrecruitmentnoticeNo`),
  CONSTRAINT `recboardupfiles_refRecNo_fk` FOREIGN KEY (`refrecruitmentnoticeNo`) REFERENCES `recruitmentnotice` (`uid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='공고에 업로드되는 파일';

CREATE TABLE `region` (
  `regionNo` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(100) NOT NULL,
  `name` varchar(20) NOT NULL,
  PRIMARY KEY (`regionNo`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8;

CREATE TABLE `registration` (
  `registrationNo` int(11) NOT NULL AUTO_INCREMENT,
  `status` enum('Y','N','C','W') NOT NULL DEFAULT 'W',
  `recruitmentNoticePk` int(11) NOT NULL,
  `regDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `resumePk` int(11) NOT NULL,
  PRIMARY KEY (`registrationNo`),
  KEY `fk_registration_resume_idx` (`resumePk`),
  KEY `fk_registration_recruitment_idx` (`recruitmentNoticePk`),
  CONSTRAINT `fk_registration_recruitment` FOREIGN KEY (`recruitmentNoticePk`) REFERENCES `recruitmentnotice` (`uid`),
  CONSTRAINT `fk_registration_resume` FOREIGN KEY (`resumePk`) REFERENCES `resume` (`resumeNo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `resume` (
  `resumeNo` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(45) NOT NULL,
  `payType` varchar(20) DEFAULT NULL,
  `pay` int(11) DEFAULT NULL,
  `introduce` text,
  `saveType` enum('TEMP','FINAL') DEFAULT NULL,
  `userUid` int(11) DEFAULT NULL,
  PRIMARY KEY (`resumeNo`),
  KEY `fk_resume_userPk` (`userUid`),
  CONSTRAINT `fk_resume_userPk` FOREIGN KEY (`userUid`) REFERENCES `users` (`uid`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8;

CREATE TABLE `resumeupfiles` (
  `boardUpFileNo` int(11) NOT NULL AUTO_INCREMENT,
  `originalFileName` text NOT NULL,
  `newFileName` text NOT NULL,
  `ext` varchar(4) DEFAULT NULL,
  `size` int(11) DEFAULT NULL,
  `base64Image` text,
  `refResumeNo` int(11) DEFAULT NULL,
  PRIMARY KEY (`boardUpFileNo`),
  KEY `resboardupfiles_refResNo_fk_idx` (`refResumeNo`),
  CONSTRAINT `resboardupfiles_refResNo_fk` FOREIGN KEY (`refResumeNo`) REFERENCES `resume` (`resumeNo`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='이력서에 업로드되는 파일';

CREATE TABLE `reviewBoard` (
  `boardNo` int(11) NOT NULL AUTO_INCREMENT,
  `gonggoUid` int(11) DEFAULT NULL,
  `writer` int(11) DEFAULT NULL,
  `companyName` varchar(100) NOT NULL,
  `reviewResult` enum('PASSED','FAILED','PENDING') NOT NULL,
  `reviewType` enum('FACE_TO_FACE','VIDEO','PHONE','OTHER') NOT NULL,
  `reviewLevel` int(11) NOT NULL,
  `content` text NOT NULL,
  `category` varchar(20) NOT NULL,
  `jobType` enum('FULL_TIME','CONTRACT','INTERN','FREELANCER') NOT NULL,
  `postDate` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `likes` int(11) DEFAULT '0',
  `views` int(11) DEFAULT '0',
  PRIMARY KEY (`boardNo`),
  KEY `recruitmentNotice_gonggoUid_fk` (`gonggoUid`),
  KEY `reviewboard_ibfk_1` (`writer`),
  CONSTRAINT `recruitmentNotice_gonggoUid_fk` FOREIGN KEY (`gonggoUid`) REFERENCES `recruitmentnotice` (`uid`),
  CONSTRAINT `reviewboard_ibfk_1` FOREIGN KEY (`writer`) REFERENCES `users` (`uid`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

CREATE TABLE `reviewLikes` (
  `likeId` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) NOT NULL,
  `boardNo` int(11) NOT NULL,
  `createdAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`likeId`),
  KEY `userId` (`userId`),
  KEY `boardNo` (`boardNo`),
  CONSTRAINT `reviewlikes_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `users` (`uid`) ON DELETE CASCADE,
  CONSTRAINT `reviewlikes_ibfk_2` FOREIGN KEY (`boardNo`) REFERENCES `reviewBoard` (`boardNo`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `reviewViews` (
  `viewId` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) NOT NULL,
  `boardNo` int(11) NOT NULL,
  `viewedAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`viewId`),
  UNIQUE KEY `userId` (`userId`,`boardNo`),
  KEY `boardNo` (`boardNo`),
  CONSTRAINT `reviewviews_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `users` (`uid`) ON DELETE CASCADE,
  CONSTRAINT `reviewviews_ibfk_2` FOREIGN KEY (`boardNo`) REFERENCES `reviewBoard` (`boardNo`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `sigungu` (
  `sigunguNo` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(100) NOT NULL,
  `name` varchar(100) NOT NULL,
  `regionNo` int(11) DEFAULT NULL,
  PRIMARY KEY (`sigunguNo`),
  KEY `sigungu_regionNo_fk_idx` (`regionNo`),
  CONSTRAINT `sigungu_regionNo_fk` FOREIGN KEY (`regionNo`) REFERENCES `region` (`regionNo`)
) ENGINE=InnoDB AUTO_INCREMENT=285 DEFAULT CHARSET=utf8;

CREATE TABLE `status` (
  `statusNo` int(11) NOT NULL AUTO_INCREMENT,
  `statusDate` datetime DEFAULT CURRENT_TIMESTAMP,
  `total_users` int(11) DEFAULT NULL,
  `new_users` int(11) DEFAULT NULL,
  `total_companies` int(11) DEFAULT NULL,
  `new_companies` int(11) DEFAULT NULL,
  `new_recruitmentNoticeCnt` int(11) DEFAULT NULL,
  `total_recruitmentNoticeCnt` int(11) DEFAULT NULL,
  `new_resume` int(11) DEFAULT NULL,
  `total_resume` int(11) DEFAULT NULL,
  PRIMARY KEY (`statusNo`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

CREATE TABLE `subcategory` (
  `subcategoryNo` int(11) NOT NULL AUTO_INCREMENT,
  `refMajorcategoryNo` int(11) DEFAULT NULL,
  `jobName` varchar(100) NOT NULL,
  PRIMARY KEY (`subcategoryNo`),
  KEY `subcategory_refMajorcategoryNo_fk_idx` (`refMajorcategoryNo`),
  CONSTRAINT `subcategory_refMajorcategoryNo_fk` FOREIGN KEY (`refMajorcategoryNo`) REFERENCES `majorcategory` (`MajorcategoryNo`)
) ENGINE=InnoDB AUTO_INCREMENT=538 DEFAULT CHARSET=utf8;

CREATE TABLE `users` (
  `uid` int(11) NOT NULL AUTO_INCREMENT,
  `userName` varchar(100) NOT NULL,
  `userId` varchar(30) DEFAULT NULL,
  `socialId` bigint(20) DEFAULT NULL,
  `password` varchar(50) DEFAULT NULL,
  `mobile` varchar(20) DEFAULT NULL,
  `email` varchar(190) DEFAULT NULL,
  `addr` varchar(190) DEFAULT NULL,
  `gender` enum('MALE','FEMALE') NOT NULL,
  `age` int(11) DEFAULT NULL,
  `regDate` datetime DEFAULT CURRENT_TIMESTAMP,
  `autoLogin` varchar(190) DEFAULT NULL,
  `accountType` enum('USER','ADMIN') NOT NULL DEFAULT 'USER',
  `requiresVerification` varchar(1) DEFAULT 'N',
  `blockDeadline` datetime DEFAULT NULL,
  `deleteDeadline` datetime DEFAULT NULL,
  `blockReason` varchar(100) DEFAULT NULL,
  `loginCnt` int(11) DEFAULT '0',
  `lastLoginDate` datetime DEFAULT CURRENT_TIMESTAMP,
  `payType` varchar(20) DEFAULT NULL,
  `pay` int(11) DEFAULT NULL,
  `introduce` text,
  `isSocial` varchar(1) DEFAULT 'N',
  `militaryService` enum('NOT_SERVED','SERVED','EXEMPTED') DEFAULT NULL,
  `nationality` enum('DOMESTIC','FOREIGN') DEFAULT NULL,
  `disability` varchar(6) DEFAULT NULL,
  PRIMARY KEY (`uid`),
  UNIQUE KEY `userId` (`userId`),
  UNIQUE KEY `socialId` (`socialId`),
  UNIQUE KEY `mobile` (`mobile`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

CREATE TABLE `where_recruit_region` (
  `where_recruit_regionNo` int(11) NOT NULL AUTO_INCREMENT,
  `refRecNo` int(11) NOT NULL,
  `refRegion` int(11) NOT NULL,
  PRIMARY KEY (`where_recruit_regionNo`),
  KEY `whereRecRg_refRegNo_fk` (`refRegion`),
  KEY `whereRecRg_refRecNo_fk` (`refRecNo`),
  CONSTRAINT `whereRecRg_refRecNo_fk` FOREIGN KEY (`refRecNo`) REFERENCES `recruitmentnotice` (`uid`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `whereRecRg_refRegNo_fk` FOREIGN KEY (`refRegion`) REFERENCES `region` (`regionNo`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `where_recruit_sigungu` (
  `where_recruit_sigunguNo` int(11) NOT NULL AUTO_INCREMENT,
  `refRecNo` int(11) NOT NULL,
  `refSigungu` int(11) NOT NULL,
  PRIMARY KEY (`where_recruit_sigunguNo`),
  KEY `whereRecSGG_refRecNo_fk` (`refRecNo`),
  KEY `whereRecSGG_refSGGNo_fk` (`refSigungu`),
  CONSTRAINT `whereRecSGG_refRecNo_fk` FOREIGN KEY (`refRecNo`) REFERENCES `recruitmentnotice` (`uid`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `whereRecSGG_refSGGNo_fk` FOREIGN KEY (`refSigungu`) REFERENCES `sigungu` (`sigunguNo`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `where_resume_region` (
  `where_resume_regionNo` int(11) NOT NULL AUTO_INCREMENT,
  `refRegionNo` int(11) NOT NULL,
  `refResumeNo` int(11) NOT NULL,
  PRIMARY KEY (`where_resume_regionNo`),
  KEY `whereResRg_refresumeNo_fk` (`refResumeNo`),
  KEY `whereResRg_refregionNo_fk` (`refRegionNo`),
  CONSTRAINT `whereResRg_refregionNo_fk` FOREIGN KEY (`refRegionNo`) REFERENCES `region` (`regionNo`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `whereResRg_refresumeNo_fk` FOREIGN KEY (`refResumeNo`) REFERENCES `resume` (`resumeNo`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `where_resume_sigungu` (
  `where_resume_sigunguNo` int(11) NOT NULL AUTO_INCREMENT,
  `refSigunguNo` int(11) NOT NULL,
  `refResumeNo` int(11) NOT NULL,
  PRIMARY KEY (`where_resume_sigunguNo`),
  KEY `whereResSG_refResumeNo_fk` (`refResumeNo`),
  KEY `whereResSG_refSigunguNo_fk` (`refSigunguNo`),
  CONSTRAINT `whereResSG_refResumeNo_fk` FOREIGN KEY (`refResumeNo`) REFERENCES `resume` (`resumeNo`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `whereResSG_refSigunguNo_fk` FOREIGN KEY (`refSigunguNo`) REFERENCES `sigungu` (`sigunguNo`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8;


SELECT 
    u.*, 
    r.resumeNo AS r_resumeNo, r.title AS r_title, r.payType AS r_payType, r.pay AS r_pay, r.introduce AS r_introduce, 
    r.saveType AS r_saveType,
    
    reg.registrationNo AS reg_no, reg.status AS reg_status, reg.recruitmentNoticePk AS reg_notice, reg.regDate AS reg_date,
    
    rb.boardNo AS rb_boardNo, rb.companyName AS rb_companyName, rb.reviewResult, rb.reviewType, 
    rb.reviewLevel, rb.content AS rb_content, rb.category AS rb_category, rb.jobType AS rb_jobType, 
    rb.postDate AS rb_postDate, rb.likes AS rb_likes, rb.views AS rb_views,
    
    rl.likeId AS rl_likeId, rl.boardNo AS rl_boardNo, rl.createdAt AS rl_createdAt,
    
    rv.viewId AS rv_viewId, rv.boardNo AS rv_boardNo, rv.viewedAt AS rv_viewedAt

FROM users u
LEFT JOIN resume r ON u.uid = r.userUid
LEFT JOIN registration reg ON r.resumeNo = reg.resumePk
LEFT JOIN reviewBoard rb ON u.uid = rb.writer
LEFT JOIN reviewLikes rl ON u.uid = rl.userId
LEFT JOIN reviewViews rv ON u.uid = rv.userId;