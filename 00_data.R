# 设置app标题-----

app_title <-'生产参谋数据平台V3.1';

# store data into rdbe in the rds database
app_id <- 'dtsycm'

#设置数据库链接---

conn_be <- conn_rds('rdbe')



#设置链接---
conn <- conn_rds('nsic')


shopInfo <- function(){
  sql <- "select *from t_sycm_shopInfo"
  res <- tsda::sql_select(conn,sql)
  return(res)
}

shopInfoCN <- function(){
  data <-shopInfo()
  names(data) <-c('访客数','访客数同比','浏览量','浏览量同比','人均浏览量','人均浏览量同比','关注店铺人数','关注店铺人数同比')
  return(data)
}


sfInfo <- function(){
  sql <- "select *from t_sycm_salesForecast"
  res <- tsda::sql_select(conn,sql)
  return(res)
}

sfInfoCN <- function(){
  data <-sfInfo()
  names(data) <-c('商品ID','商品名称','系统预测未来7天销量','最近7天新增加购件数','最近7天新增收藏人数','最近180天累计加购件数','最近180天累计收藏人数')
  return(data)
}

mydata <- shopInfoCN()
mydata




#处理市场行业信息



IndInfo <- function(){
  sql <- "select *from t_sycm_marketInd"
  res <- tsda::sql_select(conn,sql)
  return(res)
}

IndInfoCN <- function(){
  data <-IndInfo()
  names(data) <-c('店铺行业排名','店铺支付金额','本店支付占比')
  return(data)
}



#处理门店监控
shopRankInfo <- function(){
  sql <- "select * from t_sycm_marketShopRank"
  res <- tsda::sql_select(conn,sql)
  return(res)
}

shopRankInfoCN <- function(){
  data <-shopRankInfo()
  names(data) <-c('店铺','行业排名','行业排名变动','交易指数','流量指数')
  return(data)
}




# 设置3条消息框------
msg <- list(
  list(from = "人力资源部1",
       message= "7月工资表已完成计算"),
  list(from="数据部2",
       message = "HR功能已更新到V2",
       icon = "question",
       time = "13:45"
  ),
  list(from = "技术支持3",
       message = "新的HR数据中台已上线.",
       icon = "life-ring",
       time = "2019-08-26"
  )
)



chinaProvice <- c("新疆", "西藏", "内蒙古", "青海", "四川", "黑龙江", "甘肃", "云南", "广西", "湖南", "陕西", "广东", "吉林", "河北", "湖北", "贵州", "山东", "江西", "河南", "辽宁", "山西", "安徽", "福建", "浙江", "江苏", "重庆", "宁夏", "海南", "台湾", "北京", "天津", "上海", "香港", "澳门")
#chinaProvice;

totGDP <- data.table::dcast(ChinaGDP, Prov~., sum, value.var='GDP')
ChinaGDP <- ChinaGDP[order(ChinaGDP$Year),]
# ChinaGDP
#0.02 china pm2.5----

names(chinapm25) <- c('name', 'value', 'lng', 'lat')

#0.03 china flight----
route <- flight$route
names(route) <- c('name1', 'name2')
coord <- flight$coord
target <- data.frame(
  name1=c(rep('北京', 10), rep('上海', 10), rep('广州', 10)),
  name2=c(
    "上海","广州","大连","南宁","南昌","拉萨","长春","包头","重庆","常州",
    "包头","昆明","广州","郑州","长春","重庆","长沙","北京","丹东","大连",
    "福州","太原","长春","重庆","西安","成都","常州","北京","北海","海口"),
  value=c(95,90,80,70,60,50,40,30,20,10,95,90,80,70,60,50,40,30,20,10,95,90,
          80,70,60,50,40,30,20,10))
# series column mapping series of addML/addMP
target$series <- paste0(target$name1, 'Top10')

## apply addGeoCoord, and add markLines without values
g <- echartr(NULL, type='map_china') %>% addGeoCoord(coord) %>%
  addML(series=1, data=route, symbol=c('none', 'circle'), symbolSize=1, 
        smooth=TRUE, itemStyle=list(normal=itemStyle(
          color='#fff', borderWidth=1, borderColor='rgba(30,144,255,0.5)')))

