##' Classical susceptible-exposed-infected-recovered model
##'
##' The population is structured by infection progression.
##' There is an incubation period that must pass before an infected
##' host becomes infectious. The duration of this period is \eqn{1/\sigma}.
##' The infectious period is \eqn{1/\gamma}.
##'
##' @name seir
##' @family Genealogy processes
##' @aliases SEIR
##' @include getinfo.R
##' @param Beta transmission rate
##' @param sigma progression rate
##' @param gamma recovery rate
##' @param psi per capita non-destructive sampling rate
##' @param chi per capita destructive sampling rate
##' @param omega rate of waning of immunity
##' @param pop host population size
##' @param S0 initial fraction of population susceptible to infection
##' @param E0 initial fraction of population in exposed class
##' @param I0 initial fraction of population in infectious class
##' @param R0 initial fraction of population immune to infection
##' @param object a previously computed simulation
##' @param time end timepoint of simulation
##' @param t0 beginning timepoint of simulation
##' @return \code{runSEIR} and \code{continueSEIR} return objects of class \sQuote{gpsim} with \sQuote{model} attribute \dQuote{SEIR}.
##' @references
##' \King2024
##' @example examples/seir.R
NULL

##' @rdname seir
##' @export
runSEIR <- function (
  time, t0 = 0,
  Beta = 4, sigma = 1, gamma = 1, psi = 1, chi = 0, omega = 0, pop = 100, S0 = 0.9, E0 = 0.05, I0 = 0.05, R0 = 0
) {
  params <- c(Beta=Beta,sigma=sigma,gamma=gamma,psi=psi,chi=chi,omega=omega)
  ivps <- c(pop=pop,S0=S0,E0=E0,I0=I0,R0=R0)
  if (any(ivps < 0))
    pStop(paste(sQuote(names(ivps)),collapse=","),
      " must be nonnegative.")
  x <- .Call(P_makeSEIR,params,ivps,t0)
  .Call(P_runSEIR,x,time) |>
    structure(model="SEIR",class=c("gpsim","gpgen"))
}

##' @rdname seir
##' @export
runSEIRS <- runSEIR

##' @rdname seir
##' @export
continueSEIR <- function (
  object, time,
  Beta = NA, sigma = NA, gamma = NA, psi = NA, chi = NA, omega = NA
) {
  params <- c(
    Beta=Beta,sigma=sigma,gamma=gamma,psi=psi,chi=chi,omega=omega
  )
  x <- .Call(P_reviveSEIR,object,params)
  .Call(P_runSEIR,x,time) |>
    structure(model="SEIR",class=c("gpsim","gpgen"))
}

##' @rdname seir
##' @export
continueSEIRS <- continueSEIR
