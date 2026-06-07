options(digits=3)
suppressPackageStartupMessages({
  library(phylopomp)
})
set.seed(20260605)

x <- runBDEI(time=5)
stopifnot(
  attr(x, "model") == "BDEI",
  inherits(x, "gpsim")
)

y <- simulate("BDEI", time=3, mu=1, lambda_ie=0.5, psi=0.25, p=0.5, pop=2, fe=0, fi=1)
stopifnot(
  attr(y, "model") == "BDEI",
  is.finite(max(getInfo(y, time=TRUE)$time))
)

runBDEI(time=2, mu=2, lambda_ie=1, psi=0.5, p=0.2, pop=4, fe=0.75, fi=0.25) -> w
stopifnot(
  attr(w, "model") == "BDEI",
  is.finite(max(getInfo(w, time=TRUE)$time))
)

z <- continueBDEI(y, time=6)
stopifnot(attr(z, "model") == "BDEI")

y |> yaml() -> yaml_out
stopifnot(
  inherits(yaml_out, "gpyaml"),
  grepl("lambda_ie", yaml_out)
)
