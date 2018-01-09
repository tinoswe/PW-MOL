make_day_frame <- function(home_path,
                           data_path,
                           fname){
  
  df <- read.csv(file=paste(home_path, 
                            data_path,
                            fname,
                            sep="/"),
                 sep=";",
                 skip=4,
                 strip.white=TRUE,
                 stringsAsFactors = FALSE,
                 header=FALSE)
  df$V1 <- strptime(df$V1,
                    format="%Y/%m/%d %H:%M:%S")
  colnames(df) <- c("time",
                    "cella_T",
                    "cella_HR",
                    "A_T",
                    "A_HR",
                    "B_T",
                    "B_HR",
                    "C_T",
                    "C_HR",
                    "D_T",
                    "D_HR")
  return(df)
  
}



