png(filename="scale-%02d.png",res=100)

options(tidyverse.quiet=TRUE,digits=3)
suppressPackageStartupMessages({
  library(tidyverse)
  library(phylopomp)
})
theme_set(theme_bw())

set.seed(847110120)
runSEIR(t0=0,time=1,Beta=4,sigma=1,gamma=1,psi=1,omega=1) -> x1
set.seed(847110120)
runSEIR(t0=10,time=20,Beta=0.4,sigma=0.1,gamma=0.1,psi=0.1,omega=0.1) -> x2

plot_grid(
  plot(x1,points=TRUE,prune=FALSE,obscure=FALSE),
  plot(x2,points=TRUE,prune=FALSE,obscure=FALSE),
  plot(geneal_scale(x2,0.1,10),points=TRUE,prune=FALSE,obscure=FALSE),
  ncol=1
)

stopifnot(
  identical(
    getInfo(x1,t0=TRUE,time=TRUE),
    getInfo(geneal_scale(x2,0.1,10),t0=TRUE,time=TRUE)
  )
)

dev.off()
