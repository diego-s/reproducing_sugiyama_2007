fit_glm <- function(data) {
    X <- data$X_1
    y <- data$y_1
    data_frame <- data.frame(y = y)
    data_frame <- cbind(data_frame, as.data.frame(X))
    model <- lm(y ~ ., data = data_frame)
    return(model)
}

fit_target_glm <- function(data) {
    set.seed(9999)
    X <- data$X_2
    y <- data$y_2
    data_frame <- data.frame(y = y)
    data_frame <- cbind(data_frame, as.data.frame(X))
    model <- lm(y ~ ., data = data_frame)
    return(model)
}

fit_glm_weighted_glm <- function(data) {
    X <- rbind(data$X_1, data$X_2)
    z <- c(rep(0, nrow(data$X_1)), rep(1, nrow(data$X_2)))
    data_frame <- data.frame(z = z)
    data_frame <- cbind(data_frame, as.data.frame(X))
    discriminator <- glm(z ~ ., data = data_frame, family = "binomial")
    p <- predict(discriminator, data_frame, type = "response")[1:nrow(data$X_1)]
    ratio <- sum(z == 0) / sum(z == 1)
    weights <- (p * ratio) / (1 - p)
    X <- data$X_1
    y <- data$y_1
    data_frame <- data.frame(y = y)
    data_frame <- cbind(data_frame, as.data.frame(X))
    model <- lm(y ~ ., data = data_frame, weights = weights)
    return(model)
}

fit_lasso_weighted_glm <- function(data) {
    X <- rbind(data$X_1, data$X_2)
    z <- c(rep(0, nrow(data$X_1)), rep(1, nrow(data$X_2)))
    discriminator <- cv.glmnet(X, z, family = "binomial")
    p <- predict(discriminator, X, type = "response")[1:nrow(data$X_1)]
    ratio <- sum(z == 0) / sum(z == 1)
    weights <- (p * ratio) / (1 - p)
    X <- data$X_1
    y <- data$y_1
    data_frame <- data.frame(y = y)
    data_frame <- cbind(data_frame, as.data.frame(X))
    model <- lm(y ~ ., data = data_frame, weights = weights)
    return(model)
}

fit_true_weighted_glm <- function(data) {
    z <- c(rep(0, nrow(data$X_1)), rep(1, nrow(data$X_2)))
    p <- exp(rowSums(log(t(t(data$X_1) * data$mu_2) + t(t(1 - data$X_1) * 
        (1 - data$mu_2)))))
    ratio <- sum(z == 0) / sum(z == 1)
    weights <- (p * ratio) / (1 - p)
    X <- data$X_1
    y <- data$y_1
    data_frame <- data.frame(y = y)
    data_frame <- cbind(data_frame, as.data.frame(X))
    model <- lm(y ~ ., data = data_frame, weights = weights)
    return(model)
}

fit_ulsif_weighted_glm <- function(data) {
    X <- rbind(data$X_1, data$X_2)
    discriminator <- densratio(data$X_2, data$X_1, verbose = FALSE)
    weights <- discriminator$compute_density_ratio(data$X_1)
    X <- data$X_1
    y <- data$y_1
    data_frame <- data.frame(y = y)
    data_frame <- cbind(data_frame, as.data.frame(X))
    model <- lm(y ~ ., data = data_frame, weights = weights)
    return(model)
}

predict_glm <- function(model, X) {
    data_frame <- as.data.frame(X)
    y_hat <- predict(model, newdata = data_frame)
    return(y_hat)
}
