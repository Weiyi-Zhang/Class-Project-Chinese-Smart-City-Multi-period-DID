#--------------------
#Objective: 地级市专利
#Updated: 25th November, 2021
#Email: weiyizhang1012@qq.com
#Content Credits: Weiyi Zhang
#--------------------

##--Housekeeping--
rm(list = ls())
##----------------

##--Packages-- 
library(tidyverse)
library(readxl)
library(lubridate)
library(haven) #read Stata data
##------------

##--Reading the raw data--
setwd("E:/zwy-Master-1/课程文件/高级社会统计分析方法与应用/中国地级市专利数据_专利申请量和专利授权量1990-2019")
cpatent <- read_excel("各省市专利申请情况.xlsx", sheet = 1)
cpatent <- cpatent[-1,]
tpatent <- read_excel("各省市专利获得情况.xlsx", sheet = 1)
tpatent <- tpatent[-1,]
##------------------------

##--Data collection--
cpatent[which(is.na(cpatent[,"Pftn"])),"Pftn"] <- cpatent[which(is.na(cpatent[,"Pftn"])),"Prvn"]
cpatent <- cpatent[,-1]
colnames(cpatent) <- c("city_level","year","inva","uma","desa")
cpatent$year <- as.numeric(cpatent$year)
cpatent$desa <- as.numeric(cpatent$desa)
cpatent$inva <- as.numeric(cpatent$inva)
cpatent$uma <- as.numeric(cpatent$uma)
cpatent$tp <- cpatent$inva + cpatent$desa + cpatent$uma

tpatent[which(is.na(tpatent[,"Pftn"])),"Pftn"] <- tpatent[which(is.na(tpatent[,"Pftn"])),"Prvn"]
tpatent <- tpatent[,-1]
colnames(tpatent) <- c("city_level","year","tinva","tuma","tdesa")
tpatent$year <- as.numeric(tpatent$year)
tpatent$tdesa <- as.numeric(tpatent$tdesa)
tpatent$tinva <- as.numeric(tpatent$tinva)
tpatent$tuma <- as.numeric(tpatent$tuma)
tpatent$ttp <- tpatent$tinva + tpatent$tdesa + tpatent$tuma

##save
write.csv(cpatent,"中国地级市专利申请数据.csv")
cpatent <- read.csv("中国地级市专利申请数据.csv")
cpatent <- cpatent[,-1]
write.csv(cpatent,"中国地级市专利申请数据_utf8.csv",fileEncoding = "utf-8")

write.csv(tpatent,"中国地级市专利获得数据.csv")
tpatent <- read.csv("中国地级市专利获得数据.csv")
tpatent <- tpatent[,-1]
write.csv(tpatent,"中国地级市专利获得数据_utf8.csv",fileEncoding = "utf-8")
##-----------------------

##--Housekeeping--
rm(list = ls())
##----------------
