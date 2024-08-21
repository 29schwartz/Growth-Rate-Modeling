#Exponential Fit

Exponential <- function(a, r, time){
  a*exp(r*time)
}


# Exponential Fitting Function ---------------------------------------------


Exponential_Fit <- function(.data) {
  start_values <- c(a = .001, r = 4)
  nls(.data$OD562 ~ Exponential(a,r,time), data = .data,
      start = start_values,
      lower  = c(0,0),
      control = list(maxiter = 500, minFactor = 1/20000, warnOnly = TRUE),
      algorithm = "port",
      trace = F)
}
