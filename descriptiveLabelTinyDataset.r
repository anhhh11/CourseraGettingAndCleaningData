descriptiveLabelTinyDataset <- function(filenamese){
  table  <- fread(filenamese)
  names <- names(table)
  names <- gsub("\\(\\)","",names)
  names <- gsub("^([a-z])([A-Z])","\\1-\\2",names)
  names <- strsplit(names,"[-]")
  names <- names[-(1:3)]
  changeListRow <- function(x,...){
    if (x[1][1]=="f") 
      x[1] <- gsub("f","in frequence domain",x[1])
    else 
      x[1] <- gsub("t","in time domain",x[1])
    x[3]  <- paste(x[3],"of")
    x[3] <- gsub("^(.)","\\U\\1",x[3],perl=TRUE)
    x[3] <- gsub("Freq"," frequence",x[3])
    x[3] <- gsub("Std","Standard deviation",x[3])
    
    x[2] <- gsub("Acc","'s acceleration",x[2])  
    x[2] <- gsub("Mag"," in magnitude",x[2])
    x[2] <- gsub("BodyBody","body",x[2])
    x[2] <- gsub("Body","body",x[2])
    x[2] <- gsub("Gyro","'s gyroscope to",x[2])
    x[2] <- gsub("Jerk"," Jerk signals",x[2])
    
    if(length(x)==4)
      x[4] <- gsub("([XYZ])","in \\1",x[4],perl=TRUE)
    x[c(1,2,3)] <- x[c(3,2,1)]
    x;
  }
  names_new <- sapply(names,FUN=changeListRow)
  names_new <- lapply(names_new,function(x){paste(x,collapse=" ")})
  names_new <- unlist(names_new)
  result <- list()
  result$orgin <- names(table)
  result$desriptiveNames <- c("Subject ID","Activity code","Activity namese",names_new)
  result <- data.frame(origin=result)
  names(result) <- c("Original name","Descriptive name")
  result
}