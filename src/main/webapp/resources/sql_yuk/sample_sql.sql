use koreaite;

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
  `userType` enum('NORMAL','ADMIN') NOT NULL,
  `requiresVerification` varchar(1) DEFAULT 'N',
  `blockDeadline` datetime DEFAULT NULL,
  `deleteDeadline` datetime DEFAULT NULL,
  `blockReason` varchar(100) DEFAULT NULL,
  `loginCnt` int(11) DEFAULT '0',
  `lastLoginDate` datetime DEFAULT CURRENT_TIMESTAMP,
  `payType` varchar(20) DEFAULT NULL,
  `pay` int(11) DEFAULT NULL,
  `introduce` text,
  `isSocial` varchar(1) DEFAULT 'Y',
  `militaryService` enum('NOT_SERVED','SERVED','EXEMPTED') DEFAULT NULL,
  `nationality` enum('DOMESTIC','FOREIGN') DEFAULT NULL,
  `disability` varchar(6) DEFAULT NULL,
  PRIMARY KEY (`uid`),
  UNIQUE KEY `userId` (`userId`),
  UNIQUE KEY `socialId` (`socialId`),
  UNIQUE KEY `mobile` (`mobile`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `company` (
  `uid` int(11) NOT NULL AUTO_INCREMENT,
  `companyName` varchar(30) DEFAULT NULL,
  `companyId` varchar(30) DEFAULT NULL,
  `companyPwd` varchar(50) DEFAULT NULL,
  `businessNum` varchar(20) DEFAULT NULL,
  `representative` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `mobile` varchar(16) DEFAULT NULL,
  `addr` varchar(190) DEFAULT NULL,
  `userType` enum('COMPANY','ADMIN') NOT NULL,
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `reviewBoard` (
  `boardNo` int NOT NULL AUTO_INCREMENT,
  `gonggoUid` int DEFAULT NULL,
  `writer` int DEFAULT NULL,
  `companyName` varchar(100) NOT NULL,
  `reviewResult` enum('PASSED', 'FAILED', 'PENDING') NOT NULL,
  `reviewType` enum('FACE_TO_FACE', 'VIDEO', 'PHONE', 'OTHER') NOT NULL,
  `reviewLevel` int NOT NULL,
  `content` text NOT NULL,
  `category` varchar(20) NOT NULL,
  `jobType` enum('FULL_TIME', 'CONTRACT', 'INTERN', 'FREELANCER') NOT NULL,
  `postDate` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `likes` int DEFAULT '0',
  `views` int DEFAULT '0',
  PRIMARY KEY (`boardNo`),
  CONSTRAINT `recruitmentNotice_gonggoUid_fk` FOREIGN KEY (`gonggoUid`) REFERENCES `recruitmentnotice` (`uid`),
  CONSTRAINT `reviewboard_ibfk_1` FOREIGN KEY (`writer`) REFERENCES `users` (`uid`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `reviewLikes` (
  `likeId` int NOT NULL AUTO_INCREMENT,
  `userId` int NOT NULL,
  `boardNo` int NOT NULL,
  `createdAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`likeId`),
  KEY `userId` (`userId`),
  KEY `boardNo` (`boardNo`),
  CONSTRAINT `reviewlikes_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `users` (`uid`) ON DELETE CASCADE,
  CONSTRAINT `reviewlikes_ibfk_2` FOREIGN KEY (`boardNo`) REFERENCES `reviewBoard` (`boardNo`) ON DELETE CASCADE
);

CREATE TABLE `reviewViews` (
  `viewId` int NOT NULL AUTO_INCREMENT,
  `userId` int NOT NULL,
  `boardNo` int NOT NULL,
  `viewedAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`viewId`),
  UNIQUE KEY `userId` (`userId`,`boardNo`),
  KEY `boardNo` (`boardNo`),
  CONSTRAINT `reviewviews_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `users` (`uid`) ON DELETE CASCADE,
  CONSTRAINT `reviewviews_ibfk_2` FOREIGN KEY (`boardNo`) REFERENCES `reviewBoard` (`boardNo`) ON DELETE CASCADE
);

select requiresVerification from `users` where userId = 'tester123';

INSERT INTO `koreaite`.`users` (`userName`, `userId`, `password`, `mobile`, `email`) VALUES ('tester', 'tester123', sha1(md5('tester123')), '010-1234-5678', 'tester123@tester.com');

select loginCnt from `users` where userId = 'tester123';
UPDATE `users` SET loginCnt = loginCnt + 1 WHERE userId = 'tester123';

select * from `koreaite`.`users` where userId = 'tester123' and password = sha1(md5('tester123'));
