library(tidyverse)
library(ggplot2)
# Load necessary library

# set proper pathway to extract data package from Python file
setwd("/Users/cmdb/qbb2024-answers/homework")
genome_coverage <- scan("genome_coverage_10.txt")

coverage_hist <- hist(genome_coverage, breaks = 40, plot = FALSE)

# draw the histogram plot for genome coverage

hist(genome_coverage, breaks = 40, probability = TRUE, 
     main = "Coverage Distribution Plot for Coverage of 10X",
     xlab = "Coverage", ylab = "Density", col = "blue", border = "blue")
# Do Poisson distribution
lambda <- 10
x_values <- 0:max(coverage_hist$breaks)
poisson_probs <- dpois(x_values, lambda)
lines(x_values, poisson_probs, type = "h", col = "green", lwd = 4)

# Overlay Normal distribution data with mean = 10 and std. dev. = 3.16
mean_value <- 10
std_dev <- 3.16
normal_probs <- dnorm(x_values, mean = mean_value, sd = std_dev)
lines(x_values, normal_probs, col = "red", lwd = 2)

# Add legend to the graph
legend("topright", legend = c("Histogram", "Poisson (λ=10)", "Normal (mean=10, sd=3.16)"), 
       col = c("blue", "green", "red"), lwd = 2)

png("ex1_10x_cov.png")
dev.off()

# Find the 0 coverage genes amount/percentage
zero_coverage_count <- sum(genome_coverage == 0)
total <- length(genome_coverage)
percentage_unsequenced <- (zero_coverage_count / total) * 100
print(percentage_unsequenced)

