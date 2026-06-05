options(digits=3)
suppressPackageStartupMessages({
  library(phylopomp)
})
set.seed(20260604)

x <- runBDSS(time=5)
stopifnot(
  attr(x, "model") == "BDSS",
  inherits(x, "gpsim")
)

y <- simulate("BDSS", time=3, la_nn=0.2, la_ss=2, p=0.5, IN0=2)
stopifnot(
  attr(y, "model") == "BDSS",
  is.finite(max(getInfo(y, time=TRUE)$time))
)

z <- continueBDSS(y, time=6)
stopifnot(attr(z, "model") == "BDSS")

y |> yaml() -> yaml_out
stopifnot(
  inherits(yaml_out, "gpyaml"),
  grepl("la_nn", yaml_out)
)
