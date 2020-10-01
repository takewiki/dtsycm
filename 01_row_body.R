menu_row <- tabItem(tabName = "row",
                    fluidRow(
                      column(width = 4,
                             box(
                               title = "流量", width = NULL, solidHeader = TRUE, status = "primary",
                              # actionButton('preview','预览'),
                               mdl_download_button('download','下载流量数据')
                              
                             )
                      ),
                      
                      column(width = 8,
                             box(
                               title = "流量概览", width = NULL, solidHeader = TRUE, status = "primary",
                               mdl_dataTable('pre_data',label = '预览数据')
                             )
                      )
                    )
)