#--------------------
#Objective: Smart city - dependent variables description
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
library(haven)
library(grid)
##------------

##--Reading the raw data--
setwd("E:/zwy-Master-1/课程文件/高级社会统计分析方法与应用/数据分析文件")
smart_city <- read_dta("smart_city_panel_data_simplified.dta")
##------------------------

##--实验组与对照组因变量年均值变化趋势--
##标记所有实验组与对照组
smart_city$t <- "对照组"
smart_city <- smart_city %>%
  group_by(city_level) %>%
  mutate(a = sum(treat))
unique(smart_city$a)
for (i in 1:nrow(smart_city)) {
  ifelse(smart_city[i,"a"] == 0,
         smart_city[i,"t"] <- "对照组" ,
         smart_city[i,"t"] <- "处置组")
}

smart_city <- smart_city %>%
  mutate(lnpc_tp = log(tp/pop))

##计算年均值
trend <- smart_city %>%
  group_by(year,t) %>%
  mutate(mean_patent = mean(lnpc_tp,na.rm = T),
         mean_score = mean(total_score,na.rm = T),
         mean_cum = mean(cum_num,na.rm = T),
         mean_dlpatent = mean(total_patent,na.rm = T)) %>%
  select("year","mean_patent","mean_score","mean_cum","mean_dlpatent") %>%
  distinct()

##save
write.csv(trend, "main_explained_variables.csv")

##作图
t1 <- trend %>%
  ggplot() +
  geom_line(aes(x = year, y = mean_patent, color = t)) +
  theme_bw() +
  theme(legend.background = element_blank(),
        legend.position = "bottom",
        legend.title = element_text()) +
  labs(x = "年份",
       y = "平均人均专利数量对数",
       color = "")
print(t1)

t2 <- trend %>%
  ggplot() +
  geom_line(aes(x = year, y = mean_score, color = t)) +
  theme_bw() +
  theme(legend.background = element_blank(),
        legend.position = "bottom",
        legend.title = element_text()) +
  labs(x = "年份",
       y = "平均创新创业指数总得分",
       color = "")
print(t2)

grid.newpage ##新建图表页面
pushViewport(viewport(layout = grid.layout(1,2))) ##将版面分成1*2矩阵
vplayout <- function(x,y){viewport(layout.pos.row = x, layout.pos.col = y)}
print(t1, vp = vplayout(1,1))     ##将(1,1)的位置画图t1          
print(t2, vp = vplayout(1,2))    ##将（1,2)的位置画图t2
dev.off() #

t3 <- trend %>%
  ggplot() +
  geom_line(aes(x = year, y = mean_cum, color = t)) +
  theme_bw() +
  theme(legend.background = element_blank(),
        legend.position = "bottom",
        legend.title = element_text()) +
  labs(x = "年份",
       y = "平均累计瞪羚独角兽科技初创企业数量",
       color = "")
print(t3)

t4 <- trend %>%
  ggplot() +
  geom_line(aes(x = year, y = mean_dlpatent, color = t)) +
  theme_bw() +
  theme(legend.background = element_blank(),
        legend.position = "bottom",
        legend.title = element_text()) +
  labs(x = "年份",
       y = "平均瞪羚独角兽科技初创企业总专利申请数量",
       color = "")
print(t4)

grid.newpage ##新建图表页面
pushViewport(viewport(layout = grid.layout(1,4))) ##将版面分成2*2矩阵
vplayout <- function(x,y){viewport(layout.pos.row = x, layout.pos.col = y)}
print(t1, vp = vplayout(1,1))     ##将(1,1)的位置画图t1          
print(t2, vp = vplayout(1,2))    ##将（1,2)的位置画图t2
print(t3, vp = vplayout(1,3))     ##将(2,1)的位置画图t3          
print(t4, vp = vplayout(1,4))    ##将（2,2)的位置画图t4
dev.off() #
##----------------------------------------

##--Housekeeping--
rm(list = ls())
##----------------