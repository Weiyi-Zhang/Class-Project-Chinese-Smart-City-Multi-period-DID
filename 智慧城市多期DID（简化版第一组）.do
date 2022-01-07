***********************************************************
** Task: Smart city_DID(group == 1)
** Updated: 6th January, 2022
** Credit: Weiyi Zhang
** Email: weiyizhang1012@qq.com
***********************************************************

*** Housekeeping ***

clear all
set more off
cd "E:\zwy-Master-1\课程文件\高级社会统计分析方法与应用\数据分析文件"
// change the current directory **
cap log close
set mem 300m
log using "E:\zwy-Master-1\课程文件\高级社会统计分析方法与应用\did", replace text
// to open a new log file named "did.log" to document the commands and results


*** Read in the raw data ***

use smart_city_panel_data_simplified, clear
tab year
bysort code :keep if _N == 14
tab group treat
keep if group == 1
drop fai gbe design_patent inventation_patent utility_patent new_num group


*** 检查缺失值情况 ***

tab year
misstable summarize
drop if pop == .
//数据中关于城市宏观经济信息变量是完全随机缺失，都是定比变量，多重插补MCMC法适用
tab year
bysort code :keep if _N == 14

xtset code year
//设置面板数据格式

*tab treat year
*outreg2 treat year using result1.doc, replace cross  title(Decriptive statistics)
//导出对照组与处置组样本数量表格result1.doc


*** 检查因变量 ***

*因变量1：pc_tp
gen pc_tp = tp/pop 
label variable pc_tp "人均总专利申请数量"
hist pc_tp
winsor2 pc_tp, cuts(1 95) replace trim
count if (pc_tp<1.930993)
hist pc_tp

gen lnpc_tp = log(pc_tp)
label variable lnpc_tp "人均总专利申请数量（对数）"
summarize lnpc_tp, d
hist lnpc_tp, normal
//直方图
kdensity lnpc_tp, normal
//核密度图
qnorm lnpc_tp
//QQ图
sktest lnpc_tp
//D’Agostino检验
//因变量1：lnpc_tp

*因变量2：cum_num
hist cum_num
winsor2 cum_num, cuts(5 93) replace trim
count if (cum_num<1.930993)
hist cum_num

gen lncum_num = log(cum_num)
label variable lncum_num "累计瞪羚独角兽科创企业数量（对数）"
summarize lncum_num, d
hist lncum_num, normal
//直方图
kdensity lncum_num, normal
//核密度图
qnorm lncum_num
//QQ图
sktest lncum_num
//D’Agostino检验
//因变量2：lncum_num

*因变量3：total_patent
hist total_patent
winsor2 total_patent, cuts(1 95) replace trim
count if (total_patent<1.930993)
hist total_patent

gen lntotal_patent = log(total_patent)
label variable lntotal_patent "瞪羚独角兽科创企业总专利申请数量（对数）"
summarize lntotal_patent, d
hist lntotal_patent, normal
//直方图
kdensity lntotal_patent, normal
//核密度图
qnorm lntotal_patent
//QQ图
sktest lntotal_patent
//D’Agostino检验
//因变量3：lntotal_patent

*因变量4：total_score
hist total_score, normal
gen lntotal_score = log(-total_score+101)
label variable lntotal_score "创新创业指数总维度-总量指数得分（相反数+101的对数）"
summarize lntotal_score, d
hist lntotal_score, normal
//直方图
kdensity lntotal_score, normal
//核密度图
qnorm lntotal_score
//QQ图
sktest lntotal_score
//D’Agostino检验
//因变量4：lntotal_score

*因变量5：pc_inva
gen pc_inva = inva/pop
label variable pc_inva "人均发明型专利申请数量"
hist pc_inva
winsor2 pc_inva, cuts(1 95) replace trim
count if (pc_inva<1.930993)
hist pc_inva

gen lnpc_inva = log(pc_inva)
label variable lnpc_inva "人均发明型专利申请数量（对数）"
summarize lnpc_inva, d
hist lnpc_inva, normal
//直方图
kdensity lnpc_inva, normal
//核密度图
qnorm lnpc_inva
//QQ图
sktest lnpc_inva
//D’Agostino检验
//因变量5：lnpc_inva

