
# adding one data frame to bottom of another

# DataFrame.append(other, ignore_index=False, verify_integrity=False)


# Data Frame Appending

#----------------------------------------------------------
# EXAMPLE 1
dict2A={'a':[1,2,3,4],'b':[5,6,7,8],'c':[10,9,8,7]}
dict2B={'a':[100,200,300,4000],'c':[50,60,70,80],'g':[1000,2000,3000,0000]}

frameA=pd.DataFrame(dict2A)
frameB=pd.DataFrame(dict2B)

appendAB=frameA.append(frameB)
appendAB

#----------------------------------------------------------
# EXAMPLE 2
dict2A={'a':[1,2,3,4],'b':[5,6,7,8],'c':[10,9,8,7]}
dict2B={'a':[100,200,300,4000],'c':[50,60,70,80],'g':[1000,2000,3000,0000]}

frameA=pd.DataFrame(dict2A)
frameB=pd.DataFrame(dict2B)

append=frameA.append(frameB, ignore_index=True)



#----------------------------------------------------------
# EXAMPLE 3
tr_all_loc = tr1_im_loc.append(tr2_im_loc)
tr_all_loc = tr_all_loc.append(tr3_im_loc)

# this resests the index and drops the old index (ie: so you don't have the 
# same number for each data frame you add)
tr_all_loc = tr_all_loc.reset_index(drop=True)

tr_all_loc.tail()
