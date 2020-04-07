

library(reshape2)
library(Amelia)
library(ggplot2)
#install.packages('OneR',dependencies=TRUE)
library(OneR)
#install.packages('woeBinning',dependencies=TRUE)
library(woeBinning)
#install.packages('stargazer',dependencies=TRUE)
library(stargazer)

#########################################################
# Load Files.  
#Note: the data is in a .R format
#Note: the next few lines distinguish paths for laptop vs. workstation
#########################################################

#workstation
my_path = 'C:\\Users\\Jason\\OneDrive - QJA\\My Files\\NW Coursework\\Predict 498 Capstone\\Project_Data\\'

#laptop
my_path = 'D:\\OneDrive - QJA\\My Files\\NW Coursework\\Predict 498 Capstone\\Project_Data\\'

path_file = paste(my_path,'credit_card_default.RData',sep='')


#########################################################
#  set path where export images and files will be saved
#########################################################

ws_exp_path = 'C:\\Users\\Jason\\OneDrive - QJA\\My Files\\NW Coursework\\Predict 498 Capstone\\Project_Data\\exports\\'
lap_exp_path = 'D:\\OneDrive - QJA\\My Files\\NW Coursework\\Predict 498 Capstone\\Project_Data\\exports\\'

exp_path = lap_exp_path  #change this line depending on if using laptop or workstation


#########################################################
# Read the RData object using readRDS();
#########################################################

cc_data_raw <- readRDS(path_file)

head(cc_data_raw)
tail(cc_data_raw)
str(cc_data_raw)
dim(cc_data_raw)
names(cc_data_raw)
summary(cc_data_raw)
dimnames(cc_data_raw)

#create df with index to reference column numbers
col_index = function(ci) {
  col_names = as.data.frame(colnames(ci))
  return(col_names)
}
col_index(cc_data_raw)

#fix column header: Pay_0 shoudl be Pay_1
colnames(cc_data_raw)[colnames(cc_data_raw)=="PAY_0"] = "PAY_1"
colnames(cc_data_raw)

#basic missing values: total observations, missing count, %missing

missing_stats = function(m) {
  miss = data.frame(rbind(length(m),
                          sum(is.na(m)==TRUE),
                          sum(is.na(m)==TRUE) / length(m)),
                    row.names = c("Length", "Missing","%Missing"))
  colnames(miss)=colnames(m)
  return(miss)
}
round(t(data.frame(apply(cc_data_raw[,1:30], 2, missing_stats))),2)

#missing values graphically: missmap uses Amelia package

missmap(cc_data_raw[1:30], main="Missing Map", y.labels = NULL, 
        y.at=NULL, rank.order = TRUE)


#basic statistics
range = function(x) {max(x, na.rm = TRUE) - min(x, na.rm = TRUE)}
summ_stats = function(x) {
  stats = data.frame(rbind(range(x),
                           min(x, na.rm=TRUE),
                           quantile(x, probs = c(0.10), na.rm = TRUE),                           
                           #quantile(x, probs = c(0.25), na.rm = TRUE),
                           mean(x, na.rm = TRUE),
                           median(x, na.rm = TRUE),
                           #quantile(x, probs = c(0.75), na.rm = TRUE),
                           quantile(x, probs = c(0.90), na.rm = TRUE),
                           max(x, na.rm=TRUE),
                           sd(x, na.rm = TRUE),
                           var(x, na.rm = TRUE)),
                     row.names = c("Range", "Min", 
                                   "Q10", 
                                   #"Q25", 
                                   "Mean", 
                                   "Med", 
                                   #"Q75", 
                                   "Q90", 
                                   "Max", 
                                   "SD", "Var"))
  colnames(stats)=colnames(x)
  return(stats)
}

#don't need this line: see function below
#basic_stats = round(t(data.frame(apply(cc_data_raw[, 2:25], 2, summary_stats))),2)

summ_stats_tbl = function (x){
  round(t(data.frame(apply(x, 2, summ_stats))),2)
}

basic_stats = summ_stats_tbl(cc_data_raw[,2:25])


class(basic_stats)='matrix'  #set to matrix so stargazer prints as matrix instead of columns

stargazer(basic_stats, type=c('html'),out=paste(exp_path,'Basic_Stats.html',sep=''),
          title=c('Credit Card Default: Basic Statistics'),
          align=TRUE, digits=2, digits.extra=0, initial.zero=TRUE,
          summary=FALSE ) 

#to get range of single variable (specify data and variable as m)
range <- function(m) {max(m, na.rm = TRUE) - min(m, na.rm = TRUE)}
range(cc_data_raw$PAY_1)

write.csv(cc_data_raw, file.path(my_path, 
                                 'cc_data_original.csv'), 
                                  row.names = FALSE)


###########################################################################
#
#   Convert number variables to factors
#
###########################################################################

#identify columns to be factors
fact_cols = c(3:5, 25)

#create new object by duplicating the original raw data file
cc_data_fact = cc_data_raw
cc_data_fact[,fact_cols] = lapply(cc_data_fact[,fact_cols], factor)
str(cc_data_fact)



###########################################################################
#
#   Initial Feature Engineering
#
###########################################################################
col_index(cc_data_fact)

#Recategorize Sex field to change 1-male, 2-female to binary
cc_data_fact$SEX = 
  as.factor(ifelse(cc_data_fact$SEX == '1', '0', '1'))

#Group education variable to remove unknown coding (5 and 6 converted to 4)
#new: 0=>grad, 1=grad, 2=univ, 3=HS, 4=other
#have to change original column to character then back to factor
cc_data_fact$EDUCATION_2 = 
  as.factor(ifelse((cc_data_fact$EDUCATION == '5') | (cc_data_fact$EDUCATION == '6'), '4',
         as.character(cc_data_fact$EDUCATION)))


#Group marriage variable to remove uknown coding (0 converted to 3)
#new: 1=married, 2=single, 3=other

cc_data_fact$MARRIAGE_2 = 
  as.factor(ifelse(cc_data_fact$MARRIAGE == '0', '3', as.character(cc_data_fact$MARRIAGE)))

write.csv(cc_data_fact, file.path(my_path, 'cc_data_original2.csv'),
          row.names = FALSE)

#CREATE AVERAGE BILL AMOUNT
cc_data_fact$Avg_Bill_Amt = rowMeans(cc_data_fact[,13:18])
head(cc_data_fact)

#CREATE SLOPE FUNCTION
slope = function(x){
  if(all(is.na(x)))
    # if x is all missing, then lm will throw an error that we want to avoid
    return(NA)
  else
    return(coef(lm(x~I(1:6)))[2])
}

#CREATE SLOPE FOR BILL AMT
cc_data_fact$Slope_Bill_Amt = apply(cc_data_fact[,13:18], 1, slope)
head(cc_data_fact)

#CREATE AVERAGE PAYMENT AMOUNT
cc_data_fact$Avg_Pmt_Amt = rowMeans(cc_data_fact[,19:24])
head(cc_data_fact)

#CREATE SLOPE FOR PAYMENT AMOUNT
cc_data_fact$Slope_Pmt_Amt = apply(cc_data_fact[,19:24], 1, slope)
head(cc_data_fact)

#CREATE PAYMENT RATIO
#based on 1mo lag btwn balance and payment
#if there is no payment due, ratio of 1 is assigned
#will benifit those with no balance on card

cc_data_fact$Pmt_Ratio1 = ifelse(cc_data_fact[,14]==0,1,
                                 cc_data_fact[,19]/cc_data_fact[,14])
cc_data_fact$Pmt_Ratio2 = ifelse(cc_data_fact[,15]==0,1,
                                 cc_data_fact[,20]/cc_data_fact[,15])
cc_data_fact$Pmt_Ratio3 = ifelse(cc_data_fact[,16]==0,1,
                                 cc_data_fact[,21]/cc_data_fact[,16])
cc_data_fact$Pmt_Ratio4 = ifelse(cc_data_fact[,17]==0,1,
                                 cc_data_fact[,22]/cc_data_fact[,17])
cc_data_fact$Pmt_Ratio5 = ifelse(cc_data_fact[,18]==0,1,
                                 cc_data_fact[,23]/cc_data_fact[,18])
head(cc_data_fact)

write.csv(cc_data_fact, file.path(my_path, 'cc_data_original2.csv'), row.names = FALSE)

#CREATE AVERAGE PATMENT RATIO
cc_data_fact$Avg_Pmt_Ratio = rowMeans(cc_data_fact[,37:41])
head(cc_data_fact)


#CREATE SLOPE FOR PAYMENT RATIO
slope2 = function(x){
  if(all(is.na(x)))
    # if x is all missing, then lm will throw an error that we want to avoid
    return(NA)
  else
    return(coef(lm(x~I(1:5)))[2])
}

cc_data_fact$Slope_Pmt_Ratio = apply(cc_data_fact[,37:41], 1, slope2)
head(cc_data_fact)

#CREATE UTILIZATION
#current bal/credit limit

