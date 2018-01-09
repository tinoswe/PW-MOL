source("make_day_frame_2.R")

#home_dir_basename <- "/Users/olivo.martino/Code/RStudio/Projects/PW-MOB/"
home_dir_basename <- "./"
home_dir <- "Data_MOB"
#setwd(home_dir)

folder_data <- list.dirs(path=paste(home_dir_basename,
                                home_dir,
                                sep=""),
                     full.names = TRUE)

list_df <- list()
i <- 0

for (d in list.files(folder_data)){
  i <- i + 1
  #setwd(home_dir)
  #f <- list.files(d)
  #print(as.character(basename(d)))
  
  #df <- make_day_frame(as.character(basename(d)))

  df <- make_day_frame(home_dir_basename, 
                       home_dir, 
                       as.character(d))
  
  list_df[[i]] <- df
  }

df_all <- Reduce(function(x, y) merge(x, y, all=TRUE), list_df)
df_all <- df_all[,c(1,4,5,6,7,8,9,10,11,2,3)]

