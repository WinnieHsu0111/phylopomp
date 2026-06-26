png(filename="seir3-%02d.png",res=100)

options(tidyverse.quiet=TRUE,digits=3)
suppressPackageStartupMessages({
  library(tidyverse)
  library(pomp)
  library(phylopomp)
})
theme_set(theme_bw())

## Regression test for destructive sampling (chi) in seirs_pomp.
##
## The terminal-sample singular update carries two channels (qmd
## eq-sing-term + eq-sing-term-destr):
##   S (non-destructive): x'=x,     boost psi*(I-ellI)
##   D (destructive):     x'=x+e_I, boost chi*(I+1), host removed (I-=1).
## The D channel's host removal must be applied to the latent state, and the
## filter must be CONTINUOUS in chi (chi=0 reproduces the old likelihood;
## chi->0 changes the likelihood only by O(chi)).  A previous version summed
## the two boosts but never removed the host, making the likelihood jump
## discontinuously the moment chi became non-zero.  These checks guard that.

## chi must be an accepted argument.
stopifnot("chi" %in% names(formals(seirs_pomp)))

## ---------------------------------------------------------------------------
## Check 1: chi = 0 invariance.
## A psi>0 tree filtered at chi=0 and at a vanishingly small chi must give
## IDENTICAL likelihood when the RNG is reset to the same seed -- the chi
## branch must not perturb the result at chi=0.
## ---------------------------------------------------------------------------
set.seed(842110120)
simulate("SEIRS",
  Beta=4,sigma=1,gamma=1,psi=1,chi=0,omega=1,
  S0=100,E0=3,I0=5,R0=100,pop=208,
  time=5
) -> G
G |> curtail(time=3) -> Gc

ll_at <- function (chi, seed=998877, Np=2000) {
  po <- Gc |> seirs_pomp(
    Beta=4,sigma=1,gamma=1,psi=1,chi=chi,omega=1,
    S0=100,E0=3,I0=5,R0=100,pop=208
  )
  set.seed(seed)
  po |> pfilter(Np=Np) |> logLik()
}

ll_chi0  <- ll_at(0)
ll_tiny  <- ll_at(1e-12)
cat("Check 1 (chi=0 invariance):\n")
cat("  chi=0     logLik =",format(ll_chi0),"\n")
cat("  chi=1e-12 logLik =",format(ll_tiny),"\n")
stopifnot(
  is.finite(ll_chi0),
  ## identical to within floating-point noise
  abs(ll_tiny - ll_chi0) < 1e-6
)

## ---------------------------------------------------------------------------
## Check 2: continuity in chi.
## A small non-zero chi (approaching zero) should change the log-likelihood
## only slightly -- the gap must sit inside Monte Carlo noise.  Average over
## replicates so the comparison is against the se, not a single noisy run.
## ---------------------------------------------------------------------------
mll_at <- function (chi, seed=123, Np=2000, nrep=20) {
  po <- Gc |> seirs_pomp(
    Beta=4,sigma=1,gamma=1,psi=1,chi=chi,omega=1,
    S0=100,E0=3,I0=5,R0=100,pop=208
  )
  set.seed(seed)
  po |> pfilter(Np=Np) |> replicate(n=nrep) |> concat() |>
    logLik() |> logmeanexp(se=TRUE,ess=TRUE)
}

chi_small <- 0.001
m0 <- mll_at(0)
m1 <- mll_at(chi_small)
delta <- m1["est"] - m0["est"]
cat("Check 2 (continuity, chi->0):\n")
cat("  chi=0     : est =",format(m0["est"]),"se",format(m0["se"]),"\n")
cat("  chi=",chi_small,": est =",format(m1["est"]),"se",format(m1["se"]),"\n")
cat("  difference =",format(delta),"\n")
stopifnot(
  is.finite(m1["est"]),
  ## similar: within a few se (continuous, not a discontinuous jump)
  abs(delta) < 5*max(m0["se"],m1["se"])
)

## ---------------------------------------------------------------------------
## Check 3: destructive-sampling tree (psi=0, chi>0, the DL convention).
## The true parameters must score a finite likelihood and beat wrong ones.
## ---------------------------------------------------------------------------
set.seed(1)
xd <- runSEIR(
  time=5,t0=0,
  Beta=4,sigma=1,gamma=1,psi=0,chi=1,omega=0,
  S0=0.9,E0=0.05,I0=0.05,R0=0,pop=100
)
ll_d <- function (Beta,sigma,gamma,psi,chi,seed=3,Np=10000) {
  po <- seirs_pomp(xd,
    Beta=Beta,sigma=sigma,gamma=gamma,psi=psi,chi=chi,omega=0,
    S0=0.9,E0=0.05,I0=0.05,R0=0,pop=100)
  set.seed(seed); logLik(pfilter(po,Np=Np))
}
ll_true  <- ll_d(4,1,1,0,1)
ll_wrong <- ll_d(2,0.5,2,0,0.3)
cat("Check 3 (psi=0,chi=1 destructive tree):\n")
cat("  true  params logLik =",format(ll_true),"\n")
cat("  wrong params logLik =",format(ll_wrong),"\n")
stopifnot(
  is.finite(ll_true),
  ll_true > ll_wrong
)

cat("\nseir3: all checks PASSED\n")

dev.off()
