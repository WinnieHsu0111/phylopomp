simulate("SI2R",time=1) |>
  plot(obscure=FALSE)

runSI2R(Beta=10,pop=2000,time=1,chi=0) |>
  simulate(time=2,chi=1) |>
  plot(points=TRUE,obscure=FALSE)

simulate("SI2R",time=5) |>
  lineages() |>
  plot()

simulate("SI2R",time=2) |>
  diagram(m=30)

simulate(
  "SI2R",time=5,chi=0.2,pop=1000,
  Beta=1,etaH=3,gamma=1,omega=0,kappa=300
) -> x
plot_grid(
  x |> plot(obscure=FALSE),
  x |> lineages(obscure=FALSE) |> plot(),
  ncol=1,
  align="v",axis="b"
)
