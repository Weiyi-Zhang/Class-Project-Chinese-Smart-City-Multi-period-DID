***********************************************************
** Task: Smart city
** Updated: 29th December, 2021
** Credit: Weiyi Zhang
** Email: weiyizhang1012@qq.com
***********************************************************

*** Housekeeping ***

clear all
set more off
cd "E:\zwy-Master-1\课程文件\高级社会统计分析方法与应用\前期数据整理文件"
// change the current directory **
cap log close
set mem 300m
log using "E:\zwy-Master-1\课程文件\高级社会统计分析方法与应用\前期数据整理文件\formulation", replace text
// to open a new log file named "formulation.log" to document the commands and results


*** Read in the raw data ***

insheet using "城市面板v7_utf8.csv", comma clear
drop v1


*** Change the types of some data ***
destring time, ignore("NA") replace
destring pop urbanpop x1st_pct x2nd_pct x3rd_pct popdens gdp pcgdp gdpgrth x1stgdp_pct x2ndgdp_pct x3rdgdp_pct fai gbe rd deposit mobile inter, ignore("NA") replace
destring cum_num new_num total_patent design_patent inventation_patent utility_patent, ignore("NA") replace
destring inva uma desa tp, ignore("NA") replace
destring total_score new_company foreign_investment vcpe_investment patent_given label_given, ignore("NA") replace


*** Add labels to variables ***
label variable code  "行政区划代码"
label variable city_level  "城市"
label variable province_level  "省份"
label variable year  "年份"
label variable time  "试点干预年份"
label variable note  "试点说明"
label variable treat  "是否为智慧城市试点城市"
label variable model  "是否为智慧城市双试点城市"
label variable pop  "年末总人口_全市_万人"
label variable urbanpop  "非农业人口_全市_万人"
label variable x1st_pct  "第一产业从业人员比重_全市_百分比"
label variable x2nd_pct  "第二产业从业人员比重_全市_百分比"
label variable x3rd_pct  "第三产业从业人员比重_全市_百分比"
label variable popdens  "人口密度_全市_人每平方公里"
label variable gdp  "地区生产总值_当年价格_全市_万元"
label variable pcgdp  "人均地区生产总值_全市_元"
label variable gdpgrth  "地区生产总值增长率_全市_百分比"
label variable x1stgdp_pct  "第一产业占GDP的比重_全市_百分比"
label variable x2ndgdp_pct  "第二产业占GDP的比重_全市_百分比"
label variable x3rdgdp_pct  "第三产业占GDP的比重_全市_百分比"
label variable fai  "固定资产投资总额_全市_万元"
label variable gbe  "地方一般公共预算支出_全市_万元"
label variable rd  "科学技术支出_全市_万元"
label variable deposit  "年末金融机构人民币各项存款余额_全市_万元"
label variable mobile  "移动电话年末用户数_全市_万户"
label variable inter  "互联网宽带接入用户数_全市_万户"
label variable cum_num  "累计瞪羚独角兽科创企业数量"
label variable new_num  "新注册瞪羚独角兽科创企业数量"
label variable total_patent  "瞪羚独角兽科创企业总专利申请数量"
label variable design_patent  "瞪羚独角兽科创企业设计型专利申请数量"
label variable inventation_patent  "瞪羚独角兽科创企业发明型专利申请数量"
label variable utility_patent  "瞪羚独角兽科创企业实用型专利申请数量"

gen pcgbe = gbe/pop
gen pcrd = rd/pop
gen rdlevel = rd/gdp
gen urbanrate = urbanpop/pop
gen structure = x2ndgdp_pct/x3rdgdp_pct
gen lnpop = log(pop) 
gen fai_pct = fai/gdp
gen finanscale = deposit/gdp
label variable pcgbe  "人均地区一般公共预算支出_全市_元"
label variable pcrd  "人均科学技术支出_全市_元"
label variable rdlevel  "科学技术支出水平（科学技术支出_全市_元/GDP）"
label variable urbanrate "城镇化率_全市"
label variable structure "产业结构（第二产业占GDP的比重/第三产业占GDP的比重）"
label variable lnpop "年末总人口_全市_万人（对数）"
label variable fai_pct "固定资产投资总额_全市_万元占GDP的比重"
label variable finanscale "金融发展规模（年末金融机构人民币各项存款余额_全市_万元/GDP）"

label variable inva "本市发明型专利申请数量"
label variable uma "本市实用型专利申请数量"
label variable desa "本市设计型专利申请数量"
label variable tp "本市总专利申请数量"

label variable group "根据本市总专利申请数量划分组别"

label variable total_score "创新创业指数总维度-总量指数得分"
label variable new_company "创新创业指数子维度-新建企业数量得分"
label variable foreign_investment "创新创业指数子维度-吸引外来投资得分"
label variable vcpe_investment "创新创业指数子维度-吸引风险投资得分"
label variable patent_given "创新创业指数子维度-专利授权数量得分"
label variable label_given "创新创业指数子维度-商标注册数量得分"


*** Drop useless variable ***
drop urbanpop x1st_pct x2nd_pct x3rd_pct popdens gdp x1stgdp_pct mobile inter
misstable summarize

*** Save ***
save smart_city_panel_data_simplified, replace
cd "E:\zwy-Master-1\课程文件\高级社会统计分析方法与应用\数据分析文件"
// change the current directory **
save smart_city_panel_data_simplified, replace

*** Housekeeping ***

clear all
log close