cc_data_fact$Util1 = cc_data_fact[,13]/cc_data_fact[,2]
cc_data_fact$Util2 = cc_data_fact[,14]/cc_data_fact[,2]
cc_data_fact$Util3 = cc_data_fact[,15]/cc_data_fact[,2]
cc_data_fact$Util4 = cc_data_fact[,16]/cc_data_fact[,2]
cc_data_fact$Util5 = cc_data_fact[,17]/cc_data_fact[,2]
cc_data_fact$Util6 = cc_data_fact[,18]/cc_data_fact[,2]
head(cc_data_fact)

write.csv(cc_data_fact, 
          file.path(my_path, 'cc_data_original2.csv'), row.names = FALSE)

#CREATE AVERAGE UTILIZATION
cc_data_fact$Avg_Util = rowMeans(cc_data_fact[,44:49])
head(cc_data_fact)

#CREATE SLOPE FOR UTILIZATION
cc_data_fact$Slope_Util = apply(cc_data_fact[,44:49], 1, slope)
head(cc_data_fact)

#CREATE BALANCE GROWTH OVER 6MO
#is balance growing due to partial payments
cc_data_fact$Bal_Growth_6mo = (cc_data_fact$BILL_AMT1 - 
                                cc_data_fact$BILL_AMT6)
head(cc_data_fact)

# #CREATE BALANCE GROWTH RATIO OVER 6MO (change over limit balance)
# cc_data_fact$Bal_Growth_Ratio_6mo = 
#   ((cc_data_fact$BILL_AMT1 - cc_data_fact$BILL_AMT6) / 
#      cc_data_fact$LIMIT_BAL)
# head(cc_data_fact)

#CREATE UTILIZATION GROWTH OVER 6MO
cc_data_fact$Util_Growth_6mo = 
  (cc_data_fact$Util1 - cc_data_fact$Util6)
head(cc_data_fact)

#CREATE MAX BILL AMOUNT
cc_data_fact$Max_Bill_Amt = apply(cc_data_fact[13:18],1, FUN=max)
head(cc_data_fact)

#CREATE MAX PAYMENT AMOUNT
cc_data_fact$Max_Pmt_Amt = apply(cc_data_fact[19:24],1, FUN=max)
head(cc_data_fact)

#CREATE MAX DELIQUENCY
cc_data_fact$Max_DLQ = apply(cc_data_fact[7:12],1, FUN=max)
cc_data_fact$Max_DLQ[cc_data_fact$Max_DLQ < 0] = 0
head(cc_data_fact)

#CREATE DELIQUENCY RATIO
cc_data_fact$DLQ_ratio = rowSums(cc_data_fact[7:12] > 0)/6
head(cc_data_fact)

#CREATE RATIO average PMT TO average BILL
cc_data_fact$avPmt_avBill_Ratio = ifelse(cc_data_fact$Avg_Bill_Amt ==0, 1,
                                    cc_data_fact$Avg_Pmt_Amt / 
                                    cc_data_fact$Avg_Bill_Amt)
head(cc_data_fact)

#CREATE RATIO Pmt slope TO Bill slope
cc_data_fact$slPmt_slBill_Ratio = ifelse(cc_data_fact$Slope_Bill_Amt == 0,1,
                                    cc_data_fact$Slope_Pmt_Amt / 
                                    cc_data_fact$Slope_Bill_Amt)
head(cc_data_fact)

write.csv(cc_data_fact, 
          file.path(my_path, 'cc_data_original2.csv'), row.names = FALSE)

#replace all NAs with zeros
#cc_data_fact[is.na(cc_data_fact)] = 0


#############################################################################
#Use oneR to assess variable predictability---------------------------------
#############################################################################

#specify columns
#set default column as a variable
dv = cc_data_fact$DEFAULT  #depdendent variable

col_index(cc_data_fact)


#specify columns
var_cols = c(2:25, 31:59)
data_idv = cc_data_fact[,var_cols]
head(data_idv)

#OneR uses OneR package
model_1 <- OneR(DEFAULT ~ ., data=data_idv, verbose=TRUE)
summary(model_1)

#manually iterate to see if dummy coding is complex
model_2 <- OneR(DEFAULT ~ Max_DLQ, data=data_idv, verbose=TRUE)
summary(model_2)
#highest is 79.5% accuracy based on Pay_2 variable


#############################################################################
#Review distribution for continuous variables

#############################################################################
data1 = cc_data_fact

#mar=c(0,0,2,0), 
par(mfrow=c(3,3))
qqnorm(data1$LIMIT_BAL, main='QQ-Plot: Credit Limit Balance')
qqline(data1$LIMIT_BAL)

qqnorm(data1$AGE, main='QQ-Plot: AGE')
qqline(data1$AGE)

qqnorm(data1$Avg_Bill_Amt, main='QQ-Plot: Avg_Bill_Amt')
qqline(data1$Avg_Bill_Amt)

qqnorm(data1$Avg_Bill_Amt, main='QQ-Plot: Slope_Bill_Amt')
qqline(data1$Slope_Bill_Amt)

qqnorm(data1$Avg_Pmt_Amt, main='QQ-Plot: Avg_Pmt_Amt')
qqline(data1$Avg_Pmt_Amt)

qqnorm(data1$Avg_Pmt_Amt, main='QQ-Plot: Slope_Pmt_Amt')
qqline(data1$Slope_Pmt_Amt)

qqnorm(data1$Avg_Pmt_Ratio, main='QQ-Plot: Avg_Pmt_Ratio')
qqline(data1$Avg_Pmt_Ratio)

qqnorm(data1$Avg_Pmt_Ratio, main='QQ-Plot: Slope_Pmt_Ratio')
qqline(data1$Slope_Pmt_Ratio)

qqnorm(data1$Avg_Util, main='QQ-Plot: Avg_Util')
qqline(data1$Avg_Util)

qqnorm(data1$Avg_Util, main='QQ-Plot: Slope_Util')
qqline(data1$Slope_Util)

qqnorm(data1$Bal_Growth_6mo, main='QQ-Plot: Bal_Growth_6mo')
qqline(data1$Bal_Growth_6mo)

qqnorm(data1$Util_Growth_6mo, main='QQ-Plot: Util_Growth_6mo')
qqline(data1$Util_Growth_6mo)

qqnorm(data1$Max_Bill_Amt, main='QQ-Plot: Max_Bill_Amt')
qqline(data1$Max_Bill_Amt)

qqnorm(data1$Max_Pmt_Amt, main='QQ-Plot: Max_Pmt_Amt')
qqline(data1$Max_Pmt_Amt)

qqnorm(data1$Max_Pmt_Amt, main='QQ-Plot: avPmt_avBill_Ratio')
qqline(data1$avPmt_avBill_Ratio)

par(mfrow=c(1,1))
#mar=c(0,0,0,0),

#############################################################################
#Binning for continuous variables

#############################################################################

#woe.binning uses woeBinning package

#BIN LIMIT BALANCE##########################
#woe binning
Lim_Bal_bin = woe.binning(df=cc_data_fact, 
                          target.var=c('DEFAULT'), pred.var=c('LIMIT_BAL'))
woe.binning.plot(Lim_Bal_bin)
woe.binning.table(Lim_Bal_bin) #shows weak relationships: IV = 0.02 to 1

#tree binning to see if gets higher WOE score
Lim_Bal_bin_tree = woe.tree.binning(df=cc_data_fact, target.var=c('DEFAULT'), 
                                    pred.var=c('LIMIT_BAL'))
woe.binning.plot(Lim_Bal_bin_tree)
woe.binning.table(Lim_Bal_bin_tree) #shows weak relationships: IV = 0.02 to 1

# Place the resulting bins on the existing data frame
# enter the best model in the line below to add to df
cc_data_fact <- woe.binning.deploy(df=cc_data_fact,binning=Lim_Bal_bin_tree)
head(cc_data_fact)
table(cc_data_fact$LIMIT_BAL.binned)

#BIN AGE VARIABLE##############################
#woe binning
age_bin = woe.binning(df=cc_data_fact, target.var=c('DEFAULT'), 
                      pred.var=c('AGE'))
woe.binning.plot(age_bin)
woe.binning.table(age_bin) #shows very weak relationships: IV < 0.02

#tree binning to see if gets higher WOE score
age_bin_tree = woe.tree.binning(df=cc_data_fact, target.var=c('DEFAULT'), 
                                pred.var=c('AGE'))
woe.binning.plot(age_bin_tree)
woe.binning.table(age_bin_tree) #shows very weak relationships: IV < 0.02

# Place the resulting bins on the existing data frame
# enter the best model in the line below to add to df
cc_data_fact <- woe.binning.deploy(df=cc_data_fact, binning=age_bin_tree)
head(cc_data_fact)
table(cc_data_fact$AGE.binned)

#BIN AVERAGE BILL VARIABLE##############################
#woe binning
av_Bill_bin = woe.binning(df=cc_data_fact, target.var=c('DEFAULT'), 
                      pred.var=c('Avg_Bill_Amt'))
woe.binning.plot(av_Bill_bin)
woe.binning.table(av_Bill_bin) #shows very weak relationships: IV < 0.02

