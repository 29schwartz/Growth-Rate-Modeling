#This function will take in your nested data and output estimates for each of the three parameters
  #Alpha is the asymptote of the growth curve
  #mu is the growth rate (most important)
  #lambda is the lag time it takes before hitting exponential. 

gompertz_model <- function(A, mu, lambda, time){
  A * exp(-exp(-mu * (time - lambda)))
}

#This function will select the column that you want to fit! 
select_nested <- function(df, ...) {
  cols <- enquos(...)  # capture column names
  df %>%
    mutate(data = map(data, ~ select(.x, !!!cols)))
}


## Gompertz NLS fitting function

gompertz.fit <- function(.data, A_par, mu_par, lambda_par, time, growth_val) {
  
#this will select the columns you want to fit!
  time_value <- enquo(time)
  growth_value <- enquo(growth_value)
  
  .data %>%
      mutate(.data = map(data ~ select(.x, !!time_value, !!growth_value)))
  
  
  
  .data %>% dplyr::slice_max(!!growth_value, n = 5) %>% pull(time) %>% mean() -> time_of_max_val
  
  .data %>% filter(time <= (time_of_max_val + 3)) -> GC
  
  start_values <- c(A = A_par, mu = mu_par, lambda = lambda_par)
  
  nls(GC$blanked_OD600 ~ gompertz_model(A,mu,lambda,time), data = GC,
      start = start_values,
      lower  = c(0,0,0),
      upper = c(1.8,1.5,22),
      control = list(maxiter = 500, tol = 1e-10, minFactor = 1e-10, warnOnly = TRUE),
      algorithm = "port",
      trace = F)
}