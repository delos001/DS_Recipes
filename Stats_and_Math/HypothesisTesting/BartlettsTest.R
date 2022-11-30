
# tests homegenuity across data groups
# test homogenuity of shuck residuals across Class groups contained in the df2

bartlett.test(shuckregress$residuals~Class, data = df2)
