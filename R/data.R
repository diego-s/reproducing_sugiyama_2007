draw_gaussian_data <- function(N, M, phi, gamma) {
    set.seed(9999)
    mu_1 <- rep(0, M)
    mu_2 <- rep(phi, M)
    theta <- rnorm(M + 1, mean = 0, sd = 1)
    X_1 <- matrix(rnorm(N * M, mean = mu_1, sd = 1), nrow = N, ncol = M)
    y_1 <- cbind(rep(1, N), X_1) %*% theta + 
        rnorm(N, mean = 0, sd = gamma)
    X_2 <- matrix(rnorm(N * M, mean = mu_2, sd = 1), nrow = N, ncol = M)
    y_2 <- cbind(rep(1, N), X_2) %*% theta + 
        rnorm(N, mean = 0, sd = gamma)
    N <- 2000
    X_3 <- matrix(rnorm(N * M, mean = mu_2, sd = 1), nrow = N, ncol = M)
    y_3 <- cbind(rep(1, N), X_3) %*% theta + 
        rnorm(N, mean = 0, sd = gamma)
    data <- list(
        X_1 = X_1, 
        y_1 = y_1, 
        X_2 = X_2, 
        y_2 = y_2, 
        X_3 = X_3, 
        y_3 = y_3, 
        theta = theta, 
        mu_1 = mu_1, 
        mu_2 = mu_2
    )
    return(data)
}

draw_binomial_data <- function(N, M, phi, gamma) {
    set.seed(9999)
    mu_1 <- rep(0.2, M)
    mu_2 <- rep(phi, M)
    theta <- rnorm(M + 1, mean = 0, sd = 1)
    X_1 <- matrix(rbinom(N * M, size = 1, prob = mu_1), nrow = N, ncol = M)
    y_1 <- cbind(rep(1, N), X_1) %*% theta + 
        rnorm(N, mean = 0, sd = gamma)
    X_2 <- matrix(rbinom(N * M, size = 1, prob = mu_2), nrow = N, ncol = M)
    y_2 <- cbind(rep(1, N), X_2) %*% theta + 
        rnorm(N, mean = 0, sd = gamma)
    N <- 2000
    X_3 <- matrix(rbinom(N * M, size = 1, prob = mu_2), nrow = N, ncol = M)
    y_3 <- cbind(rep(1, N), X_3) %*% theta + 
        rnorm(N, mean = 0, sd = gamma)
    data <- list(
        X_1 = X_1, 
        y_1 = y_1, 
        X_2 = X_2, 
        y_2 = y_2, 
        X_3 = X_3, 
        y_3 = y_3, 
        theta = theta, 
        mu_1 = mu_1, 
        mu_2 = mu_2
    )
    return(data)
}

draw_sugiyama2007_data <- function(N = 150, M = 1, phi = 1, gamma = 0.25, 
    f = sinc) {
    set.seed(9999)
    mu_1 <- rep(1, M)
    mu_2 <- rep(mu_1 + phi, M)
    theta <- rep(NA, M + 1)
    X_1 <- matrix(rnorm(N * M, mean = mu_1, sd = 0.5), nrow = N, ncol = M)
    y_1 <- cbind(rowSums(f(X_1)) + rnorm(N, mean = 0, sd = gamma))
    X_2 <- matrix(rnorm(N * M, mean = mu_2, sd = 0.25), nrow = N, ncol = M)
    y_2 <- cbind(rowSums(f(X_2)) + rnorm(N, mean = 0, sd = gamma))
    N <- 2000
    X_3 <- matrix(rnorm(N * M, mean = mu_2, sd = 1), nrow = N, ncol = M)
    y_3 <- cbind(rowSums(f(X_3)) + rnorm(N, mean = 0, sd = gamma))
    data <- list(
        X_1 = X_1, 
        y_1 = y_1, 
        X_2 = X_2, 
        y_2 = y_2, 
        X_3 = X_3, 
        y_3 = y_3, 
        theta = theta, 
        mu_1 = mu_1, 
        mu_2 = mu_2
    )
    return(data)
}

plot_sugiyama2007_density <- function(phi, output_path) {
    x <- seq(-0.5, 3, length.out = 300)
    pdf_1 <- dnorm(x, mean = 1, sd = 0.5)
    pdf_2 <- dnorm(x, mean = 1 + phi, sd = 0.25)
    ratio <- pdf_2 / pdf_1
    levels <- c("training", "test", "ratio")
    data <- data.frame(
        x = rep(x, times = 3), 
        y = c(pdf_1, pdf_2, ratio), 
        type = factor(rep(levels, each = length(x)), levels = levels)
    )
    ggplot(data, aes(x = x, y = y, color = type, linetype = type)) + 
        geom_line() + 
        coord_cartesian(ylim = c(0, 1.8)) + 
        theme_light() + 
        ylab("density") + 
        labs(color = "density", linetype = "density") + 
        scale_color_nejm()
    ggsave(output_path, height = 4.5)
}

plot_sugiyama2007_data <- function(f, phi, data, theta, output_path) {
    x_f <- seq(-0.5, 3, length.out = 300)
    y_f <- f(x_f)
    x_1 <- data$X_1[,1]
    y_1 <- data$y_1
    x_2 <- data$X_2[,1]
    y_2 <- data$y_2
    f_hat <- c(cbind(rep(1, length(x_f)), x_f) %*% theta)
    levels <- c("f(x)", "f_hat(x)", "training", "test")
    data <- data.frame(
        x_f = c(x_f, x_f, rep(NA, length(y_1)), rep(NA, length(y_2))), 
        y_f = c(y_f, f_hat, rep(NA, length(y_1)), rep(NA, length(y_2))), 
        x_n = c(rep(NA, length(x_f)), rep(NA, length(x_f)), x_1, x_2), 
        y_n = c(rep(NA, length(y_f)), rep(NA, length(f_hat)), y_1, y_2), 
        line_type = factor(c(
            rep(levels[1], times = length(x_f)), 
            rep(levels[2], times = length(x_f)), 
            rep(NA, times = length(x_1)), 
            rep(NA, times = length(x_2))
        ), levels = levels[1:2]), 
        point_type = factor(c(
            rep(NA, times = length(x_f)), 
            rep(NA, times = length(x_f)), 
            rep(levels[3], times = length(x_1)), 
            rep(levels[4], times = length(x_2))
        ), levels = levels[3:4])
    )
    
    ggplot(data) + 
        geom_line(aes(x = x_f, y = y_f, linetype = line_type)) + 
        geom_point(aes(x = x_n, y = y_n, color = point_type)) + 
        theme_light() + 
        xlab("x") + 
        ylab("f(x)") + 
        scale_color_nejm(na.translate = FALSE) + 
        scale_linetype_discrete(na.translate = FALSE)
    ggsave(output_path, height = 4.5)
}
