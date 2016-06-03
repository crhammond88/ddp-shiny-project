library(ggvis)
library(outliers)
library(markdown)

palette(c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3", "#FF7F00",
          "#FFFF33", "#A65628", "#F781BF", "#999999", "#16f4ef",
          "#15ff00", "#008080", "#3E003E", colors(distinct=TRUE)[321:501]))

kepler <- read.csv("cumulative.csv", skip=55)
info <- read.csv("cumulative.csv", nrows=49, skip=5, header=FALSE, stringsAsFactors=FALSE)
kepler <- kepler[!outlier(kepler[,11], logical=TRUE),] # Remove outlier for better visibility

varNames <- vector()
trim <- function (x) gsub("^\\s+|\\s+$", "", x) # Returns string w/o leading or trailing whitespace
for(row in 1:dim(info)[1]) {
  varNames[row] <- trim(data.frame(strsplit(info[row,], "[:]"))[2,])
}
names(kepler) <- varNames
names(mtcars) <- c('Miles/Gallon (US)', 'Cylinders', 'Displacement (cu.in.)', 'Horsepower', 
                         'Rear Axle Ratio', 'Weight (1000 lbs)', '1/4 Mile Time', 'Engine Type (V/S)', 'Transmission Type (A/M)', 
                         'Forward Gears', 'Carburetors')

rawData <- list(kepler, mtcars, USArrests, iris, quakes, swiss, women) # Add datasets here
datasets <- matrix(list(), nrow=length(rawData), ncol=4); dataNames <- 1;
datasets[,dataNames] <- c('Kepler Exoplanets', 'Motor Trend Car Road Tests', 'United States Arrests', 
                  'Edgar Anderson\'s Iris Data', 'Fiji Earthquakes', 'Swiss Fertility & Socioeconomic Indicators',
                  'Average Heights & Weights for American Women') # Add dataset name here
original <- 2; clean <- 3; doubles <- 4; startingDataset <- 1;

# Clean the data for proper function - Only variables of type double are used for final data
for(id in 1:length(rawData)) {
  datasets[[id,original]] <- rawData[[id]]
  noNAs <- colSums(is.na(datasets[[id,original]])) == 0 # Make a vector of the variables without NAs
  datasets[[id,clean]] <- datasets[[id,original]][,noNAs];
  nums <- sapply(datasets[[id,clean]], is.double) # Make a vector of type double variables 
  datasets[[id,doubles]] <- datasets[[id,clean]][,nums];
} # Intermediate datasets are retained for extensibility

rm(rawData, kepler, id, noNAs, nums, row, varNames, trim, info)

currentData <- datasets[[startingDataset, doubles]]