#tree binning to see if gets higher WOE score
av_Bill_bin_tree = woe.tree.binning(df=cc_data_fact, 
                                target.var=c('DEFAULT'), 
                                pred.var=c('Avg_Bill_Amt'))
woe.binning.plot(av_Bill_bin_tree)
woe.binning.table(av_Bill_bin_tree) #shows very weak relationships: IV < 0.02

# Place the resulting bins on the existing data frame
# enter the best model in the line below to add to df
cc_data_fact <- woe.binning.deploy(df=cc_data_fact,
                                   binning=av_Bill_bin_tree)
head(cc_data_fact)
table(cc_data_fact$Avg_Bill_Amt.binned)

#BIN SLOPE BILL VARIABLE##############################
#woe binning
Slope_Bill_bin = woe.binning(df=cc_data_fact, target.var=c('DEFAULT'), 
                          pred.var=c('Slope_Bill_Amt'))
woe.binning.plot(Slope_Bill_bin)
woe.binning.table(Slope_Bill_bin) #shows very weak relationships: IV < 0.02

#tree binning to see if gets higher WOE score
Slope_Bill_bin_tree = woe.tree.binning(df=cc_data_fact, 
                                    target.var=c('DEFAULT'), 
                                    pred.var=c('Slope_Bill_Amt'))
woe.binning.plot(Slope_Bill_bin_tree)
woe.binning.table(Slope_Bill_bin_tree) #shows very weak relationships: IV < 0.02

# Place the resulting bins on the existing data frame
# enter the best model in the line below to add to df
cc_data_fact <- woe.binning.deploy(df=cc_data_fact,
                                   binning=Slope_Bill_bin)
head(cc_data_fact)
table(cc_data_fact$Slope_Bill_Amt.binned)

#BIN AVERAGE PAYMENT VARIABLE##############################
#woe binning
av_Pmt_bin = woe.binning(df=cc_data_fact, target.var=c('DEFAULT'), 
                          pred.var=c('Avg_Pmt_Amt'))
woe.binning.plot(av_Pmt_bin)
woe.binning.table(av_Pmt_bin) #shows very weak relationships: IV < 0.02

#tree binning to see if gets higher WOE score
av_Pmt_bin_tree = woe.tree.binning(df=cc_data_fact, 
                                    target.var=c('DEFAULT'), 
                                    pred.var=c('Avg_Pmt_Amt'))
woe.binning.plot(av_Pmt_bin_tree)
woe.binning.table(av_Pmt_bin_tree) #shows very weak relationships: IV < 0.02

# Place the resulting bins on the existing data frame
# enter the best model in the line below to add to df
cc_data_fact <- woe.binning.deploy(df=cc_data_fact,
                                   binning=av_Pmt_bin_tree)
head(cc_data_fact)
table(cc_data_fact$Avg_Bill_Amt.binned)

#BIN SLOPE PAYMENT VARIABLE##############################
#woe binning
Slope_Pmt_bin = woe.binning(df=cc_data_fact, target.var=c('DEFAULT'), 
                         pred.var=c('Slope_Pmt_Amt'))
woe.binning.plot(Slope_Pmt_bin)
woe.binning.table(Slope_Pmt_bin) #shows very weak relationships: IV < 0.02

#tree binning to see if gets higher WOE score
Slope_Pmt_bin_tree = woe.tree.binning(df=cc_data_fact, 
                                   target.var=c('DEFAULT'), 
                                   pred.var=c('Slope_Pmt_Amt'))
woe.binning.plot(Slope_Pmt_bin_tree)
woe.binning.table(Slope_Pmt_bin_tree) #shows very weak relationships: IV < 0.02

# Place the resulting bins on the existing data frame
# enter the best model in the line below to add to df
cc_data_fact <- woe.binning.deploy(df=cc_data_fact,
                                   binning=Slope_Pmt_bin_tree)
head(cc_data_fact)
table(cc_data_fact$Slope_Pmt_Amt.binned)

#BIN AVERAGE PAYMENT RATIO VARIABLE##############################
#woe binning
av_Pmt_Ratio_bin = woe.binning(df=cc_data_fact, target.var=c('DEFAULT'), 
                         pred.var=c('Avg_Pmt_Ratio'))
woe.binning.plot(av_Pmt_Ratio_bin)
woe.binning.table(av_Pmt_Ratio_bin) #shows very weak to weak relationship

#tree binning to see if gets higher WOE score
av_Pmt_Ratio_bin_tree = woe.tree.binning(df=cc_data_fact, 
                                   target.var=c('DEFAULT'), 
                                   pred.var=c('Avg_Pmt_Ratio'))
woe.binning.plot(av_Pmt_Ratio_bin_tree)
woe.binning.table(av_Pmt_Ratio_bin_tree) #shows very weak to weak relationship

# Place the resulting bins on the existing data frame
# enter the best model in the line below to add to df
cc_data_fact <- woe.binning.deploy(df=cc_data_fact,
                                   binning=av_Pmt_Ratio_bin)
head(cc_data_fact)
table(cc_data_fact$Avg_Pmt_Ratio.binned)

#BIN SLOPE PAYMENT RATIO VARIABLE##############################
#woe binning
Slope_Pmt_Ratio_bin = woe.binning(df=cc_data_fact, target.var=c('DEFAULT'), 
                               pred.var=c('Slope_Pmt_Ratio'))
woe.binning.plot(Slope_Pmt_Ratio_bin)
woe.binning.table(Slope_Pmt_Ratio_bin) #shows very weak to weak relationship

#tree binning to see if gets higher WOE score
Slope_Pmt_Ratio_bin_tree = woe.tree.binning(df=cc_data_fact, 
                                         target.var=c('DEFAULT'), 
                                         pred.var=c('Slope_Pmt_Ratio'))
woe.binning.plot(Slope_Pmt_Ratio_bin_tree)
woe.binning.table(Slope_Pmt_Ratio_bin_tree) #shows very weak to weak relationship

# Place the resulting bins on the existing data frame
# enter the best model in the line below to add to df
cc_data_fact <- woe.binning.deploy(df=cc_data_fact,
                                   binning=Slope_Pmt_Ratio_bin_tree)
head(cc_data_fact)
table(cc_data_fact$Avg_Pmt_Ratio.binned)

#BIN AVERAGE UTILIZATION VARIABLE##############################
#woe binning
av_Util_bin = woe.binning(df=cc_data_fact, target.var=c('DEFAULT'), 
                               pred.var=c('Avg_Util'))
woe.binning.plot(av_Util_bin)
woe.binning.table(av_Util_bin) #shows very weak to weak relationship

#tree binning to see if gets higher WOE score
av_Util_bin_tree = woe.tree.binning(df=cc_data_fact, 
                                         target.var=c('DEFAULT'), 
                                         pred.var=c('Avg_Util'))
woe.binning.plot(av_Util_bin_tree)
woe.binning.table(av_Util_bin_tree) #shows very weak to weak relationship

# Place the resulting bins on the existing data frame
# enter the best model in the line below to add to df
cc_data_fact <- woe.binning.deploy(df=cc_data_fact,
                                   binning=av_Util_bin_tree)

head(cc_data_fact)
table(cc_data_fact$Avg_Util.binned)

#BIN SLOPE UTILIZATION VARIABLE##############################
#woe binning
Slope_Util_bin = woe.binning(df=cc_data_fact, target.var=c('DEFAULT'), 
                          pred.var=c('Slope_Util'))
woe.binning.plot(Slope_Util_bin)
woe.binning.table(Slope_Util_bin) #shows very weak to weak relationship

#tree binning to see if gets higher WOE score
Slope_Util_bin_tree = woe.tree.binning(df=cc_data_fact, 
                                    target.var=c('DEFAULT'), 
                                    pred.var=c('Slope_Util'))
woe.binning.plot(Slope_Util_bin_tree)
woe.binning.table(Slope_Util_bin_tree) #shows very weak to weak relationship

# Place the resulting bins on the existing data frame
# enter the best model in the line below to add to df
cc_data_fact <- woe.binning.deploy(df=cc_data_fact,
                                   binning=Slope_Util_bin_tree)

head(cc_data_fact)
table(cc_data_fact$Avg_Util.binned)

#BIN BALANCE GROWTH 6MO VARIABLE##############################
#woe binning
Bal_Gr6_bin = woe.binning(df=cc_data_fact, target.var=c('DEFAULT'), 
                          pred.var=c('Bal_Growth_6mo'))
woe.binning.plot(Bal_Gr6_bin)
woe.binning.table(Bal_Gr6_bin) #shows very weak to weak relationship

#tree binning to see if gets higher WOE score
Bal_Gr6_bin_tree = woe.tree.binning(df=cc_data_fact, 
                                    target.var=c('DEFAULT'), 
                                    pred.var=c('Bal_Growth_6mo'))
woe.binning.plot(Bal_Gr6_bin_tree)
woe.binning.table(Bal_Gr6_bin_tree) #shows very weak to weak relationship

# Place the resulting bins on the existing data frame
# enter the best model in the line below to add to df
cc_data_fact <- woe.binning.deploy(df=cc_data_fact,
                                   binning=Bal_Gr6_bin)

