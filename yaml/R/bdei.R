##' Linear birth-death with exposed and infectious classes
##'
##' Two-deme linear birth-death process with exposed (incubating) and infectious lineages.
##' Transmission creates exposed offspring from infectious donors; exposed lineages progress to infectious.
##' Removal and Stadler sampling-on-removal apply to infectious lineages only.
##' Identical to the BDEI model of Voznica et al. (2022, https://doi.org/10.1038/s41467-022-31511-0), albeit with a different parameterization.
##'
##' @name bdei
##' @family Genealogy processes
##' @aliases BDEI
##' @include getinfo.R
##' @param sigma per capita progression rate (exposed to infectious)
##' @param lambda per capita reproduction rate
##' @param mu per capita removal rate (of infectious lineages)
##' @param chi (destructive) sampling rate
##' @param pop initial population size
##' @param E0 initial fraction of exposed lineages
##' @param I0 initial fraction of infectious lineages
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
  sigma = 1/7, lambda = 7/9, mu = 1/6, chi = 1/6, pop = 1, E0 = 0, I0 = 1
) {
  params <- c(sigma=sigma,lambda=lambda,mu=mu,chi=chi)
  ivps <- c(pop=pop,E0=E0,I0=I0)
  x <- .Call(P_makeBDEI,params,ivps,t0)
  .Call(P_runBDEI,x,time) |>
    structure(model="BDEI",class=c("gpsim","gpgen"))
}

##' @rdname bdei
##' @export
continueBDEI <- function (
  object, time,
  sigma = NA, lambda = NA, mu = NA, chi = NA
) {
  params <- c(
    sigma=sigma,lambda=lambda,mu=mu,chi=chi
  )
  x <- .Call(P_reviveBDEI,object,params)
  .Call(P_runBDEI,x,time) |>
    structure(model="BDEI",class=c("gpsim","gpgen"))
}
