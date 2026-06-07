library(phylopomp)
set.seed(101)

runBDEI(time=2, pop=2, fe=0, fi=1) |>
  plot()
