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
functions <- list( # Functions to approximate
    sinc = sinc, 
    sin = sin, 
    square = function(x) x ^ 2
)

# Reproduce results from Sugiyama

for (name in names(functions)) {
    
    f <- functions[[name]]

    # Draw random data
    plot_sugiyama2007_density(phi, 
        output_path = sprintf("figures/figure_1_%s.png", name))
    data <- draw_sugiyama2007_data(N, M, phi, f = f)
    
    # Unweighted model
    results <- evaluate(fit_glm, predict_glm, data)
    plot_sugiyama2007_data(f, phi, data, results$coefficients, 
        sprintf("figures/figure_2_%s.png", name))
    
    # Weighted model
    results <- evaluate(fit_glm_weighted_glm, predict_glm, data)
    print(results$coefficients)
    plot_sugiyama2007_data(f, phi, data, results$coefficients, 
        sprintf("figures/figure_3_%s.png", name))
    
    # Target model
    results <- evaluate(fit_target_glm, predict_glm, data)
    print(results$coefficients)
    plot_sugiyama2007_data(f, phi, data, results$coefficients, 
        sprintf("figures/figure_4_%s.png", name))
}
