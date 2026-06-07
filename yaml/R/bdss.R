##' Linear birth-death with superspreading
##'
##' Two-deme linear birth-death process with heterogeneous per-lineage transmission rates.
##' Compatible with the BDSS model of Voznica et al. (2022), https://doi.org/10.1038/s41467-022-31511-0,
##' and structured linear birth-death theory (Stadler 2010, https://doi.org/10.1016/j.jtbi.2010.09.010;
##' King et al. 2024, https://arxiv.org/abs/2405.17032).
##' YAML rate defaults are midpoints of the PhyloDeep training priors
##' (f in [0.05, 0.20], X in [3, 10], lambda_n in [0.5, 1.5], mu in [0.5, 1.5], p in [0.01, 1]).
##'
##' @name bdss
##' @family Genealogy processes
##' @aliases BDSS
##' @include getinfo.R
##' @param lambda_nn normal-to-normal transmission rate
##' @param lambda_ns normal-to-superspreader transmission rate
##' @param lambda_sn superspreader-to-normal transmission rate
##' @param lambda_ss superspreader-to-superspreader transmission rate
##' @param mu per capita removal rate
##' @param p probability of sampling upon removal
##' @param pop reference population size for scaling initial lineage counts
##' @param fn initial fraction of normal spreaders (ino/pop)
##' @param fs initial fraction of superspreaders (iso/pop)
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
  lambda_nn = 0.875, lambda_ns = 0.125, lambda_sn = 5.6875, lambda_ss = 0.8125, mu = 1, p = 0.505, pop = 1, fn = 1, fs = 0
) {
  params <- c(lambda_nn=lambda_nn,lambda_ns=lambda_ns,lambda_sn=lambda_sn,lambda_ss=lambda_ss,mu=mu,p=p)
  ivps <- c(pop=pop,fn=fn,fs=fs)
  x <- .Call(P_makeBDSS,params,ivps,t0)
  .Call(P_runBDSS,x,time) |>
    structure(model="BDSS",class=c("gpsim","gpgen"))
}

##' @rdname bdss
##' @export
continueBDSS <- function (
  object, time,
  lambda_nn = NA, lambda_ns = NA, lambda_sn = NA, lambda_ss = NA, mu = NA, p = NA
) {
  params <- c(
    lambda_nn=lambda_nn,lambda_ns=lambda_ns,lambda_sn=lambda_sn,lambda_ss=lambda_ss,mu=mu,p=p
  )
  x <- .Call(P_reviveBDSS,object,params)
  .Call(P_runBDSS,x,time) |>
    structure(model="BDSS",class=c("gpsim","gpgen"))
}
