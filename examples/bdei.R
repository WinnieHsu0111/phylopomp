library(phylopomp)

runBDEI(time=10, pop=2, E0=0.5, I0=0.5) |>
  plot()
