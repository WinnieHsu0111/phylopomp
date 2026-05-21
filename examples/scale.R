library(ggplot2)

runSEIR(t0=0,time=3,pop=200,E0=0.02,I0=0) -> x
geneal_scale(x,365,3) -> y
plot_grid(plot(x),plot(y),ncol=1)
