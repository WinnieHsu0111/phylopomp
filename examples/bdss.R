library(phylopomp)
set.seed(101)

runBDSS(time=2, pop=2, fn=1, fs=0) |>
  plot()
