menu_column <- tabItem(tabName = "column",
                       fluidRow(
                         column(width = 4,
                                box(
                                  title = "销售预测", width = NULL, solidHeader = TRUE, status = "primary",
                                  # actionButton('preview','预览'),
                                  mdl_download_button('download_sf','下载销售预测数据')
                                  
                                )
                         ),
                         
                         column(width = 8,
                                box(
                                  title = "流量概览", width = NULL, solidHeader = TRUE, status = "primary",
                                  mdl_dataTable('pre_data_sf',label = '预览数据')
                                )
                         )
                       )
)