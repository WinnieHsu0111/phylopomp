simulate("BDSS", time=5) |>
  plot(prune=FALSE, obscure=FALSE)

runBDSS(time=2, la_nn=0.2, la_ss=2, p=0.5, IN0=2) |>
  simulate(time=5) |>
  plot(points=TRUE)
