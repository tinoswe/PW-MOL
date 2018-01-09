library(shiny)
library(lubridate)
library(dygraphs)
library(xts)
library(lubridate)
library(forecast)

source("get_all_data.R")

df_may17 <- df_all[month(df_all$time)==5 & year(df_all$time)==2017,]
#source("mod_may17.R")
#df_may17 <- modify_may17(df_may17)

df_jun17 <- df_all[month(df_all$time)==6 & year(df_all$time)==2017,]
#source("mod_jun17.R")
#df_jun17 <- modify_jun17(df_jun17)

df_jul17 <- df_all[month(df_all$time)==7 & year(df_all$time)==2017,]
#source("mod_jul17.R")
#df_jul17 <- modify_jul17(df_jul17)

df_aug17 <- df_all[month(df_all$time)==8 & year(df_all$time)==2017,]
#source("mod_aug17.R")
#df_aug17 <- modify_aug17(df_aug17)

df_sep17 <- df_all[month(df_all$time)==9 & year(df_all$time)==2017,]
#source("mod_sep17.R")
#df_sep17 <- modify_sep17(df_sep17)

df_oct17 <- df_all[month(df_all$time)==10 & year(df_all$time)==2017,]

df_nov17 <- df_all[month(df_all$time)==11 & year(df_all$time)==2017,]

df_dec17 <- df_all[month(df_all$time)==12 & year(df_all$time)==2017,]

df_jan18 <- df_all[month(df_all$time)==1 & year(df_all$time)==2018,]



function(input, output) {
  
  datasetInput <-   reactive({
  
     switch(input$dataset,
            "Gennaio 2018" = df_jan18,
            "Dicembre 2017" = df_dec17,
            "Novembre 2017" = df_nov17,
            "Ottobre 2017" = df_oct17,
            "Settembre 2017" = df_sep17,
            "Agosto 2017" = df_aug17,
            "Luglio 2017" = df_jul17,
            "Giugno 2017" = df_jun17,
            "Maggio 2017" = df_may17
            )
   })

  output$table <- renderDataTable( #{

    dataset <- datasetInput(),
    options = list(pageLength = 25,
                   dom  = 'tip',
                   autoWidth = TRUE,
                   columnDefs = list(list(width = '150px', 
                                          targets = c(0))
                                     )
                   )
    )
                   
    
  output$tgraph <- renderDygraph({

    library(reshape)
    data <- datasetInput()

    data_T <- data[, !grepl( "_HR" , names( data ) )]# & !grepl( "cella_T" , names( data ) )]
    data_HR <- data[, !grepl( "_T" , names( data ) )]
    data_t <- data_T$time #as.POSIXct(data_T$time,
                          #tz="Europe/Rome")
    
    xx <- xts(data_T[,names(data_T)!="time"],
              data_t)
    #OlsonNames()
    indexTZ(xx) <- "Etc/GMT+2"
    #index(tail(xx))

    dygraph(xx) %>%
      dyOptions(connectSeparatedPoints = FALSE) %>%
      dyAxis("y", valueRange = c(10, 35), label="Temp [°C]") %>% 
      dyLimit(as.numeric(15.5), color = "red") %>%
      dyLimit(as.numeric(24.5), color = "red") %>%
      dyEvent(c("2017-05-12 06:30:00", "2017-05-12 22:59:00"), c("Inizio taratura", "Fine taratura"), labelLoc = "bottom") %>%
      dyEvent(c("2017-06-05 05:00:00"), c("Chiller ON"), labelLoc = "bottom") %>%
      dyEvent(c("2017-06-06 12:45:00"), c("Switched off due to heavy rain"), color="grey", labelLoc = "top", strokePattern="dashed") %>%
      dyEvent(c("2017-06-07 04:45:00"), c("Switched on after heavy rain"), labelLoc = "top", strokePattern="dashed", color="grey") %>%
      dyEvent(c("2017-06-28 07:00:00"), c("New door opened and not closed"), labelLoc = "top", strokePattern="dashed", color="grey")
    }
  )
  
 output$uc_graph <- renderDygraph({
   library(reshape)
   data <- datasetInput()
   data_T <- data[, !grepl( "_HR" , names( data ) )]
   data_HR <- data[, grepl( "time" , names( data ) ) | grepl( "cella_HR" , names( data ) )]
   xx<-xts(data_HR[,names(data_HR)!="time"],
       strptime(data_HR$time, format = "%Y-%m-%d %H:%M:%S"),
       tz="UTC"
       )
     dygraph(xx) %>%
       dyOptions(useDataTimezone = TRUE) %>%
     dyAxis("y", valueRange = c(20, 80), label="HR [%]") %>%
     dyLimit(as.numeric(45), color = "red") %>%
     dyLimit(as.numeric(55), color = "red") %>%
     dyEvent(c("2017-05-12 07:30:00", "2017-05-12 23:59:00"), c("Inizio taratura", "Fine taratura"), labelLoc = "bottom") %>%
     dyEvent(c("2017-06-05 07:00:00"), c("Chiller ON"), labelLoc = "bottom")%>%
       dyEvent(c("2017-06-06 14:45:00"), c("Switched off due to heavy rain"), color="grey", labelLoc = "top", strokePattern="dashed") %>%
       dyEvent(c("2017-06-07 06:45:00"), c("Switched on after heavy rain"), labelLoc = "top", strokePattern="dashed", color="grey") %>%
       dyEvent(c("2017-06-28 09:00:00"), c("New door opened and not closed"), labelLoc = "top", strokePattern="dashed", color="grey")
 })

 output$ulab_graph <- renderDygraph({
   library(reshape)
   data <- datasetInput()
   data_T <- data[, !grepl( "_HR" , names( data ) )]
   data_HR <- data[, grepl( "time" , names( data ) ) | grepl( "A_HR" , names( data ) ) | grepl( "B_HR" , names( data ) ) | grepl( "C_HR" , names( data ) ) | grepl( "D_HR" , names( data ) )]  #!grepl( "_T" , names( data ) )
   xx <- xts(data_HR[,names(data_HR)!="time"],
       strptime(data_HR$time, format = "%Y-%m-%d %H:%M:%S"),
       tz = "UTC"
       )
   dygraph(xx) %>%
     dyOptions(useDataTimezone = TRUE) %>%
     dyAxis("y", valueRange = c(0, 100), label="HR [%]") %>%
     dyEvent(c("2017-05-12 07:30:00", "2017-05-12 23:59:00"), c("Inizio taratura", "Fine taratura"), labelLoc = "bottom") %>%
     dyEvent(c("2017-06-05 07:00:00"), c("Chiller ON"), labelLoc = "bottom")%>%
     dyEvent(c("2017-06-06 14:45:00"), c("Switched off due to heavy rain"), color="grey", labelLoc = "top", strokePattern="dashed") %>%
     dyEvent(c("2017-06-07 06:45:00"), c("Switched on after heavy rain"), labelLoc = "top", strokePattern="dashed", color="grey") %>%
     dyEvent(c("2017-06-28 09:00:00"), c("New door opened and not closed"), labelLoc = "top", strokePattern="dashed", color="grey")
 })
  
      
}

