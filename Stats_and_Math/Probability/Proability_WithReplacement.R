
# Sample replacement
# Refer to Black Section 4.3.

# Each of three people are presented with 5 different soft drinks in random  # order.  
# What is the probability the three people pick the same drink at random? 

number.of.possible.outcomes <- 5*5*5   # 3 people presented with 5 different options
number.of.outcomes.with.agreement <- 5  # number of possible outcomes where they all agree

# probability they pick the same softdrink at random
number.of.outcomes.with.agreement/number.of.possible.outcomes