head(cc_data_fact)
table(cc_data_fact$Bal_Growth_6mo.binned)


#BIN BALANCE GROWTH 6MO RATIO VARIABLE##############################
#woe binning
# Bal_Gr6_Rat_bin = woe.binning(df=cc_data_fact, target.var=c('DEFAULT'), 
#                           pred.var=c('Bal_Growth_Ratio_6mo'))
# woe.binning.plot(Bal_Gr6_Rat_bin)
# woe.binning.table(Bal_Gr6_Rat_bin) #shows very weak to weak relationship
# 
# #tree binning to see if gets higher WOE score
# Bal_Gr6_Rat_bin_tree = woe.tree.binning(df=cc_data_fact, 
#                                     target.var=c('DEFAULT'), 
#                                     pred.var=c('Bal_Growth_Ratio_6mo'))
# woe.binning.plot(Bal_Gr6_Rat_bin_tree)
# woe.binning.table(Bal_Gr6_Rat_bin_tree) #shows very weak to weak relationship
# 
# # Place the resulting bins on the existing data frame
# # enter the best model in the line below to add to df
# cc_data_fact <- woe.binning.deploy(df=cc_data_fact,
#                                    binning=Bal_Gr6_Rat_bin_tree)
# 
# head(cc_data_fact)
# table(cc_data_fact$Bal_Growth_Ratio_6mo.binned)

#BIN UTILIZATION GROWTH 6MO VARIABLE##############################
#woe binning
Util_Growth6_bin = woe.binning(df=cc_data_fact, target.var=c('DEFAULT'), 
                              pred.var=c('Util_Growth_6mo'))
woe.binning.plot(Util_Growth6_bin)
woe.binning.table(Util_Growth6_bin) #shows very weak to weak relationship

#tree binning to see if gets higher WOE score
Util_Growth6_bin_tree = woe.tree.binning(df=cc_data_fact, 
                                        target.var=c('DEFAULT'), 
                                        pred.var=c('Util_Growth_6mo'))
woe.binning.plot(Util_Growth6_bin_tree)
woe.binning.table(Util_Growth6_bin_tree) #shows very weak to weak relationship

# Place the resulting bins on the existing data frame
# enter the best model in the line below to add to df
cc_data_fact <- woe.binning.deploy(df=cc_data_fact,
                                   binning=Util_Growth6_bin_tree)

head(cc_data_fact)
table(cc_data_fact$Util_Growth_6mo.binned)

#BIN MAX BILL AMNT VARIABLE##############################
#woe binning
Max_Bill_bin = woe.binning(df=cc_data_fact, target.var=c('DEFAULT'), 
                               pred.var=c('Max_Bill_Amt'))
woe.binning.plot(Max_Bill_bin)
woe.binning.table(Max_Bill_bin) #shows very weak to weak relationship

#tree binning to see if gets higher WOE score
Max_Bill_bin_tree = woe.tree.binning(df=cc_data_fact, 
                                         target.var=c('DEFAULT'), 
                                         pred.var=c('Max_Bill_Amt'))
woe.binning.plot(Max_Bill_bin_tree)
woe.binning.table(Max_Bill_bin_tree) #shows very weak to weak relationship

# Place the resulting bins on the existing data frame
# enter the best model in the line below to add to df
cc_data_fact <- woe.binning.deploy(df=cc_data_fact,
                                   binning=Max_Bill_bin_tree)

head(cc_data_fact)
table(cc_data_fact$Max_Bill_Amt.binned)

#BIN MAX PMT AMNT VARIABLE##############################
#woe binning
Max_Pmt_bin = woe.binning(df=cc_data_fact, target.var=c('DEFAULT'), 
                           pred.var=c('Max_Pmt_Amt'))
woe.binning.plot(Max_Pmt_bin)
woe.binning.table(Max_Pmt_bin) #shows very weak to weak relationship

#tree binning to see if gets higher WOE score
Max_Pmt_bin_tree = woe.tree.binning(df=cc_data_fact, 
                                     target.var=c('DEFAULT'), 
                                     pred.var=c('Max_Pmt_Amt'))
woe.binning.plot(Max_Pmt_bin_tree)
woe.binning.table(Max_Pmt_bin_tree) #shows very weak to weak relationship

# Place the resulting bins on the existing data frame
# enter the best model in the line below to add to df
cc_data_fact <- woe.binning.deploy(df=cc_data_fact,
                                   binning=Max_Pmt_bin)

head(cc_data_fact)
table(cc_data_fact$Max_Pmt_Amt.binned)

#BIN DLQ RATIO VARIABLE##############################
#woe binning
DLQ_Ratio_bin = woe.binning(df=cc_data_fact, target.var=c('DEFAULT'), 
                          pred.var=c('DLQ_ratio'))
woe.binning.plot(DLQ_Ratio_bin)
woe.binning.table(DLQ_Ratio_bin) #shows very weak to weak relationship

#tree binning to see if gets higher WOE score
DLQ_Ratio_bin_tree = woe.tree.binning(df=cc_data_fact, 
                                    target.var=c('DEFAULT'), 
                                    pred.var=c('DLQ_ratio'))
woe.binning.plot(DLQ_Ratio_bin_tree)
woe.binning.table(DLQ_Ratio_bin_tree) #shows very weak to weak relationship

# Place the resulting bins on the existing data frame
# enter the best model in the line below to add to df
cc_data_fact <- woe.binning.deploy(df=cc_data_fact,
                                   binning=DLQ_Ratio_bin)

head(cc_data_fact)
table(cc_data_fact$DLQ_ratio.binned)

#BIN avPmt_avBill_Ratio VARIABLE##############################
#woe binning
avPmt_avBill_Ratio_bin = woe.binning(df=cc_data_fact, target.var=c('DEFAULT'), 
                            pred.var=c('avPmt_avBill_Ratio'))
woe.binning.plot(avPmt_avBill_Ratio_bin)
woe.binning.table(avPmt_avBill_Ratio_bin) #shows very weak to weak relationship

#tree binning to see if gets higher WOE score
avPmt_avBill_Ratio_bin_tree = woe.tree.binning(df=cc_data_fact, 
                                      target.var=c('DEFAULT'), 
                                      pred.var=c('avPmt_avBill_Ratio'))
woe.binning.plot(avPmt_avBill_Ratio_bin_tree)
woe.binning.table(avPmt_avBill_Ratio_bin_tree) #shows very weak to weak relationship

# Place the resulting bins on the existing data frame
# enter the best model in the line below to add to df
cc_data_fact <- woe.binning.deploy(df=cc_data_fact,
                                   binning=avPmt_avBill_Ratio_bin)

head(cc_data_fact)
table(cc_data_fact$avPmt_avBill_Ratio.binned)

#BIN avPmt_avBill_Ratio VARIABLE##############################
#woe binning
slPmt_slBill_Ratio_bin = woe.binning(df=cc_data_fact, target.var=c('DEFAULT'), 
                                     pred.var=c('slPmt_slBill_Ratio'))
woe.binning.plot(slPmt_slBill_Ratio_bin)
woe.binning.table(slPmt_slBill_Ratio_bin) #shows very weak to weak relationship

#tree binning to see if gets higher WOE score
slPmt_slBill_Ratio_bin_tree = woe.tree.binning(df=cc_data_fact, 
                                               target.var=c('DEFAULT'), 
                                               pred.var=c('slPmt_slBill_Ratio'))
woe.binning.plot(slPmt_slBill_Ratio_bin_tree)
woe.binning.table(slPmt_slBill_Ratio_bin_tree) #shows very weak to weak relationship

# Place the resulting bins on the existing data frame
# enter the best model in the line below to add to df
cc_data_fact <- woe.binning.deploy(df=cc_data_fact,
                                   binning=slPmt_slBill_Ratio_bin_tree)

head(cc_data_fact)
table(cc_data_fact$slPmt_slBill_Ratio.binned)

write.csv(cc_data_fact, 
          file.path(my_path, 'cc_data_original2.csv'), row.names = FALSE)
################################################################################
#Create Dummary Variables

dummy = cc_data_fact
bind = cc_data_fact

# Education
d2 = model.matrix(~dummy$EDUCATION+0)
colnames(d2)= c('dED_Adv_Gra', 'dED_Grad', 'dED_University', 
                'dED_HS', 'dED_Other1', 'dED_Other2', 'dED_Other3')
head(d2)

# Education_2
d3= model.matrix(~cc_data_fact$EDUCATION_2+0)
colnames(d3)= c('dED2_Adv_Gra', 'dED2_Grad', 'dED2_University', 
                'dED2_HS', 'dED2Other')
head(d3)

# Marriage
d4 = model.matrix(~dummy$MARRIAGE+0)
colnames(d4)= c('dMAR_Unk', 'dMAR_Married', 'dMAR_Single', 
                'dMAR_Other')
head(d4)

# Marriage_2
d5 = model.matrix(~dummy$MARRIAGE_2+0)
colnames(d5)= c('dMAR2_Married', 'dMAR2_Single', 'dMAR2_Other')
head(d5)

