menu_majority <- tabItem(tabName = "majority",
                         tabsetPanel(
                           #4.01----
                           
                           #4.03 map----
                           tabPanel("中国地图",
                                    fluidRow(
                                      #4.03.01 map:china map----
                                      box(title="china map",width = 6,status = "primary",
                                          eChartOutput("map40301",height="400px")),
                                      
                                      #4.03.03 map:china map:timeline----
                                      box(tilte="china map 2 ",width = 6,status = "primary",
                                          eChartOutput("map40302",height = "450px"))
                                    ),
                                    fluidRow(
                                      #4.03.03
                                      box(title = "china flight1",width = 6,status = "primary",
                                          eChartOutput("map40303")),
                                      #4.03.04 china flight 2----
                                      box(title = "china flight2",width = 6,status = "primary",
                                          eChartOutput("map40304"))
                                    ),
                                    fluidRow(
                                      #4.03.05 china flight3----
                                      box(title = "china flight3",width = 6,status = "primary",
                                          eChartOutput("map40305")),
                                      #4.03.06 china heat map----
                                      box(title = "china flight3",width = 6,status = "primary",
                                          eChartOutput("map40306"))
                                      
                                    )),
                           tabPanel("中国省份地图",
                                    #4.05.01 china province----
                                    
                                    fluidRow(
                                      box(title = "条件过滤", width=4,status = "primary",
                                          selectInput("Input40501", "请选择一个省份:",
                                                      chinaProvice,selected = "上海")),
                                      box(title = "中国省份地图",width = 8,status = "primary",
                                          eChartOutput("map40501"))),
                                    #4.05.02left map ----
                                    fluidRow(
                                      box(title = "leaflet Map",width = 8,status = "primary",
                                          leafletOutput("leftlet40502")),
                                      box()
                                    )
                                    # ,
                                    # #4.05.03  dygraphs-----
                                    # fluidRow(
                                    #   box(numericInput("months", label = "Months to Predict", 
                                    #                    value = 72, min = 12, max = 144, step = 12),
                                    #     selectInput("interval", label = "Prediction Interval",
                                    #                 choices = c("0.80", "0.90", "0.95", "0.99"),
                                    #                 selected = "0.95"),
                                    #     checkboxInput("showgrid", label = "Show Grid", value = TRUE)),
                                    # box(
                                    #   dygraphOutput("dygraph")
                                    # ))
                                    
                           ),
                           #4.04 datatable Render----
                           tabPanel("数据表格",
                                    
                                    fluidRow(
                                      #4.04.01 mtcars datatable
                                      box(title = "条件过滤",width = 6, status ="primary",
                                          checkboxGroupInput("input40401","请选择mtcar中要显示的列",
                                                             names(mtcars),selected=names(mtcars))),
                                      box(title = "mtcars datatable",width = 6,status = "primary",
                                          dataTableOutput('datatable40401'))
                                      
                                    )),
                           
                           tabPanel("K线图",
                                    fluidRow(
                                      #4.06.01 显示数据----
                                      box(title = "按日期显示股票数据",width = 6,status = "primary",
                                          eChartOutput("map40601")),
                                      box()
                                    )
                           ),
                           tabPanel("树形图",
                                    #4.07.01 smart phone analysis 1----
                                    fluidRow(
                                      box(title = "智能手机市场分析1",width = 6,status = "primary",
                                          eChartOutput("map40701")),
                                      #4.07.02 smart phone analysis2----
                                      box(title = "智能手机市场分析2",width = 6,status = "primary",
                                          eChartOutput("map40702"))
                                    )),
                           tabPanel("仪表盘",
                                    #4.08.01----
                                    
                                    fluidRow(
                                      box(title = "单一指标1",width = 6,status = "primary",
                                          eChartOutput("map40801")),
                                      #4.08.02----
                                      box(title = "单一指标_系列",width = 6,status = "primary",
                                          eChartOutput("map40802"))
                                      
                                    ),
                                    fluidRow(
                                      #4.08.03----
                                      box(title = "多重指标_时间线",width = 12,status = "primary",
                                          eChartOutput("map40803"))
                                    )
                           ),
                           tabPanel("散点图",
                                    
                                    fluidRow(
                                      #4.09.01----
                                      box(title = "2变量散点图",width = 6,status = "primary",
                                          eChartOutput("map40901")),
                                      #4.09.02 2变量散点图外加系列数据----
                                      box(title = "2变量散点图_系列",width = 6,status = "primary",
                                          eChartOutput("map40902"))
                                    ),
                                    fluidRow(
                                      #4.09.03 3变量散点图
                                      box(title = "3变量散点/气泡图",width = 6,status = "primary",
                                          eChartOutput("map40903")),
                                      #4.09.04 3变量数据----
                                      box(title = "3变量散点_数据值域",width = 6,status = "primary",
                                          eChartOutput("map40904"))
                                    ),
                                    fluidRow(
                                      #4.09.05 增加辅助线，点----
                                      box(title = "3变量散点_辅助线点",width = 6,status = "primary",
                                          eChartOutput("map40905")),
                                      box(),
                                      box()
                                    )),
                           tabPanel("柱状图",
                                    
                                    fluidRow(
                                      #4.10.01 single bar chart ----
                                      box(title = "柱状图1",width = 6,status = "primary",
                                          eChartOutput("map41001")),
                                      #4.10.02 柱状图，分系列----
                                      box(title = "柱状图2",width = 6,status = "primary",
                                          eChartOutput("map41002"))
                                    ),
                                    fluidRow(
                                      #4.10.03 柱状图，分系列，堆积图 ----
                                      box(title = "柱状图分系列堆积图",width = 6,status = "primary",
                                          eChartOutput("map41003")),
                                      #4.10.04----
                                      box(title = "柱状图4",width = 6,status = "primary",
                                          eChartOutput("map41004"))
                                    ),
                                    fluidRow(
                                      box(),
                                      box(),
                                      box()
                                    )),
                           tabPanel("拆线面积图",
                                    #4.11.01 拆线图 
                                    fluidRow(
                                      box(title = "拆线图1",width = 6,status = "primary",
                                          eChartOutput("map41101")),
                                      box(title = "拆线图2",width = 6,status = "primary",
                                          eChartOutput("map41102"))
                                    ),
                                    fluidRow(
                                      box(title = "拆线图3",width = 6,status = "primary",
                                          eChartOutput("map41103")),
                                      box(title = "拆线图4",width = 6,status = "primary",
                                          eChartOutput("map41104"))
                                    ),
                                    fluidRow(
                                      box(),
                                      box(),
                                      box()
                                    )),
                           tabPanel("一般图表",
                                    
                                    fluidRow(
                                      #3.03.01 plotOutput----
                                      box(title = "plotOutput > renderPlot",width = 4, status = "primary",
                                          sliderInput("input30301A","Number of Observations",1,100,30),
                                          plotOutput("output30301",height = 250)),
                                      box(title = "verbatimTextOutput >renderText",width = 4, status = "primary",
                                          textInput(inputId="Input30101B","请输入文本："),
                                          checkboxInput("check30101B","统一为大写字母",value = FALSE),
                                          bookmarkButton("保存为标签"),
                                          tags$h4("显示输入文本："),
                                          br(),
                                          verbatimTextOutput("output30101B"))
                                      
                                    )
                           ),
                           #4.02----
                           tabPanel("信息面板",
                                    
                                    fluidRow(
                                      infoBoxOutput("progressBox3"),
                                      infoBoxOutput("progressBox4"),
                                      box(title = "Histogram", width=4,status = "primary",textInput(inputId="layout23","layout23"))
                                    ),
                                    fluidRow(
                                      valueBox(10 * 2, "valueBox (static)", icon = icon("credit-card")),
                                      valueBoxOutput("approvalBox4"),
                                      infoBox("infoBox static Demo", 10 * 2, icon = icon("credit-card")))
                           )  
                           
                         )
                         
                         
                         
)