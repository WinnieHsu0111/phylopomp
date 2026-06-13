##' Linear birth-death with superspreading
##'
##' Two-deme linear birth-death process with heterogeneous per-lineage transmission rates.
##' Identical to the BDSS model of Voznica et al. (2022, https://doi.org/10.1038/s41467-022-31511-0), though the parameterization differs.
##'
##' @name bdss
##' @family Genealogy processes
##' @aliases BDSS
##' @include getinfo.R
##' @param lambda_nn normal-to-normal transmission rate
##' @param lambda_ns normal-to-superspreader transmission rate
##' @param lambda_sn superspreader-to-normal transmission rate
##' @param lambda_ss superspreader-to-superspreader transmission rate
##' @param mu per capita removal (death or recovery) rate
##' @param chi per capita destructive sampling rate
##' @param pop initial population size
##' @param N0 initial fraction of normal spreaders
##' @param S0 initial fraction of superspreaders
##' @param object a previously computed simulation
##' @param time end timepoint of simulation
##' @param t0 beginning timepoint of simulation
##' @return \code{runBDSS} and \code{continueBDSS} return objects of class \sQuote{gpsim} with \sQuote{model} attribute \dQuote{BDSS}.
##'
NULL

##' @rdname bdss
##' @export
runBDSS <- function (
  time, t0 = 0,
  lambda_nn = 0.875, lambda_ns = 0.125, lambda_sn = 5.5, lambda_ss = 0.75, mu = 0.5, chi = 0.5, pop = 1, N0 = 1, S0 = 0
) {
  params <- c(lambda_nn=lambda_nn,lambda_ns=lambda_ns,lambda_sn=lambda_sn,lambda_ss=lambda_ss,mu=mu,chi=chi)
  ivps <- c(pop=pop,N0=N0,S0=S0)
  x <- .Call(P_makeBDSS,params,ivps,t0)
  .Call(P_runBDSS,x,time) |>
    structure(model="BDSS",class=c("gpsim","gpgen"))
}

##' @rdname bdss
##' @export
continueBDSS <- function (
  object, time,
  lambda_nn = NA, lambda_ns = NA, lambda_sn = NA, lambda_ss = NA, mu = NA, chi = NA
) {
  params <- c(
    lambda_nn=lambda_nn,lambda_ns=lambda_ns,lambda_sn=lambda_sn,lambda_ss=lambda_ss,mu=mu,chi=chi
  )
  x <- .Call(P_reviveBDSS,object,params)
  .Call(P_runBDSS,x,time) |>
    structure(model="BDSS",class=c("gpsim","gpgen"))
}
