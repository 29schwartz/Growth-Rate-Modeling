## Gompertz equation

gompertz_model <- function(A, mu, lambda, time){
  A * exp(-exp(-mu * (time - lambda)))
}

## Gompertz NLS fitting function

gompertz.fit <- function(.data, A_par, mu_par, lambda_par) {
  
  .data %>% dplyr::slice_max(OD600, n = 5) %>% pull(time) %>% mean() -> time_of_max_OD
  
  .data %>% filter(time <= (time_of_max_OD + 1)) -> GC
  
  start_values <- c(A = A_par, mu = mu_par, lambda = lambda_par)
  
  nls(GC$OD600 ~ gompertz_model(A,mu,lambda,time), data = GC,
      start = start_values,
      lower  = c(0,0,0),
      upper = c(1.8,1.5,22),
      control = list(maxiter = 500, tol = 1e-10, minFactor = 1e-10, warnOnly = TRUE),
      algorithm = "port",
      trace = F)
}