# LIMIT_BAL
d1 = model.matrix(~dummy$LIMIT_BAL.binned+0)
colnames(d1)[1:3]= c('dLIM_BALnegINF_30000', 'dLIM_BAL_30000_140000', 
                'dLIM_BALnegINF_140000_INF')
head(d1)

# AGE.binned
d6 = model.matrix(~dummy$AGE.binned+0)
colnames(d6)[1:4] = c('dAGE_0_25', 'dAGE_25_35', 'dAGE_35_45', 'dAGE_45_INF')
head(d6)

# Avg_Bill_Amt.binned
d7 = model.matrix(~dummy$Avg_Bill_Amt.binned+0)
colnames(d7)[1:5] = c('dAv_Bill_Amt_negINF_0', 'dAv_Bill_Amt_0_1159', 
                      'dAv_Bill_Amt_1159_7878', 'dAv_Bill_Amt_7878_49419',
                      'dAV_Bill_Amt_49419_INF')
head(d7)

# Slope_Bill_Amt.binned
d20 = model.matrix(~dummy$Slope_Bill_Amt.binned+0)
colnames(d20)[1:4] = c('dSlope_Bill_Amt_negINF_neg43.9', 'dSlope_Bill_Amt_neg43.9_1286', 
                      'dslope_Bill_Amt_1286_4459', 'dSlope_Bill_Amt_4459_INF')
head(d20)

# Avg_Pmt_Amt.binned
d8 = model.matrix(~dummy$Avg_Pmt_Amt.binned+0)
colnames(d8)[1:3] = c('dAV_Pmt_Amt_negINF_2475', 'dAV_Pmt_Amt_2475_12935',
                      'dAV_Pmt_Amt_12935_INF')
head(d8)

# Slope_Pmt_Amt.binned
d21 = model.matrix(~dummy$Slope_Pmt_Amt.binned+0)
colnames(d21)[1:4] = c('dslope_Pmt_Amt_negINF_neg649', 'dslope_Pmt_Amt_neg649_neg125',
                      'dslope_Pmt_Amt_neg125_1098', 'dslope_Pmt_Amt_1098_INF')
head(d21)

# Avg_Pmt_Ratio.binned
d9 = model.matrix(~dummy$Avg_Pmt_Ratio.binned+0)
colnames(d9)[1:4] = c('dAV_Pmt_Rat_negINF_0.034', 'dAV_Pmt_Rat_0.034_0.103',
                      'dAV_Pmt_Rat_0.103_1', 'dAV_Pmt_Rat_1_INF')
head(d9)

# Slope_Pmt_Ratio.binned
d22 = model.matrix(~dummy$Slope_Pmt_Ratio.binned+0)
colnames(d22)[1:7] = c('dslope_Pmt_Rat_negINF_neg0.076', 'dslope_Pmt_Rat_neg0.076_neg0.0038',
                      'dslope_Pmt_Rat_neg0.0038_neg3.3', 'dslope_Pmt_Rat_neg3.3_0',
                      'dslope_Pmt_Rat_0_0.001', 'dslope_Pmt_Rat_0.001_0.026', 
                      'dslope_Pmt_Rat_0.026_INF')
head(d22)

# Avg_Util.binned
d10 = model.matrix(~dummy$Avg_Util.binned+0)
colnames(d10)[1:3] = c('dAV_Util_negINF_0', 'dAV_Util_0_0.515',
                       'dAV_Util_0.515_INF')
head(d10)

# Slope_Util.binned
d23 = model.matrix(~dummy$Slope_Util.binned+0)
colnames(d23)[1:6] = c('dslope_Util_negINF_neg0.086', 'dslope_Util_neg0.086_neg0.0002',
                       'dslope_Util_neg0.0002_0', 'dslope_Util_0_0.008',
                       'dslope_Util_0.008_0.079', 'dslope_Util_0.079_INF')
head(d23)

# Bal_Growth_6mo.binned
d11 = model.matrix(~dummy$Bal_Growth_6mo.binned+0)
colnames(d11)[1:4] = c('dBal_Gr_6mo_negINF_neg21881', 'dBal_Gr_6mo_neg21881_neg10172',
                       'dBal_Gr_6mo_neg10172_923', 'dBal_Gr_6mo_923_INF')
head(d11)

# Util_Growth_6mo.binned
d12 = model.matrix(~dummy$Util_Growth_6mo.binned+0)
colnames(d12)[1:5] = c('dUTIL_Gr_6mo_negINF_neg0.0404', 'dUTIL_Gr_neg0.0404_neg7.3e-06',
                       'dUTIL_Gr_6mo_neg7.3e-06_0', 'dUTIL_Gr_6mo_0_0.591',
                       'dUTIL_Gr_6mo_0.591_INF')
head(d12)

# Max_Bill_Amt.binned
d13 = model.matrix(~dummy$Max_Bill_Amt.binned+0)
colnames(d13)[1:4] = c('dMAX_Bill_Amt_negINF_0', 'dMAX_Bill_Amt_0_3058',
                       'dMAX_Bill_Amt_3058_52496', 'dMAX_Bill_Amt_52496_INF')
head(d13)

# Max_Pmt_Amt.binned
d14 = model.matrix(~dummy$DLQ_ratio.binned+0)
colnames(d14)[1:3] = c('dMAX_Pmt_Amt_negINF_0', 'dMAX_Pmt_Amt_0_0.3',
                       'dMAX_Pmt_Amt_0.3_INF')

head(d14)

# DLQ_ratio.binned
d15 = model.matrix(~dummy$Max_Pmt_Amt.binned+0)
colnames(d15)[1:4] = c('dDLQ_Ratio_negINF_168', 'dDLQ_Ratio_168_5000',
                       'dDLQ_Ratio_5000_36621', 'dDLQ_Ratio_36621_INF')

head(d15)

# avPmt_avBill_Ratio.binned
d16 = model.matrix(~dummy$avPmt_avBill_Ratio.binned+0)
colnames(d16)[1:5] = c('davPmt_avBill_Ratio_negINF_0.03', 'davPmt_avBill_Ratio_0.03_0.15',
                       'davPmt_avBill_Ratio_0.15_0.99', 'davPmt_avBill_Ratio_0.99_1',
                       'davPmt_avBill_Ratio_1_INF')

head(d16)

# avPmt_avBill_Ratio.binned
d17 = model.matrix(~dummy$slPmt_slBill_Ratio.binned+0)
colnames(d17)[1:5] = c('dslPmt_slBill_Ratio_negINF_neg0.62', 'dslPmt_slBill_Ratio_neg0.62_0.009',
                       'dslPmt_slBill_Ratio_0.009_0.96', 'dslPmt_slBill_Ratio_0.96_1',
                       'dslPmt_slBill_Ratio_negINF_1_INF')

head(d17)

#bind all dummy vars together (start at column 3 because
#of index and intercept columns.  Dummy vars obtained with
#Woebinning have a "missing" column so leave that off)

bind_dummy = cbind(d2[,1:ncol(d2)], d3[,1:ncol(d3)], 
                   d4[,1:ncol(d4)], d5[,1:ncol(d5)],  
                   d6[,1:ncol(d6)-1], d1[,1:ncol(d1)-1],
                   d7[,1:ncol(d7)-1], d20[,1:ncol(d20)-1],
                   d8[,1:ncol(d8)-1], d21[,1:ncol(d21)-1],
                   d9[,1:ncol(d9)-1], d22[,1:ncol(d22)-1],
                   d10[,1:ncol(d10)-1], d23[,1:ncol(d23)-1],
                   d11[,1:ncol(d11)-1], d12[,1:ncol(d12)-1], d13[,1:ncol(d13)-1], 
                   d14[,1:ncol(d14)-1], d15[,1:ncol(d15)-1], d16[,1:ncol(d16)-1],
                   d17[,1:ncol(d17)-1])


head(bind_dummy)
dim(bind_dummy)
col_index(bind_dummy)
cc_data_engineered = cbind(cc_data_fact, bind_dummy)
head(cc_data_engineered)
write.csv(cc_data_engineered, 
          file.path(my_path, 'cc_data_engineered.csv'), row.names = FALSE)


####################################################################################
#
#   EDA
#
####################################################################################

cc_data_model_1 <- read.csv(file.path(my_path, 'cc_data_model.csv'), header = TRUE)

head(cc_data_model_1)
col_index(cc_data_model_1)


#create an object that will be used for exploratory analysis but can be changed
data1 = cc_data_model_1

dv = data1$DEFAULT  #depdendent variable
idv1 = data1$LIMIT_BAL


#specify categorical labels
sex_cats = c('male', 'female')
ed_cats = c('Phd','Grad', 'University', 'HS', 'Other', 'Unk', 'Unk2')
ed2_cats = c('Phd', 'Grad', 'University', 'HS', 'Other')
marr_cats = c('Divorced', 'Married', 'Single', 'Others')
marr2_cats = c('Married', 'Single', 'Other')
def_cats = c('No', 'Yes')



