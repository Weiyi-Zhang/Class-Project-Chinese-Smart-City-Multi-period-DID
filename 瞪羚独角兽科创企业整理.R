#--------------------
#Objective: 瞪羚独角兽科创企业
#Updated: 20th December, 2021
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
setwd("E:/zwy-Master-1/课程文件/高级社会统计分析方法与应用/中国瞪羚企业、独角兽和科技型初创企业名录数据（含基本信息和注册地址经纬度）")
busns <- read_excel("瞪羚企业名录（基本信息+经纬度）.xlsx", sheet = 1)
##------------------------

##--1.计算每年各市新增与累计的瞪羚独角兽数量--
##glimpse
table(busns$国家)
table(busns$省份)
table(busns$城市)

##selection
busns <- busns %>%
  filter(国家 == "中国") %>%
  select(-国家) %>%
  filter(城市 != "香港" &
             城市 != "香港特别行政区" &
             城市 != "香港市" &
             城市 != "NA" &
             城市 != "澄迈")
unique(busns$城市)

##city name
a <- c("成都","重庆","西安","渭南","湘潭","长沙","广州","珠海","东莞","深圳","武汉","石家庄","南昌","北京","济南","徐州","合肥","天津","淄博","南京","泰州","常州","杭州","青岛","无锡","苏州","上海","南通","宁波","大连","宣城")
for (i in 1:31) {
  busns[which(busns$城市 == a[i]), "城市"] <- paste0(a[i],"市",sep = "")
}
busns[which(busns$城市 == "昌吉回族自治州市"), "城市"] <- "昌吉回族自治州"
busns[which(busns$城市 == "延边朝鲜族自治州市"), "城市"] <- "延边朝鲜族自治州"
busns[which(busns$城市 == "山南地区市"), "城市"] <- "山南市"
busns[which(busns$城市 == "海淀区市"), "城市"] <- "北京市"
busns[which(busns$城市 == "东城区市"), "城市"] <- "北京市"
unique(busns$城市)

##omit irrelevant information
busns <- busns %>%
  select(1,2,4,6,7,8,29,19)
colnames(busns) <- c("ID","company_name","city_level","listed","HNTE","establishment_date","cancellation_date","type")
busns$establishment_date <- as.Date(busns$establishment_date)
busns$cancellation_date <- as.Date(busns$cancellation_date)
busns$est_year <- year(busns$establishment_date)
busns$canc_year <- year(busns$cancellation_date)
busns <- select(busns, -"establishment_date",-"cancellation_date")

##summarize
new_company <- busns %>%
  group_by(city_level,est_year) %>%
  summarise(new_num = n())

city_level <- unique(busns$city_level)
cum_company <- as.data.frame(city_level)
for (i in 2004:2017) {
  b <- busns %>%
    filter(est_year <= i & canc_year %in% c(i:2017,NA)) %>%
    group_by(city_level) %>%
    summarise(cum_num = n())
  colnames(b)[2] <- paste0(i,sep = "")
  cum_company <- cum_company %>%
    left_join(b, by = "city_level")
}
cum_company <- cum_company %>%
  gather(key = year, value = cum_num, 2:15) %>%
  mutate(year = as.numeric(year))
colnames(new_company)[2] <- "year"
cum_company <- cum_company %>%
  left_join(new_company, by = c("city_level","year"))
cum_company[which(is.na(cum_company$cum_num)),"cum_num"] <- 0
cum_company[which(is.na(cum_company$new_num)),"new_num"] <- 0

##save
write.csv(cum_company,"瞪羚独角兽数量.csv")

##-----------------------

##--Housekeeping--
rm(list = ls())
##----------------

##--Reading the raw data--
setwd("E:/zwy-Master-1/课程文件/高级社会统计分析方法与应用/瞪羚企业、独角兽和科技型初创企业数据与专利数据库匹配结果数据")
patent <- read_dta("瞪羚企业、独角兽和科技型初创企业专利申请数量面板数据（1985～2019）.dta")
##------------------------

##--2.计算每年各市瞪羚独角兽专利数量--
##city name
patent <- patent %>%
  filter(国家 == "中国") %>%
  select(-国家) %>%
  filter(城市 != "香港" &
             城市 != "香港特别行政区" &
             城市 != "香港市" &
             城市 != "" &
             城市 != "澄迈")
unique(patent$城市)

a <- c("成都","重庆","西安","渭南","湘潭","长沙","广州","珠海","东莞","深圳","武汉","石家庄","南昌","北京","济南","徐州","合肥","天津","淄博","南京","泰州","常州","杭州","青岛","无锡","苏州","上海","南通","宁波","大连","宣城")
for (i in 1:31) {
  patent[which(patent$城市 == a[i]), "城市"] <- paste0(a[i],"市",sep = "")
}
patent[which(patent$城市 == "昌吉回族自治州市"), "城市"] <- "昌吉回族自治州"
patent[which(patent$城市 == "延边朝鲜族自治州市"), "城市"] <- "延边朝鲜族自治州"
patent[which(patent$城市 == "山南地区市"), "城市"] <- "山南市"
patent[which(patent$城市 == "海淀区市"), "城市"] <- "北京市"
patent[which(patent$城市 == "东城区市"), "城市"] <- "北京市"
unique(patent$城市)

##calculate numbers of patents
patent <- patent %>%
  select(1:6,9)
patent <- as.matrix(patent)
patent <- as.data.frame(patent) ##消除stata数据格式的影响
patent$年份 <- as.numeric(patent$年份)
patent$设计型专利 <- as.numeric(patent$设计型专利)
patent$发明型专利 <- as.numeric(patent$发明型专利)
patent$实用型专利 <- as.numeric(patent$实用型专利)
patent$总专利数量 <- as.numeric(patent$总专利数量)

patent <- patent %>%
  group_by(年份, 城市) %>%
  summarise(total_patent = sum(总专利数量),
         design_patent = sum(设计型专利),
         inventation_patent = sum(发明型专利),
         utility_patent = sum(实用型专利)) %>%
  select("年份", "城市","total_patent","design_patent","inventation_patent","utility_patent")

colnames(patent)[1] <- "year"
colnames(patent)[2] <- "city_level"

##save
write.csv(patent,"瞪羚独角兽科创专利数量.csv")

##-----------------------

##--3.瞪羚独角兽两表合并--
setwd("E:/zwy-Master-1/课程文件/高级社会统计分析方法与应用/前期数据整理文件")
cum_company <- read.csv("E:/zwy-Master-1/课程文件/高级社会统计分析方法与应用/中国瞪羚企业、独角兽和科技型初创企业名录数据（含基本信息和注册地址经纬度）/瞪羚独角兽数量.csv")
cum_company <- cum_company[,-1]

patent_company <- cum_company %>%
  left_join(patent, by = c("year","city_level"))

##save
write.csv(patent_company,"瞪羚独角兽科创企业数量与专利数面板数据.csv")
patent_company <- read.csv("瞪羚独角兽科创企业数量与专利数面板数据.csv")
patent_company <- patent_company[,-1]
write.csv(patent_company,"瞪羚独角兽科创企业数量与专利数面板数据_utf8.csv",fileEncoding = "utf-8")
##-----------------------

##--Housekeeping--
rm(list = ls())
##----------------
