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

y <- simulate("BDSS", time=3, lambda_nn=0.2, lambda_ss=2, p=0.5, pop=2, fn=1, fs=0)
stopifnot(
  attr(y, "model") == "BDSS",
  is.finite(max(getInfo(y, time=TRUE)$time))
)

runBDSS(time=2, lambda_nn=0.2, lambda_ss=2, mu=0.5, p=0.2, pop=4, fn=0.25, fs=0.75) -> w
stopifnot(
  attr(w, "model") == "BDSS",
  is.finite(max(getInfo(w, time=TRUE)$time))
)

z <- continueBDSS(y, time=6)
stopifnot(attr(z, "model") == "BDSS")

y |> yaml() -> yaml_out
stopifnot(
  inherits(yaml_out, "gpyaml"),
  grepl("lambda_nn", yaml_out)
)
