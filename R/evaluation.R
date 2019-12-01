evaluate <- function(fit_model, predict_model, data) {
    model <- fit_model(data)
    coefficients <- model$coefficients
    #print(sqrt(mean((data$theta - coefficients) ^ 2)))
    y_hat <- predict_model(model, data$X_3)
    error <- sqrt(mean((data$y_3 - y_hat) ^ 2))
    results <- list(
        error = error, 
        coefficients = coefficients
    )
    return(results)
}
