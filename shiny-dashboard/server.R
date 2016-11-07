library(RODBC)

function(input, output) {
  
  getSQLData <- function(maxCategory) {
    
    #an odbc connection called 'localhost'
    myconn <-odbcConnect("localhost")
    
    #MSSQL msdb database
    qry = paste0("select top 20 ROW_NUMBER() over (order by s2.category_id desc) as id,
                 sin(s2.category_id * s1.category_id * ", maxCategory,") value
                 from msdb..syscategories s1 cross join msdb..syscategories s2
                 where s2.category_id * sin(s1.category_id) > 4 * ", maxCategory, " and s1.category_type = 1 order by 1")
    dataset <- sqlQuery(channel=myconn, query=qry)
    
    close(myconn)
    return(dataset)
  }  

  sqlData <- reactive({getSQLData(input$categoryFilter)})
  
  output$sqlhighchart <- renderHighchart({
    
    selectedSQLData <- sqlData()
    
    hc <- highchart(type = "chart")  %>%
      hc_add_series( name = input$categoryFilter,
                     data = selectedSQLData$value  )
    
    hc <- hc %>% 
      hc_add_theme(hc_theme_google()) %>% 
      hc_title(text = paste0("SQL Data ", input$categoryFilter)) %>% 
      hc_subtitle(text = "Source: MSSQL") %>% 
      hc_yAxis(title = list(text = "ID")) %>% 
      hc_xAxis(categories = selectedSQLData$id)
    
    return(hc)
    
  })  
  
}
