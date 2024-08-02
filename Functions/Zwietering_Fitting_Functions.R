
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
  A * exp(-exp((mu * exp(1)/A) * (lambda - time) + 1)) + .05
}


# Zwietering Fitting Function ---------------------------------------------

#' @concept This function using the nls function and provided starting estimates for coefficients will generate optimal fits.
#' @returns  a nested data frame of an absorbance time series this will produce a new column with coefficient predictions
Zwietering.fit <- function(.data) {
  start_values <- c(A = 1.4, mu = 0.21, lambda = 4.65)
  nls(.data$OD600 ~ Zwietering_gompertz_model(A,mu,lambda,time), data = .data,
      start = start_values,
      lower  = c(0,0,0),
      control = list(maxiter = 500, minFactor = 1/2000000, warnOnly = TRUE),
      algorithm = "port",
      trace = F)
}

# Zwietering with Anchored Alpha ------------------------------------------

#' @concept This function using the nls function and provided starting estimates for coefficients will generate optimal fits.
#' @param alpha_coefficient The difference from this function compared to positive controls is I am creating an upper bound that is 
#' dependent on the average of the positive controls on the assumption the variants will not grow to a greater final density than that.
#' @returns  a nested data frame of an absorbance time series this will produce a new column with coefficient predictions

# Zwietering Mathematical Model --------------------------------------------------------

#' @author model is adapted from Zwietering, M. H., Jongenburger, I., Rombouts, F. M. & van ’t Riet, K. Modeling of the 
#' Bacterial Growth Curve. Applied and Environmental Microbiology 56, 1875–1881 (1990).
#' @concept The mathematical model is used in conjunction with the NLS function from the stats package and collected data
#' to produce optimal growth curve fits
#' @param A is alpha and is the asymptote for growth curve
#' @param lambda is the lag time or time delay for the growth to reach exponential phase
#' @param mu is the growth rate in the exponential phase 
#' @param .05 is an added coefficient because background absorbance in media only was approximately .05. Improved curve fits

Zwietering_gompertz_anchored <- function(mu, lambda, time){
  1.6 * exp(-exp((mu * exp(1)/1.6) * (lambda - time) + 1)) + .05
}

Zwietering_A.fit <- function(.data, coefficient.list) {
  start_values <- c(mu = coefficient.list[[4]], lambda = coefficient.list[[5]])
  nls(.data$OD600 ~ Zwietering_gompertz_anchored(mu,lambda,time), data = .data,
      start = start_values,
      lower  = c(0,0),
      control = list(maxiter = 500, minFactor = 1/2000000, warnOnly = TRUE),
      algorithm = "port",
      trace = F)
}

