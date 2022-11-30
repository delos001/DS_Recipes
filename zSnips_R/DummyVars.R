
#----------------------------------------------------------
# EXAMPLE TO CREATE DUMMY VARIABLES
# Model.matrix creates the new matrix and the dummy variables

feat_comb_2 = feat_comb_1

dummy_year = factor(feat_comb_2$year)
year_df = data.frame(model.matrix(~dummy_year))
year_dfa = year_df[,-1]

colcount = c(1:23)
for(i in colcount){
  year_dfa[,i] <- as.factor(year_dfa[,i])
}

#leaves 1990 off as baseline

feat_comb_2a = cbind(feat_comb_2, year_dfa)


#----------------------------------------------------------
# EXAMPLE 2 TO CREATE DUMMY VARIABLES
# Model.matrix creates the new matrix and the dummy variables
dummy = cc_data_fact
bind = cc_data_fact

# Education
d2 = model.matrix(~dummy$EDUCATION+0)   #+0 leaves off the intercept column
colnames(d2)= c('dED_Adv_Gra', 'dED_Grad', 
                'dED_University', 'dED_HS', 
                'dED_Other1', 'dED_Other2', 
                'dED_Other3')

# Education_2
d3= model.matrix(~cc_data_fact$EDUCATION_2+0)   +0 leaves off the intercept column
colnames(d3)= c('dED2_Adv_Gra', 'dED2_Grad', 
                'dED2_University', 'dED2_HS', 
                'dED2Other')