#####################################################################
# DEFAULT variable analysis
#####################################################################

#######################
#dv vs categorical idvs

#proportion table default vs. sex
table(data1$SEX)
prop.table(table(dv, data1$SEX))
def_sex_tbl = addmargins(prop.table(table(dv, data1$SEX)))
rownames(def_sex_tbl)=c(def_cats, 'Sum')
colnames(def_sex_tbl)=c(sex_cats, 'Sum')
class(def_sex_tbl)='matrix'  #set to matrix so stargazer prints as matrix instead of columns

#to print in console, change type to 'text'
#to save to html for pasting into document, change type to 'html'  (use <br> to break lines)
stargazer(def_sex_tbl, type=c('html'),out=paste(exp_path,'Def_sex_tbl.html',sep=''),
          title=c('Proportion Tbl:Default vs Sex'),
          align=TRUE, digits=2, digits.extra=2, initial.zero=TRUE,
          summary=FALSE )  

##proportion table default vs. education
table(data1$EDUCATION)
prop.table(table(dv, data1$EDUCATION))
def_ed_tbl = addmargins(prop.table(table(dv, data1$EDUCATION)))
rownames(def_ed_tbl)=c(def_cats, 'Sum')
colnames(def_ed_tbl)=c(ed_cats, 'Sum')
class(def_ed_tbl)='matrix'  #set to matrix so stargazer prints as matrix instead of columns

stargazer(def_ed_tbl, type=c('html'),out=paste(exp_path,'Def_ed_tbl.html',sep=''),
          title=c('Proportion Tbl:Default vs Education'),
          align=TRUE, digits=2, digits.extra=2, initial.zero=TRUE,
          summary=FALSE ) 

## proportion table default vs. education2
table(data1$EDUCATION_2)
prop.table(table(dv, data1$EDUCATION_2))
def_ed_tbl = addmargins(prop.table(table(dv, data1$EDUCATION_2)))
rownames(def_ed_tbl)=c(def_cats, 'Sum')
colnames(def_ed_tbl)=c(ed2_cats, 'Sum')
class(def_ed_tbl)='matrix'  #set to matrix so stargazer prints as matrix instead of columns

stargazer(def_ed_tbl, type=c('html'),out=paste(exp_path,'Def_ed2_tbl.html',sep=''),
          title=c('Proportion Tbl:Default vs Education_2'),
          align=TRUE, digits=2, digits.extra=2, initial.zero=TRUE,
          summary=FALSE ) 


#proportion table default vs. marriage
table(data1$MARRIAGE)
prop.table(table(dv, data1$MARRIAGE))
def_mar_tbl = addmargins(prop.table(table(dv, data1$MARRIAGE)))
rownames(def_mar_tbl)=c(def_cats, 'Sum')
colnames(def_mar_tbl)=c(marr_cats, 'Sum')
class(def_mar_tbl)='matrix'  #set to matrix so stargazer prints as matrix instead of columns

stargazer(def_mar_tbl, type=c('text'),out=paste(exp_path,'Def_mar_tbl.html',sep=''),
          title=c('Proportion Tbl:Default vs Marriage'),
          align=TRUE, digits=2, digits.extra=2, initial.zero=TRUE,
          summary=FALSE ) 

table(data1$MARRIAGE_2)
prop.table(table(dv, data1$MARRIAGE_2))
def_mar_tbl = addmargins(prop.table(table(dv, data1$MARRIAGE_2)))
rownames(def_mar_tbl)=c(def_cats, 'Sum')
colnames(def_mar_tbl)=c(marr2_cats, 'Sum')
class(def_mar_tbl)='matrix'  #set to matrix so stargazer prints as matrix instead of columns

stargazer(def_mar_tbl, type=c('html'),out=paste(exp_path,'Def_mar2_tbl.html',sep=''),
          title=c('Proportion Tbl:Default vs Marriage_2'),
          align=TRUE, digits=2, digits.extra=2, initial.zero=TRUE,
          summary=FALSE ) 
#########################################
# dv vs continous idvs with by categories

par(mfrow=c(2,2))
#boxplot: Limit_Bal by default
ggplot(data1, aes(fill=factor(DEFAULT), y=idv1)) +
  geom_boxplot(outlier.color='red', outlier.shape=1, 
               outlier.size=3, notch = FALSE)+
  ggtitle('BoxPlot: Credit Limit Balance by Default')+
  ylab("Limit_Bal")

#density plot credit limit by default
ggplot(data1, aes_string(x = idv1, fill=factor(dv, labels = def_cats))) + 
  geom_density(alpha = .5) +
  ggtitle('Denisty Plot: Credit Limit Balance by Default')
par(mfrow=c(1,1))

#boxplot: Limit_Bal by default and education
ggplot(data1, aes(x=DEFAULT, y=idv1, fill=factor(EDUCATION, labels=ed_cats))) +
  geom_boxplot(outlier.color='red', outlier.shape=1, 
               outlier.size=3, notch = FALSE)+
  ggtitle('BoxPlot: Credit Limit Balance by Default and Education')+
  ylab("Limit_Bal")


#boxplot: Limit_Bal by default and education re-coded
ggplot(data1, aes(x=DEFAULT, y=idv1, fill=factor(EDUCATION_2, labels=ed2_cats))) +
  geom_boxplot(outlier.color='red', outlier.shape=1, 
               outlier.size=3, notch = FALSE)+
  ggtitle('BoxPlot: Credit Limit Balance by Default and Education (re-coded)')+
  ylab("Limit_Bal")


#boxplot: Limit_Bal by default and marriage
ggplot(data1, aes(x= MARRIAGE, y=idv1, fill=factor(MARRIAGE, labels=marr_cats))) +
  geom_boxplot(outlier.color='red', outlier.shape=1, 
               outlier.size=3, notch = FALSE)+
  ggtitle('BoxPlot: Credit Limit Balance by Default and Marriage')+
  ylab("Limit_Bal")


#boxplot: Limit_Bal by default and marriage re-coded
ggplot(data1, aes(x=MARRIAGE_2, y=idv1, fill=factor(MARRIAGE_2, labels=marr2_cats))) +
  geom_boxplot(outlier.color='red', outlier.shape=1, 
               outlier.size=3, notch = FALSE)+
  ggtitle('BoxPlot: Credit Limit Balance by Default and Marriage (re-coded)')+
  ylab("Limit_Bal")


#boxplot: Limit_Bal by default and sex
ggplot(data1, aes(x=SEX, y=idv1, fill=factor(SEX, labels=sex_cats))) +
  geom_boxplot(outlier.color='red', outlier.shape=1, 
               outlier.size=3, notch = FALSE)+
  ggtitle('BoxPlot: Credit Limit Balance by Default and Sex')+
  ylab("Limit_Bal")


#boxplot: default and Av_Bill_Amt
ggplot(data1, aes(x=DEFAULT, y=Avg_Bill_Amt, fill=factor(DEFAULT, labels=def_cats))) +
  geom_boxplot(outlier.color='red', outlier.shape=1, 
               outlier.size=3, notch = FALSE)+
  ggtitle('BoxPlot: Average Bill Amount by Default')+
  ylab('Average Bill Amount')


#boxplot: default and Av_Pmt_Amt
ggplot(data1, aes(x=DEFAULT, y=Avg_Pmt_Amt, fill=factor(DEFAULT, labels=def_cats))) +
  geom_boxplot(outlier.color='red', outlier.shape=1, 
               outlier.size=3, notch = FALSE)+
  ggtitle('BoxPlot: Average Payment Amount by Default')+
  ylab('Average Payment Amount')


#boxplot: default and Av_Pmt_Ratio
ggplot(data1, aes(x=DEFAULT, y=Avg_Pmt_Ratio, fill=factor(DEFAULT, labels=def_cats))) +
  geom_boxplot(outlier.color='red', outlier.shape=1, 
               outlier.size=3, notch = FALSE)+
  ggtitle('BoxPlot: Average Payment Ratio by Default')+
  ylab('Average Payment Ratio')


#boxplot: default and Av_Util
ggplot(data1, aes(x=DEFAULT, y=Avg_Util, fill=factor(DEFAULT, labels=def_cats)))+
  geom_boxplot(outlier.color='red', outlier.shape=1, 
               outlier.size=3, notch = FALSE)+
  ggtitle('BoxPlot: Average Utlization by Default')+
  ylab('Average Utilization')


#boxplot: default and Bal_Gr_6mo
ggplot(data1, aes(x=DEFAULT, y=Bal_Growth_6mo, fill=factor(DEFAULT, labels=def_cats))) +
  geom_boxplot(outlier.color='red', outlier.shape=1, 
               outlier.size=3, notch = FALSE)+
  ggtitle('BoxPlot: Balance Growth Over 6Mo by Default')+
  ylab('Balance Growth over 6mo')


#boxplot: default and Util_Gr_6mo
ggplot(data1, aes(x=DEFAULT, y=Util_Growth_6mo, fill=factor(DEFAULT, labels=def_cats))) +
  geom_boxplot(outlier.color='red', outlier.shape=1, 
               outlier.size=3, notch = FALSE)+
  ggtitle('BoxPlot: Utilizaiton Growth Over 6Mo by Default')+
  ylab('Utilization over 6mo')


