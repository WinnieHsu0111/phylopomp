##' Linear birth-death with superspreading
##'
##' Two-deme linear birth-death process with heterogeneous per-lineage transmission rates.
##' Compatible with the BDSS model of Voznica et al. and structured birth-death models of Stadler.
##'
##' @name bdss
##' @family Genealogy processes
##' @aliases BDSS
##' @include getinfo.R
##' @param la_nn normal-to-normal transmission rate
##' @param la_ns normal-to-superspreader transmission rate
##' @param la_sn superspreader-to-normal transmission rate
##' @param la_ss superspreader-to-superspreader transmission rate
##' @param mu per capita removal rate
##' @param p probability of sampling upon removal
##' @param IN0 initial number of normal spreaders
##' @param IS0 initial number of superspreaders
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
  la_nn = 0.1, la_ns = 0.3, la_sn = 0.5, la_ss = 1.5, mu = 0.25, p = 0.3, IN0 = 1, IS0 = 0
) {
  params <- c(la_nn=la_nn,la_ns=la_ns,la_sn=la_sn,la_ss=la_ss,mu=mu,p=p)
  ivps <- c(IN0=IN0,IS0=IS0)
  x <- .Call(P_makeBDSS,params,ivps,t0)
  .Call(P_runBDSS,x,time) |>
    structure(model="BDSS",class=c("gpsim","gpgen"))
}

##' @rdname bdss
##' @export
continueBDSS <- function (
  object, time,
  la_nn = NA, la_ns = NA, la_sn = NA, la_ss = NA, mu = NA, p = NA
) {
  params <- c(
    la_nn=la_nn,la_ns=la_ns,la_sn=la_sn,la_ss=la_ss,mu=mu,p=p
  )
  x <- .Call(P_reviveBDSS,object,params)
  .Call(P_runBDSS,x,time) |>
    structure(model="BDSS",class=c("gpsim","gpgen"))
}
