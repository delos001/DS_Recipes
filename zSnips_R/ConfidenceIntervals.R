

stSVg = stSVp %>% group_by() %>%
  summarize( 
    Site_cnt_g = sum(Site_cnt),
    Pt_Scr_cnt_g = sum(Pt_Scr_cnt),
    Visit_Total_Yes_cnt_g = sum(Visit_Total_Yes_cnt),
    Visit_Total_No_cnt_g = sum(Visit_Total_No_cnt),
    Visit_Sch_cnt_g = sum(Visit_Sch_cnt),
    Visit_D1_cnt_g = sum(Visit_D1_cnt),
    Visit_ET_cnt_g = sum(Visit_ET_cnt),

    Visit_Date_min_g = as.Date(min(na.omit(Visit_Date_min))),
    Visit_Name_min_g = Visit_Name_min[which.min(na.omit(Visit_Date_min_g))],
    
    Visit_Date_max_g = as.Date(max(na.omit(Visit_Date_max))),
    Visit_Name_max_g = Visit_Name_max[which.max(na.omit(Visit_Date_max_g))],
    
    Visit_Date_Sch_max_g = as.Date(max(na.omit(Visit_Date_Sch_max)), 
                                   origin = "1970-01-01"),
    Visit_Name_Sch_max_g = Visit_Name_Sch_max[which.max(Visit_Date_Sch_max_g)],
    
    #calculate days and months on study
    DOS_g = sum(DOS),
    MOS_g = sum(MOS),
    MOS_min_g = min(MOS),
    MOS_max_g = max(MOS),
    MOS_PerPt_av_g = round(MOS_g/Visit_D1_cnt_g, 2),
    MOS_PerPt_sd_g = sqrt(sum((MOS[MOS != 0] - MOS_PerPt_av_g)**2)/Visit_D1_cnt_g),
    MOS_LCI_g = round(MOS_PerPt_av_g - 
                         (qnorm(0.975)*MOS_PerPt_sd_g/sqrt(Visit_D1_cnt_g)),2),
    MOS_UCI_g = round(MOS_PerPt_av_g + 
                         (qnorm(0.975)*MOS_PerPt_sd_g/sqrt(Visit_D1_cnt_g)),2)
    )
