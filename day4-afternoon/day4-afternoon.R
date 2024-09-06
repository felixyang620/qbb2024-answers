library(tidyverse)
library(broom)


#Exercise 1

# read in the data
dnm <- read_csv(file = "~/qbb2024-answers/day4-afternoon/aau1043_dnm.csv")

ages <- read_csv(file = "~/qbb2024-answers/day4-afternoon/aau1043_parental_age.csv")

# step 1.2 + step 1.3
dnm_summary <- dnm %>%
  group_by(Proband_id) %>%
  summarize(n_paternal_dnm = sum(Phase_combined == "father", na.rm = TRUE),
            n_maternal_dnm = sum(Phase_combined == "mother", na.rm = TRUE))
# step 1.4
dnm_by_parental_age <- left_join(dnm_summary, ages, by = "Proband_id")

  

#Exercise 2

# 2.1.1
ggplot(data = dnm_by_parental_age,
       mapping = aes(x = Mother_age, y = n_maternal_dnm)) +
  geom_point()

#2.1.2
ggplot(data = dnm_by_parental_age,
       mapping = aes(x = Father_age, y = n_paternal_dnm)) +
  geom_point()

#Step 2.2
#Maternal
ggplot(data = dnm_by_parental_age,
       mapping = aes(x = Mother_age, y = n_maternal_dnm)) +
  geom_point() +
  stat_smooth(method = "lm")

lm(data = dnm_by_parental_age,
   formula = n_maternal_dnm ~ 1 + Mother_age) %>%
  summary()

# The size of this relationship is 0.37757. This means that for about every increase 1 year of age for mother,
# the number of de novo mutation increases by 0.37757. It matches the the plot I observed in 2.1. 
# This relationship is significant as the P-value is below <2e-16. It means that the relationship between
# the increase of age of mother significantly affects the possibility of increase in number of maternal mutation. 

#Step 2.3
#Paternal
ggplot(data = dnm_by_parental_age,
       mapping = aes(x = Father_age, y = n_paternal_dnm)) +
  geom_point() +
  stat_smooth(method = "lm")

lm(data = dnm_by_parental_age,
   formula = n_paternal_dnm ~ 1 + Father_age) %>%
  summary()

# The size of this relationship is 1.35384. This means that for about every increase 1 year of age for father,
# the number of de novo mutation increases by 1.35384. It matches the the plot I observed in 2.1. 
# This relationship is significant as the P-value is below <2e-16. It means that the relationship between
# the increase of age of father significantly affects the possibility of increase in number of paternal mutation.

#Step 2.4
num_predict = 10.32632+ 1.35384*50.5
print(num_predict)

# It predicts the paternal DNMs at 50.5 years of age to be 78.69524. 

# Step 2.5
ggplot(dnm_by_parental_age) +
  geom_histogram(aes(x = n_maternal_dnm, y = after_stat(density)), binwidth = 1, fill = "green", alpha = 0.5, position = "identity") +
  geom_histogram(aes(x = n_paternal_dnm, y = after_stat(density)), binwidth = 1, fill = "blue", alpha = 0.5, position = "identity") +
  labs(x = "Number of DNMs",
       y = "Density") +
  theme_minimal()

# Step 2.6
comparison <- t.test(dnm_by_parental_age$n_paternal_dnm, dnm_by_parental_age$n_maternal_dnm, paired = TRUE)
print(comparison)

# I chose the t-test because it shows if the difference between two groups are significant or not. 
# Here we are comparing only the paternal and maternal dnm, the 2 groups, so it's the best to use t-test here. 
# My test result here is significant as it shows p-value to be less than 2.2e-16. 






