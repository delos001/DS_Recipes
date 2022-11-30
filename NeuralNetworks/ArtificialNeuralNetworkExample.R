

library(nnet)
library(caret)
 
mygrid = expand.grid(.decay = c(0.5, 0.1), .size=c(4,5,6))
train.nn1 = train(total_cases~
                    norm_year + 
                    weekofyear + 
                    Oct + 
                    reanalysis_relative_humidity_percent_diff + 
                    reanalysis_precip_amt_kg_per_m2_sl + 
                    station_precip_mm_sl + 
                    station_avg_temp_c_K_av + 
                    station_min_temp_c_K_av + 
                    ndvi_se_av + 
                    ndvi_nw_imp + 
                    ndvi_north_diff + 
                    ndvi_nw_sl + 
                    ndvi_se + 
                    ndvi_ne_imp + 
                    reanalysis_tdtr_k_av + 
                    reanalysis_dew_point_temp_k,
                 data=n_tr, method="nnet", maxit=1000, tuneGrid=mygrid, trace=FALSE )
 
print(train.nn1)
 
set.seed(123)
model.nn1 = nnet(total_cases~
                   norm_year + 
                   weekofyear + 
                   Oct + 
                   reanalysis_relative_humidity_percent_diff + 
                   reanalysis_precip_amt_kg_per_m2_sl + 
                   station_precip_mm_sl + 
                   station_avg_temp_c_K_av + 
                   station_min_temp_c_K_av + 
                   ndvi_se_av + 
                   ndvi_nw_imp + 
                   ndvi_north_diff + 
                   ndvi_nw_sl + 
                   ndvi_se + 
                   ndvi_ne_imp + 
                   reanalysis_tdtr_k_av + 
                   reanalysis_dew_point_temp_k,
                   data=n_tr, decay=0.1, size=6 )
 
summary(model.nn1)
nn.pred1 = predict(model.nn1, newdata = n_val)
nn.pred1 = ifelse(nn.pred1<0,0, nn.pred1)
nn.compare = data.frame(nn.pred1, n_val$total_cases)
write.csv(nn.compare, file="nn.csv", row.names = FALSE)
print(sum((n_val$total_cases - nn.pred1)^2))