## modify itemStyle of the base map to align the areaStyle with bgColor and 
## disable `hoverable`
g <- g %>% setSeries(hoverable=FALSE, itemStyle=list(
  normal=itemStyle(
    borderColor='rgba(100,149,237,1)', borderWidth=0.5, 
    areaStyle=areaStyle(color='#1b1b1b'))
))

## add markLines with values
line.effect <- list(
  show=TRUE, scaleSize=1, period=30, color='#fff', shadowBlur=10)
line.style <- list(normal=itemStyle(
  borderWidth=1, lineStyle=lineStyle(type='solid', shadowBlur=10)))
g1 <- g %>% 
  addML(series=c('北京Top10', '上海Top10', '广州Top10'), data=target, 
        smooth=TRUE, effect=line.effect, itemStyle=line.style)
## add markPoints
## series better be 2, 3, 4 rather than the series names
jsSymbolSize <- JS('function (v) {return 10+v/10;}')
mp.style <- list(normal=itemStyle(label=labelStyle(show=FALSE)), 
                 emphasis=itemStyle(label=labelStyle(position='top')))
g2 <- g1 %>%
  addMP(series=2:4, data=target[,c("name2", "value", "series")],
        effect=list(show=TRUE), symbolSize=jsSymbolSize, 
        itmeStyle=mp.style) 
## setDataRange
g3 <- g2 %>%
  setDataRange(
    color=c('#ff3333', 'orange', 'yellow','limegreen','aquamarine'),
    valueRange=c(0, 100), textStyle=list(color='#fff'),
    splitNumber=0)

## setTheme
g3 <- g3 %>% setLegend(pos=10, selected='上海Top10', textStyle=list(color='#fff')) %>%
  setTheme(palette=c('gold','aquamarine','limegreen'), bgColor='#1b1b1b') %>%
  setToolbox(pos=3) %>% 
  setTitle('china flight3', 'Fictious Data', pos=12, 
           textStyle=list(color='white'))


# china heat map----
heatmap <- sapply(1:15, function(i){
  x <- 100 + runif(1, 0, 1) * 16
  y <- 24 + runif(1, 0, 1) * 12
  lapply(0:floor(50 * abs(rnorm(1))), function(j){
    c(x+runif(1, 0, 1)*2, y+runif(1, 0, 1)*2, runif(1, 0, 1))
  })
})
heatmap <- data.frame(matrix(unlist(heatmap), byrow=TRUE, ncol=3))

#provice Revelue----
revelue <-round(runif(9)*10000000,2)
provice=c(rep("上海",3),rep("浙江",3),rep("江苏",3))
city <-c("浦东新区","奉贤区","金山区","宁波市","杭州市","台州市","宿迁市","南京市","镇江市")
chinaRevalue <-data.frame(provice,city,revelue)

#treemap data prepared----
treedata <- data.frame(
  node=c('IOS', 'Android', 'Samsung', 'Apple', 'Huawei', 'Lenovo', 'Xiaomi', 
         'Others', 'LG', 'Oppo', 'Vivo', 'ZTE', 'Other'),
  parent=c(rep(NA, 2), 'Android', 'IOS', rep('Android', 4), rep('Others', 5)),
  series=(rep('Smartphone', 13)),
  value=c(231.5, 1201.4, 324.8, 231.5, 106.6, 74, 70.8, 625.2, 51.7, 49.1,
          42.6, 40, 243))
treedata1 <- treedata[3:13,]
treedata1$series <- c('Android', 'IOS', rep('Android', 9))
treedata1$parent[1:6] <- NA

#dashboard data----
db_data = data.frame(x=rep(c('KR/min', 'Kph'), 2), y=c(6.3, 54, 7.5, 82), 
                     z=c(rep('t1', 2), rep('t2', 2)))


# bar chart data  ----
titanic <- data.table::melt(apply(Titanic, c(1,4), sum))
names(titanic) <- c('Class', 'Survived', 'Count')

# line chart data----

aq <- airquality
aq$Date <- as.Date(paste('1973', aq$Month, aq$Day, sep='-'))
aq$Day <- as.character(aq$Day)
aq$Month <- factor(aq$Month, labels=c("May", "Jun", "Jul", "Aug", "Sep"))

#dygraphs data prepared----
lungDeaths <- cbind(mdeaths, fdeaths)



