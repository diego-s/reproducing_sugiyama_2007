library(densratio)
library(glmnet)
library(ggplot2)
library(ggsci)
library(rdetools)
source("R/data.R")
source("R/glm.R")
source("R/evaluation.R")
#options(warn = 2)

N <- 150 # Number of samples in the input matrix, X
M <- 1 # Dimensionality of the input matrix, X
phi <- 1 # Distance between normal distributions
f <- sinc # Function to approximate
#f <- function(x) x ^ 2 # Function to approximate
#f <- sin # Function to approximate
#f <- function(x) cos(x + 0.5) # Function to approximate
#f <- function(x) log(x - 0.5) # Function to approximate

# Reproduce results from Sugiyama

# Draw random data
plot_sugiyama2007_density(phi)
data <- draw_sugiyama2007_data(N, M, phi, f = f)

# Unweighted model
results <- evaluate(fit_glm, predict_glm, data)
plot_sugiyama2007_data(f, phi, data, results$coefficients, 
    "figures/figure_2.png")

# Weighted model
results <- evaluate(fit_glm_weighted_glm, predict_glm, data)
print(results$coefficients)
plot_sugiyama2007_data(f, phi, data, results$coefficients, 
    "figures/figure_3.png")

# Target model
results <- evaluate(fit_target_glm, predict_glm, data)
print(results$coefficients)
plot_sugiyama2007_data(f, phi, data, results$coefficients, 
    "figures/figure_4.png")
