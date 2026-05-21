##' Rescale and/or shift time.
##'
##' Time-rescaling and/or shifting.
##'
##' @name geneal_scale
##' @return modified genealogy
##' @example examples/scale.R
##' @details
##' A linear transformation is applied to the genealogy's time-scale.
##' Specifically, if \eqn{t} is the old time and \eqn{t'} the new time,
##' then \eqn{t' = a (t - b)} where \eqn{a=}\code{scale} and
##' \eqn{b=}\code{origin}.
##'
NULL

##' @rdname geneal_scale
##' @param x genealogy to be scaled
##' @param scale,origin scalars
##' @export
geneal_scale <- function (x, scale, origin = 0) {
  .Call(P_geneal_scale,x,scale,origin)
}
