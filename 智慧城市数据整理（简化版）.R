#--------------------
#Objective: Smart city - data collection（simplified）
#Updated: 4th January, 2022
#Email: weiyizhang1012@qq.com
#Content Credits: Weiyi Zhang
#--------------------

##--Housekeeping--
rm(list = ls())
##----------------

##--Packages-- 
library(tidyverse)
library(readxl)
##------------

##--Reading the raw data--
setwd("E:/zwy-Master-1/课程文件/高级社会统计分析方法与应用/前期数据整理文件")
smart_city <- read_excel("E:/zwy-Master-1/课程文件/高级社会统计分析方法与应用/国家智慧城市试点名单.xlsx", sheet = "行政区划")
city_info <- read_excel("E:/zwy-Master-1/课程文件/高级社会统计分析方法与应用/中国城市统计年鉴地级市面板数据/中国城市统计年鉴地级市面板数据.xlsx", sheet = 1)
colnames(smart_city)[1] <- "code"
colnames(city_info)[1] <- "code"
##------------------------

##--1.在地级市面板中添加试点信息--
##merge two databases
city_info <- city_info %>%
  filter(年份 %in% c(2004:2017)) %>%
  left_join(smart_city, by = "code") %>%
  select(-单位名称, -county_level)

##treated variable(1=treated, 0=non-treated)
city_info <- cbind(city_info,
                   as.data.frame(matrix(data = NA, 
                                        nrow = nrow(city_info), 
                                        ncol = 1)))
colnames(city_info)[ncol(city_info)] <- "treat"

for (i in 1:nrow(city_info)) {
  ifelse(is.na(city_info[i,"note"]) | city_info[i,"年份"] < city_info[i,"year"], 
         city_info[i,"treat"] <- 0, 
         city_info[i,"treat"] <- 1)
}

for (i in c("长春市","吉林市","盐城市","宿迁市","漳州市","青岛市","河源市","东莞市","中山市")) {
  city_info[which(city_info[,"city_level"] == i),"treat"] <- 0
}
city_info[which(city_info[,"city_level"] == "北京市" & city_info[,"年份"] %in% c(2013:2018)),"treat"] <- 1
city_info[which(city_info[,"city_level"] == "上海市" & city_info[,"年份"] %in% c(2013:2018)),"treat"] <- 1

##save
write.csv(city_info,"城市面板v1.csv")
city_info <- read.csv("城市面板v1.csv")
city_info <- city_info[,-1]
##-------------------------------------

##--2.添加双试点城市信息并调整处置组分布--
##model city or not(1=yes, 0=no)
city_info <- cbind(city_info,as.data.frame(matrix(data = 0, nrow = nrow(city_info), ncol = 1)))
colnames(city_info)[ncol(city_info)] <- "model"

for (i in c("济南市","青岛市","南京市","无锡市","扬州市","太原市","阳泉市","大连市","哈尔滨市","大庆市","合肥市","武汉市","襄阳市","深圳市","惠州市","成都市","西安市","延安市","咸阳市","克拉玛依市")) {
  city_info[which(city_info[,"city_level"] == i),"model"] <- 1
}
for (i in 1:nrow(city_info)) {
  ifelse(city_info[i,"model"] == 1 & city_info[i,"年份"] >= 2014,
         city_info[i,"treat"] <- 1,
         city_info[i,"treat"] <- city_info[i,"treat"])
}

##save
write.csv(city_info,"城市面板v2.csv")
city_info <- read.csv("城市面板v2.csv")
city_info <- city_info[,-1]
##--------------------------------------------

##--3.初步选择一些所需变量并修改名称--
##omit irrelevant information
city_info <- city_info %>%
  select("code","city_level","province_level","年份",254:257,
         "年末总人口_全市_万人",
         "非农业人口_全市_万人",
         "第一产业从业人员比重_全市_百分比",
         "第二产业从业人员比重_全市_百分比",
         "第三产业从业人员比重_全市_百分比",
         "人口密度_全市_人每平方公里",
         "地区生产总值_当年价格_全市_万元",
         "人均地区生产总值_全市_元",
         "地区生产总值增长率_全市_百分比",
         "第一产业占GDP的比重_全市_百分比",
         "第二产业占GDP的比重_全市_百分比",
         "第三产业占GDP的比重_全市_百分比",
         "固定资产投资总额_全市_万元",
         "地方一般公共预算支出_全市_万元",
         "科学技术支出_全市_万元",
         "年末金融机构人民币各项存款余额_全市_万元",
         "移动电话年末用户数_全市_万户",
         "互联网宽带接入用户数_全市_万户")