*因变量6：pc_desa
gen pc_desa = desa/pop
label variable pc_desa "人均设计型专利申请数量"
hist pc_desa
winsor2 pc_desa, cuts(1 95) replace trim
count if (pc_desa<1.930993)
hist pc_desa

gen lnpc_desa = log(pc_desa)
label variable lnpc_desa "人均设计型型专利申请数量（对数）"
summarize lnpc_desa, d
hist lnpc_desa, normal
//直方图
kdensity lnpc_desa, normal
//核密度图
qnorm lnpc_desa
//QQ图
sktest lnpc_desa
//D’Agostino检验
//因变量6：lnpc_desa

*因变量7：pc_uma
gen pc_uma = uma/pop
label variable pc_uma "人均实用型专利申请数量"
hist pc_uma
winsor2 pc_uma, cuts(1 95) replace trim
count if (pc_uma<1.930993)
hist pc_uma

gen lnpc_uma = log(pc_uma)
label variable lnpc_uma "人均实用型专利申请数量（对数）"
summarize lnpc_uma, d
hist lnpc_uma, normal
//直方图
kdensity lnpc_uma, normal
//核密度图
qnorm lnpc_uma
//QQ图
sktest lnpc_uma
//D’Agostino检验
//因变量7：lnpc_uma

*因变量8：new_company
hist new_company, normal
//直方图
kdensity new_company, normal
//核密度图
qnorm new_company
//QQ图
sktest new_company
//D’Agostino检验
//因变量8：new_company

*因变量9：foreign_investment
hist foreign_investment, normal
//直方图
kdensity foreign_investment, normal
//核密度图
qnorm foreign_investment
//QQ图
sktest foreign_investment
//D’Agostino检验
//因变量9：foreign_investment

*因变量10：vcpe_investment
hist vcpe_investment, normal
//直方图
kdensity vcpe_investment, normal
//核密度图
qnorm vcpe_investment
//QQ图
sktest vcpe_investment
//D’Agostino检验
//因变量10：vcpe_investment

*因变量11：patent_given
hist patent_given, normal
//直方图
kdensity patent_given, normal
//核密度图
qnorm patent_given
//QQ图
sktest patent_given
//D’Agostino检验
//因变量11：patent_given

*因变量12：label_given
hist label_given, normal
//直方图
kdensity label_given, normal
//核密度图
qnorm label_given
//QQ图
sktest label_given
//D’Agostino检验
//因变量12：label_given


*** 缺失值插补 ***

misstable summarize
mi set flong
//定义插补库类型
mi register imputed pcgdp gdpgrth x3rdgdp_pct deposit rdlevel urbanrate pcgbe fai_pct finanscale
//注册要被插补的变量
mi register regular lnpop lntotal_score total_score new_company foreign_investment vcpe_investment patent_given label_given 
//注册不被插补的变量
mi impute mvn pcgdp gdpgrth x3rdgdp_pct deposit rdlevel urbanrate pcgbe fai_pct finanscale = lnpop lntotal_score total_score new_company foreign_investment vcpe_investment patent_given label_given, add(25) rseed(29930) force
//定义插补模型，插补次数为25次，用rseed定义随机数为29930，以便重复执行能获得相同的结果


*** DID ***

global cova pcgdp gdpgrth rdlevel finanscale pcgbe urbanrate structure lnpop x3rdgdp_pct x2ndgdp_pct fai_pct
//控制变量

mi estimate: xtreg lnpc_tp treat $cova i.year, fe vce(cluster code)
//因变量为人均本市总专利申请数量（对数），加入控制变量
*xtreg lnpc_tp treat $cova i.year, fe vce(cluster code)
*outreg2 using didresult1.doc, replace tstat bdec(3) tdec(2) ctitle(lnpc_tp) addtext(city fe, yes,year fe, yes)
//为了输出标准表格形式，所以采取普通估计+outreg2命令，再将mi estimate数值手动修改填入
mibeta lnpc_tp treat $cova i.year, fisherz miopts(vartable)

