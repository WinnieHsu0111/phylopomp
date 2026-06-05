simulate("BDEI", time=5) |>
  plot(prune=FALSE, obscure=FALSE)

runBDEI(time=2, mu=1, la=0.5, psi=0.25, p=0.5, II0=2) |>
  simulate(time=5) |>
  plot(points=TRUE)
