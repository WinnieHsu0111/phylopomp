##' Three strains compete for a single susceptible pool.
##'
##' The three demes are three distinct pathogen strains that
##' compete for susceptibles. Sampling is assumed destructive,
##' i.e., sampled individuals are removed from the infectious pool.
##'
##' @name strains
##' @family Genealogy processes
##' @aliases Strains
##' @include getinfo.R
##' @param Beta1 transmission rate for strain 1
##' @param Beta2 transmission rate for strain 2
##' @param Beta3 transmission rate for strain 3
##' @param gamma recovery rate
##' @param chi (destructive) sampling rate
##' @param pop population size
##' @param S_0 initial susceptible fraction
##' @param I1_0 initial fraction of population infected by strain 1
##' @param I2_0 initial fraction of population infected by strain 2
##' @param I3_0 initial fraction of population infected by strain 2
##' @param R_0 initial fraction of population immune
##' @param object a previously computed simulation
##' @param time end timepoint of simulation
##' @param t0 beginning timepoint of simulation
##' @return \code{runStrains} and \code{continueStrains} return objects of class \sQuote{gpsim} with \sQuote{model} attribute \dQuote{Strains}.
##'
NULL

##' @rdname strains
##' @export
runStrains <- function (
  time, t0 = 0,
  Beta1 = 5/7, Beta2 = 5/7, Beta3 = 5/7, gamma = 1/7, chi = 0.002, pop = 1e6, S_0 = 0.9, I1_0 = 0.003, I2_0 = 0.003, I3_0 = 0.003, R_0 = 0.1
) {
  params <- c(Beta1=Beta1,Beta2=Beta2,Beta3=Beta3,gamma=gamma,chi=chi)
  ivps <- c(pop=pop,S_0=S_0,I1_0=I1_0,I2_0=I2_0,I3_0=I3_0,R_0=R_0)
  x <- .Call(P_makeStrains,params,ivps,t0)
  .Call(P_runStrains,x,time) |>
    structure(model="Strains",class=c("gpsim","gpgen"))
}

##' @rdname strains
##' @export
continueStrains <- function (
  object, time,
  Beta1 = NA, Beta2 = NA, Beta3 = NA, gamma = NA, chi = NA
) {
  params <- c(
    Beta1=Beta1,Beta2=Beta2,Beta3=Beta3,gamma=gamma,chi=chi
  )
  x <- .Call(P_reviveStrains,object,params)
  .Call(P_runStrains,x,time) |>
    structure(model="Strains",class=c("gpsim","gpgen"))
}
