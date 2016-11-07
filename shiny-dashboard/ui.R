library(shinydashboard)
library(highcharter)

dashboardPage(
  skin = "black",
  dashboardHeader(title = "R Highchart", disable = FALSE),
  dashboardSidebar(
    sidebarMenu(
      menuItem("SQL Graph", tabName = "graphs", icon = icon("bar-chart"))
    )
  ),
  dashboardBody(
    tags$head(tags$script(src = "js/ga.js")),
    tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "css/custom_fixs.css")),

    tabItems(
      tabItem(tabName = "graphs",
              fluidRow(
                column(3, selectInput("categoryFilter", label = "Category", choices = list("Category 1" = 1, "Category 2" = 2, "Category 3" = 3), selected = 1))
              ),
              box(width = 6, highchartOutput("sqlhighchart"))
      )
    )
  )
)


