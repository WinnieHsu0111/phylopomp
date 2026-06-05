##' Linear birth-death with exposed and infectious classes
##'
##' Two-deme linear birth-death process with exposed (incubating) and infectious lineages.
##' Transmission creates exposed offspring from infectious donors; exposed lineages progress to infectious.
##' Removal and Stadler sampling-on-removal apply to infectious lineages only.
##' Compatible with the BDEI model of Voznica et al. and structured linear birth-death theory.
##'
##' @name bdei
##' @family Genealogy processes
##' @aliases BDEI
##' @include getinfo.R
##' @param mu per capita progression rate from exposed to infectious
##' @param la per capita transmission rate from infectious to exposed
##' @param psi per capita removal rate of infectious lineages
##' @param p probability of sampling upon infectious removal
##' @param IE0 initial number of exposed lineages
##' @param II0 initial number of infectious lineages
##' @param object a previously computed simulation
##' @param time end timepoint of simulation
##' @param t0 beginning timepoint of simulation
##' @return \code{runBDEI} and \code{continueBDEI} return objects of class \sQuote{gpsim} with \sQuote{model} attribute \dQuote{BDEI}.
##'
NULL

##' @rdname bdei
##' @export
runBDEI <- function (
  time, t0 = 0,
  mu = 1, la = 0.5, psi = 0.25, p = 0.3, IE0 = 0, II0 = 1
) {
  params <- c(mu=mu,la=la,psi=psi,p=p)
  ivps <- c(IE0=IE0,II0=II0)
  x <- .Call(P_makeBDEI,params,ivps,t0)
  .Call(P_runBDEI,x,time) |>
    structure(model="BDEI",class=c("gpsim","gpgen"))
}

##' @rdname bdei
##' @export
continueBDEI <- function (
  object, time,
  mu = NA, la = NA, psi = NA, p = NA
) {
  params <- c(
    mu=mu,la=la,psi=psi,p=p
  )
  x <- .Call(P_reviveBDEI,object,params)
  .Call(P_runBDEI,x,time) |>
    structure(model="BDEI",class=c("gpsim","gpgen"))
}
