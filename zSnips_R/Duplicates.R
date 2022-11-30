

## example 1
DupCheck = lbBAS_bind[duplicated(lbBAS_bind[,c('SUBJECT', 'FOLDERNAME', 
                                               'LBSTDTN', 'LBSTTM', 'LBREFID',
                                               'LBTEST', 'LBORRES')]),]
                                               
                                               
## example 2
DupResults = lbBAS_bind %>%
  dplyr::group_by(SUBJECT, FOLDERNAME, LBSTDTN, LBSTTM, LBREFID, LBTEST, LBORRES) %>%
  dplyr::tally() %>%
  dplyr::filter(n > 1) %>%
  dplyr::select(-n) %>%
  dplyr::mutate(Finding = paste0(n, ' duplicate test results identified'))