mi estimate: xtreg lncum_num treat $cova i.year, fe vce(cluster code)
//因变量为累计瞪羚独角兽科创企业数量（对数），加入控制变量
*xtreg lncum_num treat $cova i.year, fe vce(cluster code)
*outreg2 using didresult1.doc, append tstat bdec(3) tdec(2) ctitle(lncum_num) addtext(city fe, yes,year fe, yes)
//为了输出标准表格形式，所以采取普通估计+outreg2命令，再将mi estimate数值手动修改填入
mibeta lncum_num treat $cova i.year, fisherz miopts(vartable)

mi estimate: xtreg lntotal_patent treat $cova i.year, fe vce(cluster code)
//因变量为瞪羚独角兽科创企业总专利申请数量（对数），加入控制变量
*xtreg lntotal_patent treat $cova i.year, fe vce(cluster code)
*outreg2 using didresult1.doc, append tstat bdec(3) tdec(2) ctitle(lntotal_patent) addtext(city fe, yes,year fe, yes)
//为了输出标准表格形式，所以采取普通估计+outreg2命令，再将mi estimate数值手动修改填入
mibeta lntotal_patent treat $cova i.year, fisherz miopts(vartable)

mi estimate: xtreg lntotal_score treat $cova i.year, fe vce(cluster code)
//因变量为创新创业指数总维度-总量指数得分（相反数+101的对数），加入控制变量
*xtreg lntotal_score treat $cova i.year, fe vce(cluster code)
*outreg2 using didresult1.doc, append tstat bdec(3) tdec(2) ctitle(lntotal_score) addtext(city fe, yes,year fe, yes)
//为了输出标准表格形式，所以采取普通估计+outreg2命令，再将mi estimate数值手动修改填入
mibeta lntotal_score treat $cova i.year, fisherz miopts(vartable)

mi estimate: xtreg new_company treat $cova i.year, fe vce(cluster code)
//因变量为创新创业指数子维度-新建企业数量得分，加入控制变量
*xtreg new_company treat $cova i.year, fe vce(cluster code)
*outreg2 using didresultcxcy1.doc, replace tstat bdec(3) tdec(2) ctitle(new_company) addtext(city fe, yes,year fe, yes)
//为了输出标准表格形式，所以采取普通估计+outreg2命令，再将mi estimate数值手动修改填入
mibeta new_company treat $cova i.year, fisherz miopts(vartable)

mi estimate: xtreg foreign_investment treat $cova i.year, fe vce(cluster code)
//因变量为创新创业指数子维度-吸引外来投资得分，加入控制变量
*xtreg foreign_investment treat $cova i.year, fe vce(cluster code)
*outreg2 using didresultcxcy1.doc, append tstat bdec(3) tdec(2) ctitle(foreign_investment) addtext(city fe, yes,year fe, yes)
//为了输出标准表格形式，所以采取普通估计+outreg2命令，再将mi estimate数值手动修改填入
mibeta foreign_investment treat $cova i.year, fisherz miopts(vartable)

mi estimate: xtreg vcpe_investment treat $cova i.year, fe vce(cluster code)
//因变量为创新创业指数子维度-吸引风险投资得分，加入控制变量
*xtreg vcpe_investment treat $cova i.year, fe vce(cluster code)
*outreg2 using didresultcxcy1.doc, append tstat bdec(3) tdec(2) ctitle(vcpe_investment) addtext(city fe, yes,year fe, yes)
//为了输出标准表格形式，所以采取普通估计+outreg2命令，再将mi estimate数值手动修改填入
mibeta vcpe_investment treat $cova i.year, fisherz miopts(vartable)

mi estimate: xtreg patent_given treat $cova i.year, fe vce(cluster code)
//因变量为创新创业指数子维度-专利授权数量得分，加入控制变量
*xtreg patent_given treat $cova i.year, fe vce(cluster code)
*outreg2 using didresultcxcy1.doc, append tstat bdec(3) tdec(2) ctitle(patent_given) addtext(city fe, yes,year fe, yes)
//为了输出标准表格形式，所以采取普通估计+outreg2命令，再将mi estimate数值手动修改填入
mibeta patent_given treat $cova i.year, fisherz miopts(vartable)

