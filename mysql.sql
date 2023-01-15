/*
SQLyog Ultimate v12.09 (64 bit)
MySQL - 8.0.31 : Database - mydb
*********************************************************************
*/


/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`mydb` /*!40100 DEFAULT CHARACTER SET utf8mb3 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `mydb`;

/*Table structure for table `access_log` */

DROP TABLE IF EXISTS `access_log`;

CREATE TABLE `access_log` (
  `id` bigint DEFAULT NULL,
  `ip` text,
  `province` text,
  `city` text,
  `isp` text,
  `access_time` text,
  `access_hour` text,
  `url` text,
  `status` text,
  `traffic` text,
  `referer` text,
  `ref_type` text,
  `c_info` text,
  `client_type` text,
  `client_browser` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

/*Table structure for table `access_log_first` */

DROP TABLE IF EXISTS `access_log_first`;

CREATE TABLE `access_log_first` (
  `id` bigint DEFAULT NULL,
  `ip` text,
  `province` text,
  `city` text,
  `isp` text,
  `access_time` text,
  `access_hour` text,
  `url` text,
  `status` text,
  `traffic` text,
  `referer` text,
  `ref_type` text,
  `c_info` text,
  `client_type` text,
  `client_browser` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

/*Table structure for table `access_log_ip_black` */

DROP TABLE IF EXISTS `access_log_ip_black`;

CREATE TABLE `access_log_ip_black` (
  `ip` varchar(200) DEFAULT NULL,
  `times` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

/*Table structure for table `access_log_url_top` */

DROP TABLE IF EXISTS `access_log_url_top`;

CREATE TABLE `access_log_url_top` (
  `url` varchar(200) DEFAULT NULL,
  `times` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;



/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
