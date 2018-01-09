library(dygraphs)
#install.packages("shinythemes")
library(shinythemes)
#install.packages("shinyTime")
library(shinyTime)

fluidPage(

  theme = shinytheme("cosmo"),#  
  titlePanel('Monitoraggio temperatura e umidità'),
  sidebarLayout(
    
    sidebarPanel(

      selectInput("dataset", "Mese:",
                  choices = c(#"Tutti i dati",
                              "Maggio 2017",
                              "Giugno 2017",
                              "Luglio 2017",
                              "Agosto 2017",
                              "Settembre 2017",
                              "Ottobre 2017",
                              "Novembre 2017",
                              "Dicembre 2017",
                              "Gennaio 2018"),
                  selected = "Gennaio 2018"
      ),
      
      #checkboxGroupInput("sensors", "Sonde:",
      #                   choices = c("A" = "a_sens",
      #                               "B" = "b_sens",
      #                               "C" = "c_sens",
      #                               "D" = "d_sens"),
      #                   selected = c("A","B","C","D"),
      #                   inline = TRUE),
      
      #dateRangeInput("dates", label = "Date range:", 
      #               start=min(""), end = ""),
      
      width=3  #,
      #selected="Luglio 2017"
    ),
    
  mainPanel(
      
      tabsetPanel(
      
        tabPanel("Dati", dataTableOutput('table'))
        ,
        tabPanel("Grafico temperature LAB",dygraphOutput("tgraph",
                                                                   width="100%")),
        tabPanel("Grafico umidità relativa LAB",dygraphOutput("ulab_graph",
                                                              width="100%")),
        #tabPanel("Grafico temperatura CELLA",dygraphOutput("tgraph",
        #                                                           width="100%")),
        tabPanel("Grafico umidità relativa CELLA",dygraphOutput("uc_graph",
                                                                  width="100%"))
        
        
        )
    )
    
  )
)