mi estimate: xtreg label_given treat $cova i.year, fe vce(cluster code)
//因变量为创新创业指数子维度-商标注册数量得分，加入控制变量
*xtreg label_given treat $cova i.year, fe vce(cluster code)
*outreg2 using didresultcxcy1.doc, append tstat bdec(3) tdec(2) ctitle(label_given) addtext(city fe, yes,year fe, yes)
//为了输出标准表格形式，所以采取普通估计+outreg2命令，再将mi estimate数值手动修改填入
mibeta label_given treat $cova i.year, fisherz miopts(vartable)

mi estimate: xtreg lnpc_desa treat $cova i.year, fe vce(cluster code)
//因变量为人均本市设计型专利申请数量（对数），加入控制变量
*xtreg lnpc_tp treat $cova i.year, fe vce(cluster code)
*outreg2 using didresultzl1.doc, replace tstat bdec(3) tdec(2) ctitle(lnpc_desa) addtext(city fe, yes,year fe, yes)
//为了输出标准表格形式，所以采取普通估计+outreg2命令，再将mi estimate数值手动修改填入
mibeta lnpc_desa treat $cova i.year, fisherz miopts(vartable)

mi estimate: xtreg lnpc_inva treat $cova i.year, fe vce(cluster code)
//因变量为人均本市发明型专利申请数量（对数），加入控制变量
*xtreg lnpc_inva treat $cova i.year, fe vce(cluster code)
*outreg2 using didresultzl1.doc, append tstat bdec(3) tdec(2) ctitle(lnpc_inva) addtext(city fe, yes,year fe, yes)
//为了输出标准表格形式，所以采取普通估计+outreg2命令，再将mi estimate数值手动修改填入
mibeta lnpc_inva treat $cova i.year, fisherz miopts(vartable)

mi estimate: xtreg lnpc_uma treat $cova i.year, fe vce(cluster code)
//因变量为人均本市实用型专利申请数量（对数），加入控制变量
*xtreg lnpc_uma treat $cova i.year, fe vce(cluster code)
*outreg2 using didresultzl1.doc, append tstat bdec(3) tdec(2) ctitle(lnpc_uma) addtext(city fe, yes,year fe, yes)
//为了输出标准表格形式，所以采取普通估计+outreg2命令，再将mi estimate数值手动修改填入
mibeta lnpc_uma treat $cova i.year, fisherz miopts(vartable)


*** 平行趋势检验 ***
*使用coefplot画图	
gen policy = year - time
//生成政策时点前后期数
label variable policy "政策试点前后期数"
tab policy

forvalues i=11(-1)1{
  gen pre`i'=(policy==-`i')
}

gen current= (policy==0)

forvalues i=1(1)4{
  gen post`i'=(policy==`i')
}

drop pre1
//将政策前第一期作为基准组

mi estimate: xtreg lnpc_tp pre* current post* i.year, fe vce(cluster code)
*绘图
coefplot, baselevels keep(pre* current post*) ///
vertical ///转置图形
coeflabels(pre11 = "-11" pre10 = "-10" pre9 = "-9" pre8 = "-8" pre7 = "-7" pre6 = "-6" pre5 = "-5" pre4 = "-4" pre3 = "-3" pre2 = "-2" current = "0" post1 = "1" post2 = "2" post3 = "3" post4 = "4") ///
yline(0,lcolor(edkblue*0.8)) ///加入y=0这条虚线
ylabel(-0.5(0.1)0.5) ///
xline(11, lwidth(vthin) lpattern(dash) lcolor(teal)) ///
ylabel(,labsize(*0.75)) xlabel(,labsize(*0.75)) ///
ytitle("政策动态经济效应", size(small)) ///加入Y轴标题,大小small
xtitle("政策时点", size(small)) ///加入X轴标题，大小small 
addplot(line @b @at) ///增加点之间的连线
ciopts(lpattern(dash) recast(rcap) msize(medium)) ///CI为虚线上下封口
msymbol(circle_hollow) ///plot空心格式
scheme(s1mono)
//系数β_(-11)到β_(-2)在统计上并不显著异于0（95%的置信区间包含了0值），说明平行趋势假设成立

