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

# Improved fitting function
zwietering.fit <- function(.data, A_par, mu_par, lambda_par, 
                           growth_column = "growth_values", 
                           time_column = "time",
                           lower_bounds = c(0, 0, 0),      # Sensible biological defaults
                           upper_bounds = c(Inf, Inf, Inf), 
                           trim_death_phase = TRUE) {      # Flag to remove death phase
  
  # Optional: Trim data after a prolonged stationary/death phase to protect 'A' estimate
  if(trim_death_phase) {
    # Find the time of the absolute maximum value
    max_time <- .data[[time_column]][which.max(.data[[growth_column]])]
    
    # Keep data up to the max time, PLUS a small buffer to capture the plateau
    # (Adjust the buffer multiplier based on your specific time scale)
    buffer <- (max(.data[[time_column]]) - min(.data[[time_column]])) * 0.1 
    .data <- .data %>% filter(!!sym(time_column) <= (max_time + buffer))
  }
  
  start_values <- c(A = A_par, mu = mu_par, lambda = lambda_par)
  
  # Create a dynamic formula so 'growth_column' and 'time_column' arguments actually work
  fit_formula <- as.formula(paste(growth_column, "~ zwietering_model(A, mu, lambda,", time_column, ")"))
  
  nls(formula = fit_formula, 
      data = .data,
      start = start_values,
      lower  = lower_bounds,
      upper = upper_bounds,
      control = list(maxiter = 1000, tol = 1e-10, minFactor = 1e-10, warnOnly = TRUE),
      algorithm = "port",
      trace = FALSE)
}