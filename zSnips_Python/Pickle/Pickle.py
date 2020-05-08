import pickle

#Pickle each dataframe saving as OpenFlighxx.pkl'
#dfxx.read_pickle('OpenFlight.pkl') to read back in
dfap.to_pickle('OpenFlightAP.pkl')
dfal.to_pickle('OpenFlightAL.pkl')
dfrt.to_pickle('OpenFlightRT.pkl')
