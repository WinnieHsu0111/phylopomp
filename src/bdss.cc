// BDSS: Linear birth-death with superspreading (C++)
#include "master.h"
#include "popul_proc.h"
#include "generics.h"
#include "internal.h"

static const int normal = 1;
static const int superspreader = 2;

//! BDSS process state.
typedef struct {
  int IN;
  int IS;
} bdss_state_t;

//! BDSS process parameters.
typedef struct {
  double lambda_nn;
  double lambda_ns;
  double lambda_sn;
  double lambda_ss;
  double mu;
  double p;
  double pop;
  double fn;
  double fs;
} bdss_parameters_t;

using bdss_proc_t = popul_proc_t<bdss_state_t,bdss_parameters_t,8>;
using bdss_genealogy_t = master_t<bdss_proc_t,2>;

template<>
std::string bdss_proc_t::yaml (std::string tab) const {
  std::string t = tab + "  ";
  std::string p = tab + "parameter:\n"
    + YAML_PARAM(lambda_nn)
    + YAML_PARAM(lambda_ns)
    + YAML_PARAM(lambda_sn)
    + YAML_PARAM(lambda_ss)
    + YAML_PARAM(mu)
    + YAML_PARAM(p)
    + YAML_PARAM(pop)
    + YAML_PARAM(fn)
    + YAML_PARAM(fs);
  std::string s = tab + "state:\n"
    + YAML_STATE(IN)
    + YAML_STATE(IS);
  return p+s;
}

template<>
void bdss_proc_t::update_params (double *p, int n) {
  int m = 0;
  PARAM_SET(lambda_nn);
  PARAM_SET(lambda_ns);
  PARAM_SET(lambda_sn);
  PARAM_SET(lambda_ss);
  PARAM_SET(mu);
  PARAM_SET(p);
  if (m != n) err("wrong number of parameters!");
}

template<>
void bdss_proc_t::update_IVPs (double *p, int n) {
  int m = 0;
  PARAM_SET(pop);
  PARAM_SET(fn);
  PARAM_SET(fs);
  if (m != n) err("wrong number of initial-value parameters!");
}

template<>
double bdss_proc_t::event_rates (double *rate, int n) const {
  int m = 0;
  double total = 0;
  RATE_CALC(params.lambda_nn * state.IN);
  RATE_CALC(params.lambda_ns * state.IN);
  RATE_CALC(params.lambda_sn * state.IS);
  RATE_CALC(params.lambda_ss * state.IS);
  RATE_CALC(params.mu * (1 - params.p) * state.IN);
  RATE_CALC(params.mu * (1 - params.p) * state.IS);
  RATE_CALC(params.mu * params.p * state.IN);
  RATE_CALC(params.mu * params.p * state.IS);
  if (m != n) err("wrong number of events!");
  return total;
}

template<>
void bdss_genealogy_t::rinit (void) {
  double denom = params.fn + params.fs;
  if (denom > 0) {
    state.IN = nearbyint((params.fn * params.pop) / denom);
    state.IS = nearbyint((params.fs * params.pop) / denom);
  } else {
    state.IN = 1;
    state.IS = 0;
  }
  if (state.IN > 0) graft(normal, state.IN);
  if (state.IS > 0) graft(superspreader, state.IS);
}

template<>
void bdss_genealogy_t::jump (int event) {
  switch (event) {
  case 0:
    state.IN += 1; birth(normal, normal);
    break;
  case 1:
    state.IS += 1; birth(normal, superspreader);
    break;
  case 2:
    state.IN += 1; birth(superspreader, normal);
    break;
  case 3:
    state.IS += 1; birth(superspreader, superspreader);
    break;
  case 4:
    state.IN -= 1; death(normal);
    break;
  case 5:
    state.IS -= 1; death(superspreader);
    break;
  case 6:
    state.IN -= 1; sample_death(normal);
    break;
  case 7:
    state.IS -= 1; sample_death(superspreader);
    break;
  default:                      // #nocov
    assert(0);                  // #nocov
    break;                      // #nocov
  }
}

GENERICS(BDSS,bdss_genealogy_t)
