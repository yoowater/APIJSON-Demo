-- MySQL dump 10.13  Distrib 5.7.17, for macos10.12 (x86_64)
--
-- Host: apijson.cn    Database: sys
-- ------------------------------------------------------
-- Server version	5.7.34-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Request`
--

DROP TABLE IF EXISTS `Request`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Request` (
  `id` bigint(15) NOT NULL AUTO_INCREMENT COMMENT '唯一标识',
  `version` tinyint(4) NOT NULL DEFAULT '1' COMMENT 'GET,HEAD可用任意结构访问任意开放内容，不需要这个字段。\n其它的操作因为写入了结构和内容，所以都需要，按照不同的version选择对应的structure。\n\n自动化版本管理：\nRequest JSON最外层可以传  “version”:Integer 。\n1.未传或 <= 0，用最新版。 “@order”:”version-“\n2.已传且 > 0，用version以上的可用版本的最低版本。 “@order”:”version+”, “version{}”:”>={version}”',
  `method` varchar(10) DEFAULT 'GETS' COMMENT '只限于GET,HEAD外的操作方法。',
  `tag` varchar(20) NOT NULL COMMENT '标签',
  `structure` json NOT NULL COMMENT '结构。\nTODO 里面的 PUT 改为 UPDATE，避免和请求 PUT 搞混。',
  `detail` varchar(10000) DEFAULT NULL COMMENT '详细说明',
  `date` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建日期',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=58 DEFAULT CHARSET=utf8 COMMENT='请求参数校验配置(必须)。\n最好编辑完后删除主键，这样就是只读状态，不能随意更改。需要更改就重新加上主键。\n\n每次启动服务器时加载整个表到内存。\n这个表不可省略，model内注解的权限只是客户端能用的，其它可以保证即便服务端代码错误时也不会误删数据。';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Request`
--

LOCK TABLES `Request` WRITE;
/*!40000 ALTER TABLE `Request` DISABLE KEYS */;
INSERT INTO `Request` VALUES (1,1,'POST','register','{\"User\": {\"MUST\": \"name\", \"REFUSE\": \"id\", \"UPDATE\": {\"id@\": \"Privacy/id\"}}, \"Privacy\": {\"MUST\": \"_password,phone\", \"REFUSE\": \"id\", \"UNIQUE\": \"phone\", \"VERIFY\": {\"phone~\": \"PHONE\"}}}','UNIQUE校验phone是否已存在。VERIFY校验phone是否符合手机号的格式','2017-02-01 11:19:51'),(2,1,'POST','Moment','{\"INSERT\": {\"@role\": \"OWNER\", \"pictureList\": [], \"praiseUserIdList\": []}, \"REFUSE\": \"id\", \"UPDATE\": {\"verifyIdList-()\": \"verifyIdList(praiseUserIdList)\", \"verifyURLList-()\": \"verifyURLList(pictureList)\"}}','INSERT当没传pictureList和praiseUserIdList时用空数组[]补全，保证不会为null','2017-02-01 11:19:51'),(3,1,'POST','Comment','{\"MUST\": \"momentId,content\", \"REFUSE\": \"id\", \"UPDATE\": {\"@role\": \"OWNER\"}}','必须传userId,momentId,content，不允许传id','2017-02-01 11:19:51'),(4,1,'PUT','User','{\"MUST\": \"id\", \"INSERT\": {\"@role\": \"OWNER\"}, \"REFUSE\": \"phone\"}','必须传id，不允许传phone。INSERT当没传@role时用OWNER补全','2017-02-01 11:19:51'),(5,1,'DELETE','Moment','{\"Moment\": {\"MUST\": \"id\", \"INSERT\": {\"@role\": \"OWNER\"}, \"UPDATE\": {\"commentCount()\": \"deleteCommentOfMoment(id)\"}}}',NULL,'2017-02-01 11:19:51'),(6,1,'DELETE','Comment','{\"MUST\": \"id\", \"INSERT\": {\"@role\": \"OWNER\"}, \"UPDATE\": {\"childCount()\": \"deleteChildComment(id)\"}}','disallow没必要用于DELETE','2017-02-01 11:19:51'),(8,1,'PUT','User-phone','{\"User\": {\"MUST\": \"id,phone,_password\", \"INSERT\": {\"@role\": \"OWNER\"}, \"REFUSE\": \"!\", \"UPDATE\": {\"@combine\": \"_password\"}}}','! 表示其它所有，这里指necessary所有未包含的字段','2017-02-01 11:19:51'),(14,1,'POST','Verify','{\"MUST\": \"phone,verify\", \"REFUSE\": \"!\"}','必须传phone,verify，其它都不允许传','2017-02-18 14:20:43'),(15,1,'GETS','Verify','{\"MUST\": \"phone\"}','必须传phone','2017-02-18 14:20:43'),(16,1,'HEADS','Verify','{}','允许任意内容','2017-02-18 14:20:43'),(17,1,'PUT','Moment','{\"MUST\": \"id\", \"REFUSE\": \"userId,date\", \"UPDATE\": {\"verifyIdList-()\": \"verifyIdList(praiseUserIdList)\", \"verifyURLList-()\": \"verifyURLList(pictureList)\"}}',NULL,'2017-02-01 11:19:51'),(21,1,'HEADS','Login','{\"MUST\": \"userId,type\", \"REFUSE\": \"!\"}',NULL,'2017-02-18 14:20:43'),(22,1,'GETS','User','{}','允许传任何内容，除了表对象','2017-02-18 14:20:43'),(23,1,'PUT','Privacy','{\"MUST\": \"id\", \"INSERT\": {\"@role\": \"OWNER\"}}','INSERT当没传@role时用OWNER补全','2017-02-01 11:19:51'),(25,1,'PUT','Praise','{\"MUST\": \"id\"}','必须传id','2017-02-01 11:19:51'),(26,1,'DELETE','Comment[]','{\"Comment\": {\"MUST\": \"id{}\", \"INSERT\": {\"@role\": \"OWNER\"}}}','DISALLOW没必要用于DELETE','2017-02-01 11:19:51'),(27,1,'PUT','Comment[]','{\"Comment\": {\"MUST\": \"id{}\", \"INSERT\": {\"@role\": \"OWNER\"}}}','DISALLOW没必要用于DELETE','2017-02-01 11:19:51'),(28,1,'PUT','Comment','{\"MUST\": \"id\", \"INSERT\": {\"@role\": \"OWNER\"}}','这里省略了Comment，因为tag就是Comment，Parser.getCorrectRequest会自动补全','2017-02-01 11:19:51'),(29,1,'GETS','login','{\"Privacy\": {\"MUST\": \"phone,_password\", \"REFUSE\": \"id\"}}',NULL,'2017-10-15 10:04:52'),(30,1,'PUT','balance+','{\"Privacy\": {\"MUST\": \"id,balance+\", \"REFUSE\": \"!\", \"VERIFY\": {\"balance+&{}\": \">=1,<=100000\"}}}','验证balance+对应的值是否满足>=1且<=100000','2017-10-21 08:48:34'),(31,1,'PUT','balance-','{\"Privacy\": {\"MUST\": \"id,balance-,_password\", \"REFUSE\": \"!\", \"UPDATE\": {\"@combine\": \"_password\"}, \"VERIFY\": {\"balance-&{}\": \">=1,<=10000\"}}}','UPDATE强制把_password作为WHERE条件','2017-10-21 08:48:34'),(32,2,'GETS','Privacy','{\"MUST\": \"id\", \"INSERT\": {\"@role\": \"OWNER\"}, \"REFUSE\": \"_password,_payPassword\"}',NULL,'2017-06-12 16:05:51'),(33,2,'GETS','Privacy-CIRCLE','{\"Privacy\": {\"MUST\": \"id\", \"REFUSE\": \"!\", \"UPDATE\": {\"@role\": \"CIRCLE\", \"@column\": \"phone\"}}}',NULL,'2017-06-12 16:05:51'),(35,2,'POST','Document','{\"Document\": {\"MUST\": \"name,url,request\", \"INSERT\": {\"@role\": \"OWNER\"}, \"REFUSE\": \"id\"}, \"TestRecord\": {\"MUST\": \"response\", \"INSERT\": {\"@role\": \"OWNER\"}, \"REFUSE\": \"id,documentId\", \"UPDATE\": {\"documentId@\": \"Document/id\"}}}',NULL,'2017-11-26 08:34:41'),(36,2,'PUT','Document','{\"MUST\": \"id\", \"INSERT\": {\"@role\": \"OWNER\"}, \"REFUSE\": \"userId\"}',NULL,'2017-11-26 08:35:15'),(37,2,'DELETE','Document','{\"MUST\": \"id\", \"INSERT\": {\"@role\": \"OWNER\"}, \"REFUSE\": \"!\", \"UPDATE\": {\"Random\": {\"@role\": \"OWNER\", \"documentId@\": \"Method/id\"}, \"TestRecord\": {\"@role\": \"OWNER\", \"documentId@\": \"Document/id\"}}}',NULL,'2017-11-26 00:36:20'),(38,2,'POST','TestRecord','{\"MUST\": \"documentId,response\", \"INSERT\": {\"@role\": \"OWNER\"}, \"REFUSE\": \"id\"}',NULL,'2018-06-16 23:44:36'),(39,2,'POST','Method','{\"Method\": {\"MUST\": \"method,class,package\", \"INSERT\": {\"@role\": \"OWNER\"}, \"REFUSE\": \"id\"}, \"TestRecord\": {\"MUST\": \"response\", \"INSERT\": {\"@role\": \"OWNER\"}, \"REFUSE\": \"id,documentId\", \"UPDATE\": {\"documentId@\": \"Method/id\"}}}',NULL,'2017-11-26 00:34:41'),(40,2,'PUT','Method','{\"MUST\": \"id\", \"INSERT\": {\"@role\": \"OWNER\"}, \"REFUSE\": \"userId\"}',NULL,'2017-11-26 00:35:15'),(41,2,'DELETE','Method','{\"MUST\": \"id\", \"INSERT\": {\"@role\": \"OWNER\"}, \"REFUSE\": \"!\"}',NULL,'2017-11-25 16:36:20'),(42,2,'POST','Random','{\"INSERT\": {\"@role\": \"OWNER\"}, \"Random\": {\"MUST\": \"documentId,name,config\"}, \"TestRecord\": {\"UPDATE\": {\"randomId@\": \"/Random/id\", \"documentId@\": \"/Random/documentId\"}}}',NULL,'2017-11-26 00:34:41'),(43,2,'PUT','Random','{\"MUST\": \"id\", \"INSERT\": {\"@role\": \"OWNER\"}, \"REFUSE\": \"userId\"}',NULL,'2017-11-26 00:35:15'),(44,2,'DELETE','Random','{\"MUST\": \"id\", \"INSERT\": {\"@role\": \"OWNER\"}, \"UPDATE\": {\"TestRecord\": {\"@role\": \"OWNER\", \"randomId@\": \"/id\"}}}',NULL,'2017-11-25 16:36:20'),(45,2,'POST','Comment:[]','{\"TYPE\": {\"Comment[]\": \"OBJECT[]\"}, \"INSERT\": {\"@role\": \"OWNER\"}, \"Comment[]\": []}',NULL,'2020-03-01 05:40:04'),(46,2,'POST','Moment:[]','{\"INSERT\": {\"@role\": \"OWNER\"}, \"Moment[]\": []}',NULL,'2020-03-01 05:41:42'),(47,2,'PUT','Comment:[]','{\"INSERT\": {\"@role\": \"OWNER\"}, \"Comment[]\": []}',NULL,'2020-03-01 05:40:04'),(48,2,'DELETE','TestRecord','{\"MUST\": \"id\", \"INSERT\": {\"@role\": \"OWNER\"}}',NULL,'2017-11-25 16:36:20'),(49,2,'POST','Input','{\"MUST\": \"deviceId,x,y\", \"INSERT\": {\"@role\": \"OWNER\"}, \"REFUSE\": \"id\"}',NULL,'2017-11-26 00:34:41'),(50,2,'POST','Device','{\"MUST\": \"brand,model\", \"INSERT\": {\"@role\": \"OWNER\"}, \"REFUSE\": \"id\"}',NULL,'2017-11-26 00:34:41'),(51,2,'POST','System','{\"MUST\": \"type,versionCode,versionName\", \"INSERT\": {\"@role\": \"OWNER\"}, \"REFUSE\": \"id\"}',NULL,'2017-11-26 00:34:41'),(52,2,'POST','Flow','{\"MUST\": \"deviceId,systemId,name\", \"INSERT\": {\"@role\": \"OWNER\"}, \"REFUSE\": \"id\"}',NULL,'2017-11-26 00:34:41'),(53,4,'GETS','Privacy','{\"MUST\": \"id\", \"INSERT\": {\"@role\": \"OWNER\"}, \"REFUSE\": \"!\"}',NULL,'2017-06-12 16:05:51'),(54,2,'POST','Output','{\"MUST\": \"inputId\", \"INSERT\": {\"@role\": \"OWNER\"}, \"REFUSE\": \"id\"}',NULL,'2018-06-16 23:44:36'),(55,2,'DELETE','Output','{\"MUST\": \"id\", \"INSERT\": {\"@role\": \"OWNER\"}}',NULL,'2017-11-25 16:36:20'),(56,3,'DELETE','Method','{\"MUST\": \"id\", \"INSERT\": {\"@role\": \"OWNER\"}, \"REFUSE\": \"!\"}',NULL,'2017-11-25 16:36:20'),(57,4,'GETS','User[]','{\"User\": {\"INSERT\": {\"@role\": \"CIRCLE\"}}, \"REFUSE\": \"query\"}',NULL,'2021-10-21 16:29:32');
/*!40000 ALTER TABLE `Request` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-01-05  1:40:45
