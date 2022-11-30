# package -----------------------------------------------------------------

library(tidyverse)


# build stuff -------------------------------------------------------------
stuff <- list(
  A = sample(1:10, 100, replace = TRUE),
  B = sample(1:20, 33, replace = TRUE),
  C = 1:10
)

# use browser  -------------------------------------------------------------
map2_df(stuff, names(stuff), function(object, object_name) {
  if (object_name == 'B') {
    browser()
  }
  data.frame(name = object_name, value = object)
})
