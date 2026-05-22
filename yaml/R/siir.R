##' Two-strain SIR model
##'
##' Two distinct pathogen strains compete for susceptibles.
##'
##' @name siir
##' @family Genealogy processes
##' @aliases SIIR
##' @include getinfo.R
##' @param Beta1 transmission rate for strain 1
##' @param Beta2 transmission rate for strain 2
##' @param gamma recovery rate
##' @param psi1 sampling rate for deme 1
##' @param psi2 sampling rate for deme 2
##' @param sigma12 rate of movement from deme 1 to deme 2
##' @param sigma21 rate of movement from deme 2 to deme 1
##' @param omega rate of loss of immunity
##' @param pop population size
##' @param S_0 initial fraction of susceptible population
##' @param I1_0 initial fraction of deme-1 infected population
##' @param I2_0 initial fraction of deme-2 infected population
##' @param R_0 initial fraction of immune population
##' @param object a previously computed simulation
##' @param time end timepoint of simulation
##' @param t0 beginning timepoint of simulation
##' @return \code{runSIIR} and \code{continueSIIR} return objects of class \sQuote{gpsim} with \sQuote{model} attribute \dQuote{SIIR}.
##'
NULL

##' @rdname siir
##' @export
runSIIR <- function (
  time, t0 = 0,
  Beta1 = 5, Beta2 = 5, gamma = 1, psi1 = 1, psi2 = 0, sigma12 = 0, sigma21 = 0, omega = 0, pop = 500, S_0 = 0.96, I1_0 = 0.02, I2_0 = 0.02, R_0 = 0
) {
  params <- c(Beta1=Beta1,Beta2=Beta2,gamma=gamma,psi1=psi1,psi2=psi2,sigma12=sigma12,sigma21=sigma21,omega=omega)
  ivps <- c(pop=pop,S_0=S_0,I1_0=I1_0,I2_0=I2_0,R_0=R_0)
  x <- .Call(P_makeSIIR,params,ivps,t0)
  .Call(P_runSIIR,x,time) |>
    structure(model="SIIR",class=c("gpsim","gpgen"))
}

##' @rdname siir
##' @export
continueSIIR <- function (
  object, time,
  Beta1 = NA, Beta2 = NA, gamma = NA, psi1 = NA, psi2 = NA, sigma12 = NA, sigma21 = NA, omega = NA
) {
  params <- c(
    Beta1=Beta1,Beta2=Beta2,gamma=gamma,psi1=psi1,psi2=psi2,sigma12=sigma12,sigma21=sigma21,omega=omega
  )
  x <- .Call(P_reviveSIIR,object,params)
  .Call(P_runSIIR,x,time) |>
    structure(model="SIIR",class=c("gpsim","gpgen"))
}
