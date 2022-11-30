
#----------------------------------------------------------
# dfrt is the data frame, AL_2IATA_3ICAO is column name: 
# looks for duplicate entries in the column and adds them up
dfrt.AL_2IATA_3ICAO.duplicated().sum()
dfrt.duplicated().sum()  # does not specify col: looks across entire df

#----------------------------------------------------------
# this will produce the duplicate records using loc function: mark 
# all duplicates as true to all show up
dfrt.loc[dfrt.duplicated(keep=False), :]

#----------------------------------------------------------
# this is default parameter: mark duplicates as true except for first 
# occurrence (first is not identified as duplicate while all others are)
dfrt.loc[dfrt.duplicated(keep="First"), :]

#----------------------------------------------------------
# this marks the first duplicates and keeps the later ones
dfrt.loc[dfrt.duplicated(keep="Last"), :]

#----------------------------------------------------------
# this is without the keep function and is the same as keep=first
dfrt.loc[dfrt.duplicated(), :]

#----------------------------------------------------------
# drops the duplicates from the data frame (can use keep = last; 
# drops last. and keep = false which will drop both duplicates)
dfrt.drop_duplicates(keep='first')

#----------------------------------------------------------
# looks for duplicates off the two columns specified (like creating a unique 
# key for the two columns)
dfrt.duplicated(subset=['AL_2IATA_3ICAO', 'APID'])

#----------------------------------------------------------
# will sum the duplicates based on the unique key made by creating a 
# subset of the two columns
dfrt.duplicated(subset=['AL_2IATA_3ICAO', 'APID']).sum()

#----------------------------------------------------------
# will drop the duplicates that are identified based on the two-column key
dfrt.drop_duplicates(subset=['AL_2IATA_3ICAO', 'APID']).sum()