#boxplot: default and Max_Bill_Amt
ggplot(data1, aes(x=DEFAULT, y=Max_Bill_Amt, fill=factor(DEFAULT, labels=def_cats))) +
  geom_boxplot(outlier.color='red', outlier.shape=1, 
               outlier.size=3, notch = FALSE)+
  ggtitle('BoxPlot: Maximum Bill Amount by Default')+
  ylab('Max Bill Amount')


#boxplot: default and Max_Pmt_Amt
ggplot(data1, aes(x=DEFAULT, y=Max_Pmt_Amt, fill=factor(DEFAULT, labels=def_cats))) +
  geom_boxplot(outlier.color='red', outlier.shape=1, 
               outlier.size=3, notch = FALSE)+
  ggtitle('BoxPlot: Maximum Payment Amount by Default')+
  ylab('Max Payment Amount')



#############
#Default on Binned Vars
############

##LIMIT_BAL.binned
z = data1$LIMIT_BAL.binned
a = prop.table(table(dv, z))
cat_cols = colnames(a)
def_mar_tbl = addmargins(prop.table(table(dv, z)))
rownames(def_mar_tbl)=c(def_cats, 'Sum')
colnames(def_mar_tbl)=c(cat_cols, 'Sum')
class(def_mar_tbl)='matrix'  #set to matrix so stargazer prints as matrix instead of columns

stargazer(def_mar_tbl, type=c('html'),out=paste(exp_path,'LIMIT_BAL.binned.html',sep=''),
          title=c('Prop Tbl:Default vs LIMIT BAL binned'),
          align=TRUE, digits=2, digits.extra=2, initial.zero=TRUE,
          summary=FALSE ) 

##AGE.binned
z = data1$AGE.binned
length(z)
a = prop.table(table(dv, z))
cat_cols = colnames(a)
def_mar_tbl = addmargins(prop.table(table(dv, z)))
rownames(def_mar_tbl)=c(def_cats, 'Sum')
colnames(def_mar_tbl)=c(cat_cols, 'Sum')
class(def_mar_tbl)='matrix'  #set to matrix so stargazer prints as matrix instead of columns

stargazer(def_mar_tbl, type=c('html'),out=paste(exp_path,'AGE.binned.html',sep=''),
          title=c('Prop Tbl:Default vs AGE binned'),
          align=TRUE, digits=2, digits.extra=2, initial.zero=TRUE,
          summary=FALSE ) 

##Avg_Bill_Amt
z = data1$Avg_Bill_Amt.binned
length(z)
a = prop.table(table(dv, z))
cat_cols = colnames(a)
def_mar_tbl = addmargins(prop.table(table(dv, z)))
rownames(def_mar_tbl)=c(def_cats, 'Sum')
colnames(def_mar_tbl)=c(cat_cols, 'Sum')
class(def_mar_tbl)='matrix'  #set to matrix so stargazer prints as matrix instead of columns

stargazer(def_mar_tbl, type=c('html'),out=paste(exp_path,'Avg_Bill_Amt.binned.html',sep=''),
          title=c('Prop Tbl:Default vs <br> Avg Bill Amt binned'),
          align=TRUE, digits=2, digits.extra=2, initial.zero=TRUE,
          summary=FALSE ) 

##Avg_Pmt_Amt
z = data1$Avg_Pmt_Amt.binned
length(z)
a = prop.table(table(dv, z))
cat_cols = colnames(a)
def_mar_tbl = addmargins(prop.table(table(dv, z)))
rownames(def_mar_tbl)=c(def_cats, 'Sum')
colnames(def_mar_tbl)=c(cat_cols, 'Sum')
class(def_mar_tbl)='matrix'  #set to matrix so stargazer prints as matrix instead of columns

stargazer(def_mar_tbl, type=c('html'),out=paste(exp_path,'Avg_Pmt_Amt.binned.html',sep=''),
          title=c('Prop Tbl:Default vs Avg Pmt Amt binned'),
          align=TRUE, digits=2, digits.extra=2, initial.zero=TRUE,
          summary=FALSE ) 

##Avg_Pmt_Ratio.binned
z = data1$Avg_Pmt_Ratio.binned
length(z)
a = prop.table(table(dv, z))
cat_cols = colnames(a)
def_mar_tbl = addmargins(prop.table(table(dv, z)))
rownames(def_mar_tbl)=c(def_cats, 'Sum')
colnames(def_mar_tbl)=c(cat_cols, 'Sum')
class(def_mar_tbl)='matrix'  #set to matrix so stargazer prints as matrix instead of columns

stargazer(def_mar_tbl, type=c('html'),out=paste(exp_path,'Avg_Pmt_Ratio.binned.html',sep=''),
          title=c('Prop Tbl:Default vs Avg Pmt Ratio binned'),
          align=TRUE, digits=2, digits.extra=2, initial.zero=TRUE,
          summary=FALSE ) 

##Avg_Util.binned
z = data1$Avg_Util.binned
length(z)
a = prop.table(table(dv, z))
cat_cols = colnames(a)
def_mar_tbl = addmargins(prop.table(table(dv, z)))
rownames(def_mar_tbl)=c(def_cats, 'Sum')
colnames(def_mar_tbl)=c(cat_cols, 'Sum')
class(def_mar_tbl)='matrix'  #set to matrix so stargazer prints as matrix instead of columns

stargazer(def_mar_tbl, type=c('html'),out=paste(exp_path,'Avg_Util.binned.html',sep=''),
          title=c('Prop Tbl:Default vs Avg Util binned'),
          align=TRUE, digits=2, digits.extra=2, initial.zero=TRUE,
          summary=FALSE ) 

##Bal_Growth_6mo.binned
z = data1$Bal_Growth_6mo.binned
length(z)
a = prop.table(table(dv, z))
cat_cols = colnames(a)
def_mar_tbl = addmargins(prop.table(table(dv, z)))
rownames(def_mar_tbl)=c(def_cats, 'Sum')
colnames(def_mar_tbl)=c(cat_cols, 'Sum')
class(def_mar_tbl)='matrix'  #set to matrix so stargazer prints as matrix instead of columns

stargazer(def_mar_tbl, type=c('html'),out=paste(exp_path,'Bal_Growth_6mo.binned.html',sep=''),
          title=c('Prop Tbl:Default vs Bal Growth 6mo binned'),
          align=TRUE, digits=2, digits.extra=2, initial.zero=TRUE,
          summary=FALSE ) 

## Util_Growth_6mo.binned
z = data1$Util_Growth_6mo.binned
length(z)
a = prop.table(table(dv, z))
cat_cols = colnames(a)
def_mar_tbl = addmargins(prop.table(table(dv, z)))
rownames(def_mar_tbl)=c(def_cats, 'Sum')
colnames(def_mar_tbl)=c(cat_cols, 'Sum')
class(def_mar_tbl)='matrix'  #set to matrix so stargazer prints as matrix instead of columns

stargazer(def_mar_tbl, type=c('html'),out=paste(exp_path,'Util_Growth_6mo.binned.html',sep=''),
          title=c('Prop Tbl:Default vs Util Growth 6mo binned'),
          align=TRUE, digits=2, digits.extra=2, initial.zero=TRUE,
          summary=FALSE ) 

## Max_Bill_Amt.binned
z = data1$Max_Bill_Amt.binned
length(z)
a = prop.table(table(dv, z))
cat_cols = colnames(a)
def_mar_tbl = addmargins(prop.table(table(dv, z)))
rownames(def_mar_tbl)=c(def_cats, 'Sum')
colnames(def_mar_tbl)=c(cat_cols, 'Sum')
class(def_mar_tbl)='matrix'  #set to matrix so stargazer prints as matrix instead of columns

stargazer(def_mar_tbl, type=c('html'),out=paste(exp_path,'Max_Bill_Amt.binned.html',sep=''),
          title=c('Prop Tbl:Default vs Max Bill Amt binned'),
          align=TRUE, digits=2, digits.extra=2, initial.zero=TRUE,
          summary=FALSE ) 


## Max_Pmt_Amt.binned
z = data1$Max_Pmt_Amt.binned
length(z)
a = prop.table(table(dv, z))
cat_cols = colnames(a)
def_mar_tbl = addmargins(prop.table(table(dv, z)))
rownames(def_mar_tbl)=c(def_cats, 'Sum')
colnames(def_mar_tbl)=c(cat_cols, 'Sum')
class(def_mar_tbl)='matrix'  #set to matrix so stargazer prints as matrix instead of columns

stargazer(def_mar_tbl, type=c('html'),out=paste(exp_path,'Max_Pmt_Amt.binned.html',sep=''),
          title=c('Prop Tbl:Default vs Max_Pmt Amt binned'),
          align=TRUE, digits=2, digits.extra=2, initial.zero=TRUE,
          summary=FALSE ) 

