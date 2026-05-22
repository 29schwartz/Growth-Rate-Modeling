# Zwietering Mathematical Model --------------------------------------------------------

#' @author model is adapted from Zwietering, M. H., Jongenburger, I., Rombouts, F. M. & van ’t Riet, K. Modeling of the 
#' Bacterial Growth Curve. Applied and Environmental Microbiology 56, 1875–1881 (1990).
#' @concept The mathematical model is used in conjunction with the NLS function from the stats package and collected data
#' to produce optimal growth curve fits
#' @param A is alpha and is the asymptote for growth curve
#' @param lambda is the lag time or time delay for the growth to reach exponential phase
#' @param mu is the growth rate in the exponential phase 
#' @param .05 is an added coefficient because background absorbance in media only was approximately .05. Improved curve fits

zwietering_model <- function(A, mu, lambda, time){
  e_value <- exp(1)
  return(A * exp( -exp(((mu * e_value) / A) * (lambda - time) + 1)))
}



# Zwietering Fitting Function ---------------------------------------------

#' @concept This function using the nls function and provided starting estimates for coefficients will generate optimal fits.
#' @returns  a nested data frame of an absorbance time series this will produce a new column with coefficient predictions

#' @param time_of_max_OD is finding the maximum OD and averaging it over time in case there is noise in the data

#' @returns a data frame of values less than or equal to the max time which can be fit!


#Selects the two columns in the nested tibble you want to use for fitting. You should always have the time column and then the growth_values column!
select_nested <- function(df, ...) {
  cols <- enquos(...)  # capture column names
  df %>%
    mutate(nested_growth_data = map(nested_growth_data, ~ select(.x, !!!cols)))
}

#This is the actual fitting function that uses the growth_values and time as well as estimates for the different growth parameters. 
zwietering.fit <- function(.data, A_par, mu_par, lambda_par, growth_column) {
  
  .data %>% dplyr::slice_max(growth_values, n = 5) %>% pull(time) %>% mean() -> time_of_max_val
  
  .data %>% filter(time <= (time_of_max_val + 1)) -> GC
  
  start_values <- c(A = A_par, mu = mu_par, lambda = lambda_par)
  
  nls(GC$growth_values ~ gompertz_model(A,mu,lambda,time), data = GC,
      start = start_values,
      lower  = c(0,0,0),
      upper = c(1.8,1.75,22),
      control = list(maxiter = 500, tol = 1e-10, minFactor = 1e-10, warnOnly = TRUE),
      algorithm = "port",
      trace = F)
}