##' Linear birth-death with exposed and infectious classes
##'
##' Two-deme linear birth-death process with exposed (incubating) and infectious lineages.
##' Transmission creates exposed offspring from infectious donors; exposed lineages progress to infectious.
##' Removal and Stadler sampling-on-removal apply to infectious lineages only.
##' Compatible with the BDEI model of Voznica et al. (2022), https://doi.org/10.1038/s41467-022-31511-0,
##' and structured linear birth-death theory (Stadler 2010, https://doi.org/10.1016/j.jtbi.2010.09.010;
##' King et al. 2024, https://arxiv.org/abs/2405.17032).
##' YAML rate defaults are midpoints of the PhyloDeep training priors
##' (R0 in [1.1, 3.5], T_I in [1, 5], T_E/T_I in [0.2, 5], p in [0.01, 1]).
##'
##' @name bdei
##' @family Genealogy processes
##' @aliases BDEI
##' @include getinfo.R
##' @param mu per capita progression rate from exposed to infectious
##' @param lambda_ie per capita transmission rate from infectious to exposed
##' @param psi per capita removal rate of infectious lineages
##' @param p probability of sampling upon infectious removal
##' @param pop reference population size for scaling initial lineage counts
##' @param fe initial fraction of exposed lineages (ie/pop)
##' @param fi initial fraction of infectious lineages (ii/pop)
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
  mu = 0.128205128205128, lambda_ie = 0.766666666666667, psi = 0.333333333333333, p = 0.505, pop = 1, fe = 0, fi = 1
) {
  params <- c(mu=mu,lambda_ie=lambda_ie,psi=psi,p=p)
  ivps <- c(pop=pop,fe=fe,fi=fi)
  x <- .Call(P_makeBDEI,params,ivps,t0)
  .Call(P_runBDEI,x,time) |>
    structure(model="BDEI",class=c("gpsim","gpgen"))
}

##' @rdname bdei
##' @export
continueBDEI <- function (
  object, time,
  mu = NA, lambda_ie = NA, psi = NA, p = NA
) {
  params <- c(
    mu=mu,lambda_ie=lambda_ie,psi=psi,p=p
  )
  x <- .Call(P_reviveBDEI,object,params)
  .Call(P_runBDEI,x,time) |>
    structure(model="BDEI",class=c("gpsim","gpgen"))
}