## Max_Pmt_Amt.binned
z = data1$data.group
length(z)
a = prop.table(table(dv, z))
cat_cols = colnames(a)
def_mar_tbl = addmargins(prop.table(table(dv, z)))
rownames(def_mar_tbl)=c(def_cats, 'Sum')
colnames(def_mar_tbl)=c(cat_cols, 'Sum')
class(def_mar_tbl)='matrix'  #set to matrix so stargazer prints as matrix instead of columns

stargazer(def_mar_tbl, type=c('html'),out=paste(exp_path,'Data_Split.html',sep=''),
          title=c('Prop Tbl:Train Validate Test Split'),
          align=TRUE, digits=2, digits.extra=2, initial.zero=TRUE,
          summary=FALSE ) 


#repeat OneR to see if there is a change in variable strength
#specify columns
var_cols2 = c(2:25, 31:52, 63:117)
data_idv2 = data1[,var_cols2]
head(data_idv2)

#OneR uses OneR package
model_2 <- OneR(DEFAULT ~ ., data=data_idv2, verbose=TRUE)
summary(model_2)


##############
# Limit_Bal
##############

#credit limit distribution
par(mar=c(0,0,2,0), mfrow=c(1,3))
hist(data1$LIMIT_BAL, main='Histogram: Credit Limit Balance')
plot(density(data1$LIMIT_BAL), main='Denisty Plot: Credit Limit Balance')
qqnorm(data1$LIMIT_BAL, main='QQ-Plot: Credit Limit Balance')
qqline(data1$LIMIT_BAL)
par(mar=c(0,0,2,0), mfrow=c(1,1))
#heavily skewed left



#to use ggplot heat map, first create corr matrix
#uses reshape2 library for melt

cont_cols = c(2, 13:24, 33:52) #define the continuous columns
cormat = round(cor(data1[,cont_cols]),2) 
melted_cormat = melt(cormat) #use reshape to 'melt' the cor matrix

# this gives you matrix but has redundant top and bottom
ggplot(data = melted_cormat, aes(x=Var1, y=Var2, fill=value)) + 
  geom_tile()

# Function to get lower triangle of the correlation matrix
get_lower_tri = function(cormat){   #replace 'lower' w/ upper for upper tri
  cormat[upper.tri(cormat)] = NA  #replace 'lower' w/ upper for upper tri
  return(cormat)
}

# using function defined above, get lower triangle
lower_tri <- get_lower_tri(cormat)

#repeat process to build heat map like above, but with lower matrix
melted_cormat = melt(lower_tri, na.rm = TRUE) #melt the upper matrix

ggplot(data=melted_cormat, aes(Var2, Var1, fill=value)) +
  geom_tile(color='white') + 
  scale_fill_gradient2(low='blue', high='red', mid='white',
                       midpoint=0, limit=c(-1,1), space='Lab',
                       name="Pearson\nCorrelation")+
  theme_minimal() + 
  theme(axis.text.x = element_text(angle = 90, vjust=0, 
                                   size=8, hjust = 0)) +
  ggtitle('Correlation Matrix: Continuous Variables')+
  coord_fixed()

#dv is the dependent varialbe set above

#histogram of balance limit
ggplot(data1, aes_string(x = idv1)) + 
      geom_histogram(alpha = .5,
      fill = "blue", bins=20) + 
      ggtitle('Histogram: Credit Limit Balance (bin=20)')

#boxplot: Limit_Bal
ggplot(data1, aes_string(y=idv1)) +
  geom_boxplot(outlier.color='red', outlier.shape=1, outlier.size=3,
               fill='light blue',notch = TRUE) +
  ylab('Limit Balance')

##density plot balance limit
ggplot(data1, aes_string(x = idv1)) + 
      geom_density(alpha = .5,fill = "blue") +
      ggtitle('Denisty Plot: Credit Limit Balance')

#density plot balance limit by sex
ggplot(data1, aes_string(x = idv1, fill=factor(data1$SEX, labels = sex_cats))) + 
      geom_density(alpha = .5) +
      ggtitle('Denisty Plot: Credit Limit Balance by Sex')

#boxplot: Limit_Bal by sex and education
ggplot(data1, aes(x=SEX, y=idv1, fill=factor(EDUCATION, labels=ed_cats))) +
  geom_boxplot(outlier.color='red', outlier.shape=1, 
               outlier.size=3, notch = FALSE)+
  ggtitle('BoxPlot: Credit Balance Limit by Sex and Education')+
  ylab('Limit Balance')

#boxplot: Limit_Bal by sex and education
ggplot(data1, aes(x=SEX, y=idv1, fill=factor(EDUCATION_2, labels=ed2_cats))) +
  geom_boxplot(outlier.color='red', outlier.shape=1, 
               outlier.size=3, notch = FALSE)+
  ggtitle('BoxPlot: Credit Balance Limit by Sex and Education')+
  ylab('Limit Balance')

#density plot balance limit by Education
ggplot(data1, aes_string(x = idv1, fill=factor(data1$EDUCATION, 
      labels = ed_cats))) + 
  geom_density(alpha = .5) +
  ggtitle('Denisty Plot: Credit Limit Balance by Education')


#density plot balance limit by Education_2
ggplot(data1, aes_string(x = idv1, fill=factor(data1$EDUCATION_2, 
      labels = ed2_cats))) + 
  geom_density(alpha = .5) +
  ggtitle('Denisty Plot: Credit Limit Balance by Education (re-coded)')

#density plot credit limit by marriage
ggplot(data1, aes_string(x = idv1, fill=factor(data1$MARRIAGE, 
      labels = marr_cats))) + 
    geom_density(alpha = .5) +
    ggtitle('Denisty Plot: Credit Limit Balance by Marriage')

#density plot credit limit by marriage
ggplot(data1, aes_string(x = idv1, fill=factor(data1$MARRIAGE_2, 
                        labels = marr2_cats))) + 
  geom_density(alpha = .5) +
  ggtitle('Denisty Plot: Credit Balance Limit by Marriage (re-coded)')


##############
#  Tables
##############




#dependent var is dv defined above







##############
#  Scatter plots
##############

#limit balance vs. bill_amt1

# sp1 = ggplot(data1, aes(LIMIT_BAL, BILL_AMT1, color=factor(SEX))) + geom_point()
# sp2 = ggplot(data1, aes(LIMIT_BAL, BILL_AMT1, color=factor(EDUCATION))) + geom_point()
# sp3 = ggplot(data1, aes(LIMIT_BAL, BILL_AMT1, color=factor(MARRIAGE))) + geom_point()
# 
# sp1
# sp2
# sp3
# #nothing useful with individual plots. look at average bill amount
# 
# #limit balance vs. pay_amt1
# sp4 = ggplot(data1, aes(LIMIT_BAL, PAY_AMT1, color=factor(SEX))) + geom_point()
# sp5 = ggplot(data1, aes(LIMIT_BAL, PAY_AMT1, color=factor(EDUCATION))) + geom_point()
# sp6 = ggplot(data1, aes(LIMIT_BAL, PAY_AMT1, color=factor(MARRIAGE))) + geom_point()
# 
# sp4
# sp5
# sp6
#same as above: nothing useful with individual plots.



########################################################################
#
#
#  RPart EDA Model
#
########################################################################
library(rpart)
#install.packages('rpart.plot', dependencies = TRUE)
library(rpart.plot)

cc_data_model_1 <- read.csv(file.path(my_path, 'cc_data_model.csv'), header = TRUE)

head(cc_data_model_1)
col_index(cc_data_model_1)


mod1cols = c(2:25)
mod2cols = c(2:3, 25, 6, 31:34, 40, 47:52)
mod3cols = c(25, 3, 70:74, 76:77, 79:80, 82:83, 85:87, 89:92, 94:95, 97:99, 101:102, 
             104:106, 108:111, 113:115, 117:119)


str(cc_data_model_1)
train_data = cc_data_model_1[cc_data_model_1$data.group==1,]
dim(train_data)

#https://blog.revolutionanalytics.com/2013/06/plotting-classification-and-regression-trees-with-plotrpart.html
#http://www.milbo.org/rpart-plot/prp.pdf

#model 1
train_mod = train_data[,mod1cols]
head(train_mod)

tree_mod1cols = rpart(DEFAULT~., train_mod, minsplit=20)
rpart.plot(tree_mod1cols, type=3, box.palette="RdBu", shadow.col = 'gray', nn=TRUE)
prp(tree_mod1cols)
tree_mod1cols

#model 2
train_mod2 = train_data[,mod2cols]
head(train_mod2)

tree_mod2cols = rpart(DEFAULT~., train_mod2, minsplit=3)
rpart.plot(tree_mod2cols, type=3, box.palette="RdBu", shadow.col = 'gray', nn=TRUE)
prp(tree_mod2cols)
tree_mod2cols

#model 3
train_mod3 = train_data[,mod3cols]
head(train_mod3)

tree_mod3cols = rpart(DEFAULT~., train_mod3, minsplit=20)
rpart.plot(tree_mod3cols, type=3, box.palette="RdBu", shadow.col = 'gray', nn=TRUE)
prp(tree_mod3cols)
tree_mod3cols
