menu_series<- tabItem(tabName = "series",
                      fluidRow(
                        column(width = 4,
                               box(
                                 title = "TOP 监控店铺", width = NULL, solidHeader = TRUE, status = "primary",
                                 # actionButton('preview','预览'),
                                 mdl_download_button('download_shopRank','下载市场监控店铺')
                                 
                               )
                        ),
                        
                        column(width = 8,
                               box(
                                 title = "TOP 监控店铺", width = NULL, solidHeader = TRUE, status = "primary",
                                 mdl_dataTable('pre_data_shopRank',label = '预览数据')
                               )
                        )
                      )
)