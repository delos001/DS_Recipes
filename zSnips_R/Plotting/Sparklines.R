

#----------------------------------------------------------
#----------------------------------------------------------
# DT PACKAGE
#----------------------------------------------------------
#----------------------------------------------------------

#----------------------------------------------------------
# EXAMPLE
# look up JQuery documentation for plot options
library(DT)
library(sparkline)
library(dplyr)

datatables(prices, 
	   filter = 'top', 
	   options = list(paging = FALSE) %>%
	   formatPercentage('Change', digits = 1)

sparkline_column = spk_chr(	# add column to table to hold sparklines
	vector_of_values, 	# create vector containing your values (such as data over time)
	type = 'type_of_chart',
	chartRangeMin = 0,	# set chart min
	chartRangeMax = max(.$vector_of_values)  # set chart max
)
)

	   
	   
	   
#----------------------------------------------------------
#----------------------------------------------------------
# TIDY VERSION
#----------------------------------------------------------
#----------------------------------------------------------

tidyprices = prices %>%
select(-Change) %>%  # exclude change column

# gather wide data into rows so you can get change over time
gather(key = 'Quarter', 
       value = 'Price', 
       Q1_1996:Q1_2018)

prices_sparkline_data = tidyprices %>%
group_by(MetroArea) %>%
summarize(TrendSparkline = spk_chr(
	Prices, 
	type = 'line',
	chartRangeMin = 100, 
	chartRangeMax = max(Price)
)
	 )

prices = left_join(prices, 
		   prices_sparkline_data)

# snippet of javacode required for any sparkline, added to datatable function
datatable(prices, 
	  escape = FALSE, 
	  filter = 'top', 
	  ptions = list(paging = FALSE,
			fnDrawCallback = 
			htmlwidgets::JS(
				function(){
					HTMLWidgets.staticRender();
				}
				'
)
)) %>%
spk_add_deps() %>%  # converts code to line
formatPercentage('Change', digits = 1)
