library(tidyverse)
library(ggplot2)
# Load necessary library

# set proper pathway to extract data package from Python file
setwd("/Users/cmdb/qbb2024-answers/homework")
genome_coverage <- scan("genome_coverage.txt")

coverage_hist <- hist(genome_coverage, breaks = 40, plot = FALSE)

# draw the histogram plot for genome coverage

hist(genome_coverage, breaks = 40, probability = TRUE, 
     main = "Coverage Distribution Plot for Coverage of 3X",
     xlab = "Coverage", ylab = "Density", col = "blue", border = "blue")
# Do Poisson distribution
lambda <- 3
x_values <- 0:max(coverage_hist$breaks)
poisson_probs <- dpois(x_values, lambda)
lines(x_values, poisson_probs, type = "h", col = "green", lwd = 4)

# Overlay Normal distribution data with mean = 3 and std. dev. = sqrt(3)
mean_value <- 3
std_dev <- sqrt(3)
normal_probs <- dnorm(x_values, mean = mean_value, sd = std_dev)
lines(x_values, normal_probs, col = "red", lwd = 2)

# Add legend to the graph
legend("topright", legend = c("Histogram", "Poisson (λ=3)", "Normal (mean=3, sd=sqrt(3))"), 
       col = c("blue", "green", "red"), lwd = 2)

png("ex1_3x_cov.png")
dev.off()

# Find the 0 coverage genes amount/percentage
zero_coverage_count <- sum(genome_coverage == 0)
total <- length(genome_coverage)
percentage_unsequenced <- (zero_coverage_count / total) * 100
print(percentage_unsequenced)

