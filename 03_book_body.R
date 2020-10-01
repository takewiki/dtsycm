menu_book <- tabItem(tabName = "book",
  
                     
                     fluidRow(
                       column(width = 4,
                              box(
                                title = "销售预测", width = NULL, solidHeader = TRUE, status = "primary",
                                # actionButton('preview','预览'),
                                mdl_download_button('download_Ind','下载市场监控行业趋势')
                                
                              )
                       ),
                       
                       column(width = 8,
                              box(
                                title = "行业趋势", width = NULL, solidHeader = TRUE, status = "primary",
                                mdl_dataTable('pre_data_Ind',label = '预览数据')
                              )
                       )
                     )
)