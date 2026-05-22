# Zwietering Mathematical Model --------------------------------------------------------

#' @author model is adapted from Zwietering, M. H., Jongenburger, I., Rombouts, F. M. & van ’t Riet, K. Modeling of the 
#' Bacterial Growth Curve. Applied and Environmental Microbiology 56, 1875–1881 (1990).
#' @concept The mathematical model is used in conjunction with the NLS function from the stats package and collected data
#' to produce optimal growth curve fits
#' @param A is alpha and is the asymptote for growth curve
#' @param lambda is the lag time or time delay for the growth to reach exponential phase
#' @param mu is the growth rate in the exponential phase 
#' @param .05 is an added coefficient because background absorbance in media only was approximately .05. Improved curve fits

Zwietering_gompertz_model <- function(A, mu, lambda, time){
  A * exp(-exp((mu/A) * (lambda - time) + 1))
}


# Zwietering Fitting Function ---------------------------------------------

#' @concept This function using the nls function and provided starting estimates for coefficients will generate optimal fits.
#' @returns  a nested data frame of an absorbance time series this will produce a new column with coefficient predictions

#' @param time_of_max_OD is finding the maximum OD and averaging it over time in case there is noise in the data

#' @returns a data frame of values less than or equal to the max time which can be fit!

Zwietering.fit <- function(.data, A_par, mu_par, lambda_par) {
  
  .data %>% dplyr::slice_max(OD600, n = 7) %>% pull(time) %>% mean() -> time_of_max_OD
  
  .data %>% filter(time <= (time_of_max_OD + 1)) -> GC
  
  start_values <- c(A = A_par, mu = mu_par, lambda = lambda_par)
  nls(GC$OD600 ~ Zwietering_gompertz_model(A,mu,lambda,time), data = GC,
      start = start_values,
      lower  = c(0,0,0),
      upper = c(1.7,.35,16),
      control = list(maxiter = 500, minFactor = 1/2000, warnOnly = TRUE),
      algorithm = "port",
      trace = F)
}