colnames(city_info)[9:26] <- c("pop","urbanpop","1st_pct","2nd_pct","3rd_pct","popdens","gdp","pcgdp","gdpgrth","1stgdp_pct","2ndgdp_pct","3rdgdp_pct","fai","gbe","rd","deposit","mobile","inter")
colnames(city_info)[4:5] <- c("year","time") 

##save
write.csv(city_info,"城市面板v3.csv")
city_info <- read.csv("城市面板v3.csv")
city_info <- city_info[,-1]
write.csv(city_info,"城市面板v3_utf8.csv",fileEncoding = "utf-8")
##---------------------------------------------------------

##--4.在地级市面板中添加瞪羚独角兽信息--
patent_company <- read.csv("瞪羚独角兽科创企业数量与专利数面板数据.csv")
patent_company <- patent_company[,-1]

city_info <- city_info %>%
  left_join(patent_company, by = c("year","city_level"))

##save
write.csv(city_info,"城市面板v4.csv")
city_info <- read.csv("城市面板v4.csv")
city_info <- city_info[,-1]
write.csv(city_info,"城市面板v4_utf8.csv",fileEncoding = "utf-8")

##--5.在地级市面板中添加专利信息--
cpatent <- read.csv("E:/zwy-Master-1/课程文件/高级社会统计分析方法与应用/中国地级市专利数据_专利申请量和专利授权量1990-2019/中国地级市专利申请数据.csv")
cpatent <- cpatent[,-1]

city_info <- city_info %>%
  left_join(cpatent, by = c("year","city_level"))

##save
write.csv(city_info,"城市面板v5.csv")
city_info <- read.csv("城市面板v5.csv")
city_info <- city_info[,-1]
write.csv(city_info,"城市面板v5_utf8.csv",fileEncoding = "utf-8")
##------------------------------------------------------------

##--6.按城市创新水平分组--
panel1 <- city_info %>%
  group_by(city_level) %>%
  mutate(mean_tp = mean(tp)) %>%
  select("city_level","mean_tp") %>%
  distinct() %>%
  arrange(mean_tp)

panel1 %>%
  ggplot() +
  geom_point(aes(x = city_level, y = mean_tp))

summary(panel1)
##skewed distribution
##Mean is much bigger than the median, and even bigger than Q3

##divide into two groups
panel1$group <- 2
for (i in 1:nrow(panel1)) {
  ifelse(panel1[i,2] >= 4162.8,
         panel1[i,3] <- 1,
         panel1[i,3] <- 2)
}
##大于等于均值的为1组，小于均值的为2组
panel1 %>%
  group_by(group) %>%
  summarise(n = n())

city_info <- city_info %>%
  left_join(panel1, by = "city_level") %>%
  select(-mean_tp)

##save
write.csv(city_info,"城市面板v6.csv")
city_info <- read.csv("城市面板v6.csv")
city_info <- city_info[,-1]
write.csv(city_info,"城市面板v6_utf8.csv",fileEncoding = "utf-8")
##---------------------

##--7.在地级市面板中添加创新创业指数--
index  <- read_excel("E:/zwy-Master-1/课程文件/高级社会统计分析方法与应用/中国区域创新创业指数1990-2020/区域创新指数1990-2020-地级.xls", sheet = "地级")
index <- select(index,-1,-2,-7,-9,-11,-13,-15,-17)
colnames(index) <- c("province_level","city_level","year","total_score","new_company","foreign_investment","vcpe_investment","patent_given","label_given")
index <- index[-1,]
index$year <- as.numeric(index$year)

index2 <- read_excel("E:/zwy-Master-1/课程文件/高级社会统计分析方法与应用/中国区域创新创业指数1990-2020/区域创新指数1990-2020-省级.xls", sheet = "省级")
index2 <- select(index2,-1,-5,-7,-9,-11,-13,-15)
colnames(index2) <- c("province_level","year","total_score","new_company","foreign_investment","vcpe_investment","patent_given","label_given")
index2 <- index2[-1,]
index2$year <- as.numeric(index2$year)
index2 <- index2 %>%
  filter(province_level %in% c("北京市","天津市","重庆市","上海市")) %>%
  mutate(city_level = province_level) %>%
  select(1,9,2:8)
index <- rbind(index, index2)

city_info <- city_info %>%
  left_join(index, by = c("year", "city_level","province_level"))
city_info <- city_info %>%
  filter(is.na(city_level) == F)

##save
write.csv(city_info,"城市面板v7.csv")
city_info <- read.csv("城市面板v7.csv")
city_info <- city_info[,-1]
write.csv(city_info,"城市面板v7_utf8.csv",fileEncoding = "utf-8")
##-----------------------------

##--Housekeeping--
rm(list = ls())
##----------------

