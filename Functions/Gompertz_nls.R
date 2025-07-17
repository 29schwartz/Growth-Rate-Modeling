#This function will take in your nested data and output estimates for each of the three parameters
  #Alpha is the asymptote of the growth curve
  #mu is the growth rate (most important)
  #lambda is the lag time it takes before hitting exponential. 

gompertz_model <- function(A, mu, lambda, time){
  A * exp(-exp(-mu * (time - lambda)))
}



#Selects the two columns in the nested tibble you want to use for fitting. You should always have the time column and then the growth_values column!
select_nested <- function(df, ...) {
  cols <- enquos(...)  # capture column names
  df %>%
    mutate(nested_growth_data = map(nested_growth_data, ~ select(.x, !!!cols)))
}

#This is the actual fitting function that uses the growth_values and time as well as estimates for the different growth parameters. 
gompertz.fit <- function(.data, A_par, mu_par, lambda_par, growth_column) {
  
  .data %>% dplyr::slice_max(growth_values, n = 5) %>% pull(time) %>% mean() -> time_of_max_val
  
  .data %>% filter(time <= (time_of_max_val + 3)) -> GC
  
  start_values <- c(A = A_par, mu = mu_par, lambda = lambda_par)
  
  nls(GC$growth_values ~ gompertz_model(A,mu,lambda,time), data = GC,
      start = start_values,
      lower  = c(0,0,0),
      upper = c(1.8,1.5,22),
      control = list(maxiter = 500, tol = 1e-10, minFactor = 1e-10, warnOnly = TRUE),
      algorithm = "port",
      trace = F)
}