mi estimate: xtreg lncum_num pre* current post* i.year, fe vce(cluster code)
*绘图
coefplot, baselevels keep(pre* current post*) ///
vertical ///转置图形
coeflabels(pre11 = "-11" pre10 = "-10" pre9 = "-9" pre8 = "-8" pre7 = "-7" pre6 = "-6" pre5 = "-5" pre4 = "-4" pre3 = "-3" pre2 = "-2" current = "0" post1 = "1" post2 = "2" post3 = "3" post4 = "4") ///
yline(0,lcolor(edkblue*0.8)) ///加入y=0这条虚线
ylabel(-0.5(0.1)0.5) ///
xline(11, lwidth(vthin) lpattern(dash) lcolor(teal)) ///
ylabel(,labsize(*0.75)) xlabel(,labsize(*0.75)) ///
ytitle("政策动态经济效应", size(small)) ///加入Y轴标题,大小small
xtitle("政策时点", size(small)) ///加入X轴标题，大小small 
addplot(line @b @at) ///增加点之间的连线
ciopts(lpattern(dash) recast(rcap) msize(medium)) ///CI为虚线上下封口
msymbol(circle_hollow) ///plot空心格式
scheme(s1mono)
//系数β_(-11)到β_(-2)在统计上并不显著异于0（95%的置信区间包含了0值），说明平行趋势假设成立

mi estimate: xtreg lntotal_patent pre* current post* i.year, fe vce(cluster code)
*绘图
coefplot, baselevels keep(pre* current post*) ///
vertical ///转置图形
coeflabels(pre11 = "-11" pre10 = "-10" pre9 = "-9" pre8 = "-8" pre7 = "-7" pre6 = "-6" pre5 = "-5" pre4 = "-4" pre3 = "-3" pre2 = "-2" current = "0" post1 = "1" post2 = "2" post3 = "3" post4 = "4") ///
yline(0,lcolor(edkblue*0.8)) ///加入y=0这条虚线
ylabel(-2(0.5)3) ///
xline(11, lwidth(vthin) lpattern(dash) lcolor(teal)) ///
ylabel(,labsize(*0.75)) xlabel(,labsize(*0.75)) ///
ytitle("政策动态经济效应", size(small)) ///加入Y轴标题,大小small
xtitle("政策时点", size(small)) ///加入X轴标题，大小small 
addplot(line @b @at) ///增加点之间的连线
ciopts(lpattern(dash) recast(rcap) msize(medium)) ///CI为虚线上下封口
msymbol(circle_hollow) ///plot空心格式
scheme(s1mono)
//系数β_(-11)到β_(-2)在统计上并不显著异于0（95%的置信区间包含了0值），说明平行趋势假设成立

mi estimate: xtreg lntotal_score pre* current post* i.year, fe vce(cluster code)
*绘图
coefplot, baselevels keep(pre* current post*) ///
vertical ///转置图形
coeflabels(pre11 = "-11" pre10 = "-10" pre9 = "-9" pre8 = "-8" pre7 = "-7" pre6 = "-6" pre5 = "-5" pre4 = "-4" pre3 = "-3" pre2 = "-2" current = "0" post1 = "1" post2 = "2" post3 = "3" post4 = "4") ///
yline(0,lcolor(edkblue*0.8)) ///加入y=0这条虚线
ylabel(-0.5(0.1)0.5) ///
xline(11, lwidth(vthin) lpattern(dash) lcolor(teal)) ///
ylabel(,labsize(*0.75)) xlabel(,labsize(*0.75)) ///
ytitle("政策动态经济效应", size(small)) ///加入Y轴标题,大小small
xtitle("政策时点", size(small)) ///加入X轴标题，大小small 
addplot(line @b @at) ///增加点之间的连线
ciopts(lpattern(dash) recast(rcap) msize(medium)) ///CI为虚线上下封口
msymbol(circle_hollow) ///plot空心格式
scheme(s1mono)
//系数β_(-11)到β_(-2)在统计上并不显著异于0（95%的置信区间包含了0值），说明平行趋势假设成立


*** Housekeeping ***

clear all
log close
