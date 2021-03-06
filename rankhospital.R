rankhospital <- function(state,outcome,num = "best") {
  
  outcome <- tolower(outcome)
  
  
  
  ## Read outcome data
  data <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
  
  ## Check that state and outcome are valid
  
  ## State
  stck <- sum(data$State == state)
  if (stck == 0) {
    # throw error: invalid state
    stop("invalid state")
  }
  ## Outcome 
  occk <- c("heart attack","heart failure","pneumonia")
  occka <- sum(occk == outcome)
  if (occka == 0) {
    # throw error : invalid outcome
    stop("invalid outcome")
  }
  
  collu <- data.frame(oc = occk,col = c(11,17,23))    
  
  occol <- collu[collu$oc == outcome, 2]
  
  ## Return hospital name in that state with lowest 30-day death
  
  # create evaludation data frame
  
  rankdf <- suppressWarnings(data.frame(hosp = as.character(data$Hospital.Name), st = as.character(data$State), met = as.numeric(data[,occol])))        
  
  rankdf$hosp <- as.character(rankdf$hosp) #removes hosp as factor
  
  rankdf <- rankdf[rankdf$st == state,] ## Subset State
  
  rankdfcl <- rankdf[!is.na(rankdf$met),] #Clean up NA values
    
  winsort <- rankdfcl[order(rankdfcl$met,rankdfcl$hosp),] ## return the sorted values
  
  if (num == "best") {
    inum <- 1
  } else if (num == "worst") {
    inum <- nrow(winsort)
  } else if (num > nrow(winsort)){
    return(NA)
  } else {
    inum <- num
  }
      
  winval <- winsort[inum,1]
  
  ##rate
  winval
}

