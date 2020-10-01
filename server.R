

#shinyserver start point----
 shinyServer(function(input, output,session) {
    #00-基础框设置-------------
    #读取用户列表
    user_base <- getUsers(conn_be,app_id)
    
    
    
    credentials <- callModule(shinyauthr::login, "login", 
                              data = user_base,
                              user_col = Fuser,
                              pwd_col = Fpassword,
                              hashed = TRUE,
                              algo = "md5",
                              log_out = reactive(logout_init()))
    
    
    
    logout_init <- callModule(shinyauthr::logout, "logout", reactive(credentials()$user_auth))
    
    observe({
       if(credentials()$user_auth) {
          shinyjs::removeClass(selector = "body", class = "sidebar-collapse")
       } else {
          shinyjs::addClass(selector = "body", class = "sidebar-collapse")
       }
    })
    
    user_info <- reactive({credentials()$info})
    
    #显示用户信息
    output$show_user <- renderUI({
       req(credentials()$user_auth)
       
       dropdownButton(
          fluidRow(  box(
             title = NULL, status = "primary", width = 12,solidHeader = FALSE,
             collapsible = FALSE,collapsed = FALSE,background = 'black',
             #2.01.01工具栏选项--------
             
             
             actionLink('cu_updatePwd',label ='修改密码',icon = icon('gear') ),
             br(),
             br(),
             actionLink('cu_UserInfo',label = '用户信息',icon = icon('address-card')),
             br(),
             br(),
             actionLink(inputId = "closeCuMenu",
                        label = "关闭菜单",icon =icon('window-close' ))
             
             
          )) 
          ,
          circle = FALSE, status = "primary", icon = icon("user"), width = "100px",
          tooltip = FALSE,label = user_info()$Fuser,right = TRUE,inputId = 'UserDropDownMenu'
       )
       #
       
       
    })
    
    observeEvent(input$closeCuMenu,{
       toggleDropdownButton(inputId = "UserDropDownMenu")
    }
    )
    
    #修改密码
    observeEvent(input$cu_updatePwd,{
       req(credentials()$user_auth)
       
       showModal(modalDialog(title = paste0("修改",user_info()$Fuser,"登录密码"),
                             
                             mdl_password('cu_originalPwd',label = '输入原密码'),
                             mdl_password('cu_setNewPwd',label = '输入新密码'),
                             mdl_password('cu_RepNewPwd',label = '重复新密码'),
                             
                             footer = column(shiny::modalButton('取消'),
                                             shiny::actionButton('cu_savePassword', '保存'),
                                             width=12),
                             size = 'm'
       ))
    })
    
    #处理密码修改
    
    var_originalPwd <-var_password('cu_originalPwd')
    var_setNewPwd <- var_password('cu_setNewPwd')
    var_RepNewPwd <- var_password('cu_RepNewPwd')
    
    observeEvent(input$cu_savePassword,{
       req(credentials()$user_auth)
       #获取用户参数并进行加密处理
       var_originalPwd <- password_md5(var_originalPwd())
       var_setNewPwd <-password_md5(var_setNewPwd())
       var_RepNewPwd <- password_md5(var_RepNewPwd())
       check_originalPwd <- password_checkOriginal(fappId = app_id,fuser =user_info()$Fuser,fpassword = var_originalPwd)
       check_newPwd <- password_equal(var_setNewPwd,var_RepNewPwd)
       if(check_originalPwd){
          #原始密码正确
          #进一步处理
          if(check_newPwd){
             password_setNew(fappId = app_id,fuser =user_info()$Fuser,fpassword = var_setNewPwd)
             pop_notice('新密码设置成功:)') 
             shiny::removeModal()
             
          }else{
             pop_notice('两次输入的密码不一致，请重试:(') 
          }
          
          
       }else{
          pop_notice('原始密码不对，请重试:(')
       }
       
       
       
       
       
    }
    )
    
    
    
    #查看用户信息
    
    #修改密码
    observeEvent(input$cu_UserInfo,{
       req(credentials()$user_auth)
       
       user_detail <-function(fkey){
          res <-tsui::userQueryField(conn = conn_be,app_id = app_id,user =user_info()$Fuser,key = fkey)
          return(res)
       } 
       
       
       showModal(modalDialog(title = paste0("查看",user_info()$Fuser,"用户信息"),
                             
                             textInput('cu_info_name',label = '姓名:',value =user_info()$Fname ),
                             textInput('cu_info_role',label = '角色:',value =user_info()$Fpermissions ),
                             textInput('cu_info_email',label = '邮箱:',value =user_detail('Femail') ),
                             textInput('cu_info_phone',label = '手机:',value =user_detail('Fphone') ),
                             textInput('cu_info_rpa',label = 'RPA账号:',value =user_detail('Frpa') ),
                             textInput('cu_info_dept',label = '部门:',value =user_detail('Fdepartment') ),
                             textInput('cu_info_company',label = '公司:',value =user_detail('Fcompany') ),
                             
                             
                             footer = column(shiny::modalButton('确认(不保存修改)'),
                                             
                                             width=12),
                             size = 'm'
       ))
    })
    
    
    
    #针对用户信息进行处理
    
    sidebarMenu <- reactive({
       
       res <- setSideBarMenu(conn_rds('rdbe'),app_id,user_info()$Fpermissions)
       return(res)
    })
    
    
    #针对侧边栏进行控制
    output$show_sidebarMenu <- renderUI({
       if(credentials()$user_auth){
          return(sidebarMenu())
       } else{
          return(NULL) 
       }
       
       
    })
    
    #针对工作区进行控制
    output$show_workAreaSetting <- renderUI({
       if(credentials()$user_auth){
          return(workAreaSetting)
       } else{
          return(NULL) 
       }
       
       
    })
    
    
    #01-----
    data <- reactive({
      res <- shopInfoCN()
      return(res)
    })
    
    data2 <- reactive({
      res <-   sfInfoCN()
      return(res)
    })
    
    data3 <- reactive({
      res <-   IndInfoCN()
      return(res)
    })
    
    data4 <- reactive({
      res <-   shopRankInfoCN()
      return(res)
    })
    
    
    
    run_dataTable2('pre_data',data = data())
    
    run_download_xlsx(id = 'download',data = data(),filename = '生意参谋流量数据.xlsx')
    
    run_dataTable2('pre_data_sf',data = data2())
    
    run_download_xlsx(id = 'download_sf',data = data2(),filename = '销售预测数据.xlsx')
    
    run_dataTable2('pre_data_Ind',data = data3())
    
    run_download_xlsx(id = 'download_Ind',data = data3(),filename = '市场监控行业趋势.xlsx')
    
    run_dataTable2('pre_data_shopRank',data = data4())
    
    run_download_xlsx(id = 'download_shopRank',data = data4(),filename = 'TOP监控店铺.xlsx')
    
    #3.03.01 renderPlot----
    set.seed(122)
    histdata <- rnorm(500)
    
    output$output30301 <- renderPlot({
      data <- histdata[seq_len(input$input30301A)]
      hist(data)
    })
    output$TabBoxSelected <-renderText({
      paste0("您选择的是：",input$tabset1)
    })
    output$anyTextShow <- renderText({
      input$anyTextInput
    })
    output$progressBox3 <-renderInfoBox({
      infoBox(
        "infoBox Render", paste0(25 + 2, "%"), icon = icon("list"),
        color = "purple"
      )
    })
    output$progressBox4 <-renderInfoBox({
      infoBox(
        "infoBox Render (filled)", paste0(25 + 55, "%"), icon = icon("list"),
        color = "purple",fill=TRUE
      )
    })
    output$approvalBox4 <- renderValueBox({
      valueBox(
        "80%", "value box Render", icon = icon("thumbs-up", lib = "glyphicon"),
        color = "yellow"
      )
    })
    output$map40301 <-renderEChart({
      
      # generate bins based on input$bins from ui.R
      
      
      
      p<-echartr(ChinaGDP, Prov, GDP, Year, type="map_china") 
      p <-p  %>%  setDataRange(splitNumber=0, valueRange=range(totGDP[, 2]), 
                               color=c('red','orange','yellow','limegreen','green')) 
      p <-p %>%    setTitle("China GDP by Provice, 2012-2014")
      
      print(p)
      
      
    })
    #4.03.02 china map with timeline----
    output$map40302 <-renderEChart({
      p <- echartr(ChinaGDP, Prov, GDP, t=Year, type="map_china", subtype='average')
      p <- p %>% setDataRange(splitNumber=0,color=c('red','orange','yellow','limegreen','green')) 
      p <- p %>% setTitle("China GDP by Provice")
      print(p)
    })
    #4.03.03 china map fight----
    output$map40303 <- renderEChart({
      
      print(g1)
    })
    #4.03.04 china map flight2----
    output$map40304 <- renderEChart({
      print(g2)
    })
    #4.03.05 china map flight3----
    output$map40305 <- renderEChart({
      print(g3)
    })
    output$map40306 <- renderEChart({
      mp4 <- echartr(NULL, type="map_china") 
      mp4 <- mp4 %>% addHeatmap(data=heatmap)
      print(mp4)
    })
    output$map40501 <- renderEChart({
      revedata<-chinaRevalue[chinaRevalue$provice ==input$Input40501,c("city","revelue")]
      mp5<-NULL
      if (nrow(revedata) > 0)
      {
        mp5<-echartr(revedata,city,revelue, type='map_china', subtype=input$Input40501) 
        
      }else{
        mp5<-echartr(NULL, type='map_china', subtype=input$Input40501)
      }
      mp5 <- mp5 %>% setTitle(paste0("中国",input$Input40501,"地图"))
      print(mp5)
      
      
    })
    #4.05.02leaflet-----
    output$leftlet40502 <- renderLeaflet({
      points <- cbind(rnorm(40) * 2 + 13, rnorm(40) + 48)
      p<-leaflet() %>%
        addProviderTiles(providers$Stamen.TonerLite,
                         options = providerTileOptions(noWrap = TRUE)
        ) %>% addMarkers(data = points)
      print(p)
    })
    # #4.05.03----
    # 
    # 
    # output$dygraph <- renderDygraph({
    # 
    #   p <- dygraph(lungDeaths) 
    #   p <- p %>% dySeries("mdeaths", label = "Male") 
    #   p <- p %>% dySeries("fdeaths", label = "Female") 
    #   p <- p %>% dyOptions(stackedGraph = TRUE) 
    #   p <- p %>% dyRangeSelector(height = 20)
    #   print(p)
    # })
    # 
    output$map40601 <- renderEChart({
      mp6<- echartr(stock, as.character(date), c(open, close, low, high), type='k') 
      mp6 <- mp6 %>% setXAxis(name='日期', axisLabel=list(rotate=30)) 
      mp6 <- mp6 %>% setYAxis(name="价格")
      print(mp6)
    })
    output$map40701 <- renderEChart({
      mp7 <- echartr(treedata, c(node, parent), value, facet=series, type='treemap') 
      mp7 <- mp7 %>% setTitle('Smartphone Sales 2015 (Million)', pos=5)
      print(mp7)
    })
    output$map40702 <- renderEChart({
      mp8 <- echartr(treedata1, c(node, parent), value, facet=series, type='treemap') 
      mp8 <- mp8 %>% setTitle('Smartphone Sales 2015 (Million)', pos=5)
      print(mp8)
      
      
    })
    #4.08.01 dashboard 1----
    output$map40801 <- renderEChart({
      p9 <- echartr(db_data, x, y, type='gauge')
      print(p9)
    })
    output$map40802 <- renderEChart({
      p10 <- echartr(db_data, x, y,facet=x, type='gauge')
      print(p10)
      
    })
    output$map40803 <- renderEChart({
      p11 <- echartr(db_data, x, y,facet=x,t=z, type='gauge')
      print(p11)
    })
    output$map40901 <- renderEChart({
      p<- echartr(iris, x=Sepal.Width, y=Petal.Width)
      print(p)
      
    })
    output$map40902 <- renderEChart({
      p<- echartr(iris, x=Sepal.Width, y=Petal.Width, series=Species)
      print(p)
    })
    output$map40903 <- renderEChart({
      p<- echartr(iris, Sepal.Width, Petal.Width, weight=Petal.Length, type='bubble')
      print(p)
    })
    output$map40904 <- renderEChart({
      p <- echartr(iris, Sepal.Width, Petal.Width, weight=Petal.Length) 
      p <- p %>% setDataRange(calculable=TRUE, splitNumber=0, labels=c('Big', 'Small'),
                              color=c('red', 'yellow', 'green'), valueRange=c(0, 2.5))
      print(p)
    })
    output$map40905 <- renderEChart({
      lm <- with(iris, lm(Petal.Width~Sepal.Width))
      pred <- predict(lm, data.frame(Sepal.Width=c(2, 4.5)))
      p<- echartr(iris, Sepal.Width, Petal.Width, Species) 
      p <- p %>% addML(series=1, data=data.frame(name1='Max', type='max')) 
      p <- p %>% addML(series=2, data=data.frame(name1='Mean', type='average')) 
      p <- p %>% addML(series=3, data=data.frame(name1='Min', type='min')) 
      p <- p %>% addMP(series=2, data=data.frame(name='Max', type='max')) 
      p <- p %>% addML(series='Linear Reg', data=data.frame(
        name1='Reg', value=lm$coefficients[2], 
        xAxis1=2, yAxis1=pred[1], xAxis2=4.5, yAxis2=pred[2]))
      print(p)
    })
    output$map41001 <- render_echart({
      p <- echartr(titanic[titanic$Survived=='Yes',], Class, Count) 
      p <- p %>% setTitle('Titanic: 生存人员按乘坐等级计数')
      print(p)
    })
    output$map41002 <- renderEChart({
      p <- echartr(titanic, Class, Count, Survived) 
      p <- p %>% setTitle('Titanic:所有人员按乘坐等级计数')
      print(p)
      
    })
    output$map41003 <- renderEChart({
      p <- echartr(titanic, Class, Count, Survived, type='hbar', subtype='stack') 
      p <- p %>% setTitle('Titanic: 按乘坐等级计数堆积展示') 
      print(p)
      
    })
    output$map41004 <- renderEChart({
      titanic_tc <- titanic
      titanic_tc$Count[titanic_tc$Survived=='No'] <- 
        - titanic_tc$Count[titanic_tc$Survived=='No']
      g <- echartr(titanic_tc, Class, Count, Survived, type='hbar') 
      g <- g %>% setTitle("Titanic: 暴风图")
      g <- g %>% setYAxis(axisLine=list(onZero=TRUE)) 
      g <- g %>%  setXAxis(axisLabel=list(formatter=JS('function (value) {return Math.abs(value);}')))
      print (g)
    })
    output$map41101 <- renderEChart({
      p <- echartr(aq, Date, Temp, type='line') 
      p <- p %>% setTitle('NY Temperature May - Sep 1973') 
      p <- p %>% setSymbols('none')
      print(p)
    })
    output$map41102 <- renderEChart({
      p <- echartr(aq, Day, Temp, Month, type='line') 
      p <- p %>% setTitle('NY Temperature May - Sep 1973, by Month') 
      p <- p %>% setSymbols('emptycircle')
      print(p)
    })
    output$map41103 <- renderEChart({
      p <- echartr(aq, Date, Temp, type='wave') 
      p <- p %>% setTitle('NY Temperature May - Sep 1973') 
      p <- p %>% setSymbols('emptycircle')
      print(p)
    })
    output$map41104 <- renderEChart({
      p <- echartr(aq, Day, Temp, Month, type='wave', subtype='stack') %>%
        setTitle('NY Temperature May - Sep 1973, by Month') %>% 
        setSymbols('emptycircle')
      print(p)
      
    })
    output$datatable40401<-renderDataTable({
      mtcars[  ,input$input40401,drop=FALSE]
    },options = list(orderClasses = TRUE,
                     lengthMenu = c(5, 15,30,50,75,100), 
                     pageLength = 5))
    #option 是可以使用的参数 
    #orderClasses确认了选中进行高亮； 
    #lengthMenu定义了下拉框的选项
    #pageLength=定义了默认的页面大小
    
    output$output30101B <- renderText({
      if (input$check30101B)
        toupper(input$Input30101B)
      else
        input$Input30101B
    })
   
   
   
   
  
})
