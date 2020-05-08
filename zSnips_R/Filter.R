

#----------------------------------------------------------
# FILTER ON SINGLE CONDITION
d_Visits_1 = d_Visits[d_Visits$FolderSeq != 39,]

#----------------------------------------------------------
# USING SUBSET
x=subset(auto, mpg>40)

#----------------------------------------------------------
# FILTER ON CONDITION IN LIST
y<-c(33,44,29,16,25,45,33,19,54,22,21,49,11,24,56)
lessthan<-y[y<median(y)]  # all values in list < median of list y
less than

y<-c(33,44,29,16,25,45,33,19,54,22,21,49,11,24,56)
greaterthan<-y[y<median(y)]  # all values in list > median of list y
greaterthan


#----------------------------------------------------------
# FILTER ON MULTIPLE CONDITIONS
Test = unique(d_Visits$Subject[d_Visits$SiteGroup == 'US' & 
                d_Visits$Site == '4296 Ma'])

# gets max of df2 when df2$CLASS = 'A1' and
# gives volume when df2$Type column equals 'I'
volVal[volVal > max(df2[df2$CLASS == 'A1'&
                       df2$Type == 'I',
                       'VOLUMEc'])][1]


#----------------------------------------------------------                       
# FILTER ON STRING
filter(!(str_detect(`stringname`, 'YourCol')))

filter(msleep, order %in% c("Perissodactyla", "Primates"))

filter(!grepl('stringname', YourCol)) %>%  



#----------------------------------------------------------
# FILTER FOR MISSING VALUES ONLY
Hitters = Hitters[-which(is.na(Hitters$Salary)), ]


#----------------------------------------------------------                       
# FILTER BY MIN OR MAX
data %>% group_by(Group) %>%
  summarize(minAge = min(Age), 
            minAgeName = Name[which.min(Age)], 
            maxAge = max(Age), 
            maxAgeName = Name[which.max(Age)])
            
data %>% group_by(Group) %>%
  summarize(minAge = min(Age), 
            minAgeName = paste(Name[which(Age == min(Age))], 
                          collapse = ", "), 
            maxAge = max(Age), 
            maxAgeName = paste(Name[which(Age == max(Age))], 
                          collapse = ", "))
                          
stSVp = edcSV %>% 
  group_by(SiteGroup, Site, Subject) %>% 
  summarize( 
    Site_cnt = n_distinct(Site),
    Pt_Scr_cnt = n_distinct(Subject),    
    Visit_Date_min = as.Date(min(na.omit(VISITDAT))),
    Visit_Name_min = FolderName[which.min(na.omit(VISITDAT))],


#----------------------------------------------------------
# Filter for rows where year is evenly divided by 2
train = (year%%2 == 0)  


#----------------------------------------------------------
# set x (when y is 1) to equal x+1
x[y==1,]=x[y==1,]+1

# Another example    
df2 = df1[df1$city=="sj",c(7:10, 11:25, 83:95)]

    
    
