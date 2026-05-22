simulate("SIR",Beta=2,gamma=1,psi=2,pop=1000,I0=0.005,time=5) |>
  simulate(Beta=5,gamma=2,time=10,psi=3) |>
  plot()

runSIR(Beta=3,gamma=1,psi=2,pop=25,S0=0.8,I0=0.2,R0=0,time=5,t0=-1) |>
  plot(points=TRUE)

runSIR(Beta=3,gamma=0.1,psi=0.2,pop=100,S0=1,I0=0.05,R0=0,time=2,t0=0) -> x
plot_grid(plotlist=list(plot(x,points=TRUE),diagram(x)),
  ncol=1,rel_heights=c(4,1))

simulate("SIRS",omega=1,time=20,I0=0.05) |> plot()
simulate("SIRS",omega=1,time=20,I0=0.05) |> lineages() |> plot()
