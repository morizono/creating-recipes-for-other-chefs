#!/usr/bin/env Rscript

packages <- c("randomForest", "lubridate", "timeDate")
sapply(packages, require, character.only = TRUE)

modelDataFile <- file.path(dirname(Sys.getenv("R_SCRIPT")),"two_hour_call_need_rf_v2_b.RData")

IN_NEDOCS_MODEL_DATA <- read.csv(Sys.getenv("INPUT_DATA_FILE"))

# Subset to only necessary columns
OUT_NEDOCS_MODEL_DATA = IN_NEDOCS_MODEL_DATA[ , c('SCORE_ID', 'SCORE_DT_TM', 'SCORE', 'TOTAL_ED_PATS', 'ED_PODS', 'ED_BEDS', 'HOSP_BEDS','ADMIT_PATS', 'HIGH_ACUITY_PATS', 'LONGEST_ADMIT_LOS', 'LONGEST_WAIT')]

# Remove rownames, if any
rownames(OUT_NEDOCS_MODEL_DATA) = NULL

#### Obtain and prep most recent observation for prediction ####

# Add color indicator factor
OUT_NEDOCS_MODEL_DATA$SCORE_A_COLOR = ifelse(OUT_NEDOCS_MODEL_DATA$SCORE < 60, "Green", 
                                    ifelse(OUT_NEDOCS_MODEL_DATA$SCORE < 100, "Yellow", 
                                    ifelse(OUT_NEDOCS_MODEL_DATA$SCORE < 130, "Orange", "Red")))

OUT_NEDOCS_MODEL_DATA$SCORE_A_COLOR = ordered(OUT_NEDOCS_MODEL_DATA$SCORE_A_COLOR, 
                                    levels=c("Green", "Yellow", "Orange", "Red"))

# Convert score time stamp to POSIXct format
OUT_NEDOCS_MODEL_DATA$SCORE_DT_TM = as.POSIXct(OUT_NEDOCS_MODEL_DATA$SCORE_DT_TM)

# Date/Time factors
OUT_NEDOCS_MODEL_DATA$DayOfWeekNM = wday(OUT_NEDOCS_MODEL_DATA$SCORE_DT_TM, label = TRUE)
OUT_NEDOCS_MODEL_DATA$WEEK_NUM = week(OUT_NEDOCS_MODEL_DATA$SCORE_DT_TM)
OUT_NEDOCS_MODEL_DATA$TOD = ordered(hour(OUT_NEDOCS_MODEL_DATA$SCORE_DT_TM), levels = seq(0:23)-1)
OUT_NEDOCS_MODEL_DATA$MONTH_NM = month(OUT_NEDOCS_MODEL_DATA$SCORE_DT_TM, label = TRUE)
OUT_NEDOCS_MODEL_DATA$WEEKEND = factor(isWeekend(OUT_NEDOCS_MODEL_DATA$SCORE_DT_TM), 
                                levels = c("FALSE", "TRUE"))
OUT_NEDOCS_MODEL_DATA$Holiday = factor(isHoliday(timeDate(OUT_NEDOCS_MODEL_DATA$SCORE_DT_TM), 
                                holidays = holidayNYSE()), levels = c("FALSE", "TRUE"))
OUT_NEDOCS_MODEL_DATA$HolidayYesterday = factor(isHoliday(timeDate(
                                OUT_NEDOCS_MODEL_DATA$SCORE_DT_TM - 60 * 60 * 24), 
                                holidays = holidayNYSE()), levels = c("FALSE", "TRUE"))
OUT_NEDOCS_MODEL_DATA$HolidayTomorrow = factor(isHoliday(timeDate(
                                OUT_NEDOCS_MODEL_DATA$SCORE_DT_TM + 60 * 60 * 24), 
                                holidays = holidayNYSE()), levels = c("FALSE", "TRUE"))

# Remove identifier columns
OUT_NEDOCS_MODEL_DATA = OUT_NEDOCS_MODEL_DATA[ , -c(1:2)]

#### Make prediction ####

# Two-hour ahead predictions
OUT_NEDOCS_MODEL_DATA$PROBABILITY_COLOR_2_HOURS = predict(get(load(modelDataFile)), 
                                            newdata = OUT_NEDOCS_MODEL_DATA, type="p")[,2]

# Using 75% probability as threshold to maximize precision
OUT_NEDOCS_MODEL_DATA$PREDICTED_COLOR_2_HOURS = ifelse(
            OUT_NEDOCS_MODEL_DATA$PROBABILITY_COLOR_2_HOURS >= 0.75, "Orange/Red", "Green/Yellow")

# Add date/time and score ID back into the forecast results
OUT_NEDOCS_MODEL_DATA = cbind(SCORE_ID = IN_NEDOCS_MODEL_DATA$SCORE_ID, 
                            SCORE_DT_TM = IN_NEDOCS_MODEL_DATA$SCORE_DT_TM, 
                            OUT_NEDOCS_MODEL_DATA)

# Remove excess columns
OUT_NEDOCS_MODEL_DATA = OUT_NEDOCS_MODEL_DATA[ , -c(12:20)]
    
#### Save results to csv ####
write.csv(OUT_NEDOCS_MODEL_DATA, Sys.getenv("OUTPUT_DATA_FILE"), na="", row.names = FALSE)

