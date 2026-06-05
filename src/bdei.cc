// BDEI: Linear birth-death with exposed and infectious classes (C++)
#include "master.h"
#include "popul_proc.h"
#include "generics.h"
#include "internal.h"

static const int exposed = 1;
static const int infectious = 2;

//! BDEI process state.
typedef struct {
  int IE;
  int II;
} bdei_state_t;

//! BDEI process parameters.
typedef struct {
  double mu;
  double la;
  double psi;
  double p;
  int IE0;
  int II0;
} bdei_parameters_t;

using bdei_proc_t = popul_proc_t<bdei_state_t,bdei_parameters_t,4>;
using bdei_genealogy_t = master_t<bdei_proc_t,2>;

template<>
std::string bdei_proc_t::yaml (std::string tab) const {
  std::string t = tab + "  ";
  std::string p = tab + "parameter:\n"
    + YAML_PARAM(mu)
    + YAML_PARAM(la)
    + YAML_PARAM(psi)
    + YAML_PARAM(p)
    + YAML_PARAM(IE0)
    + YAML_PARAM(II0);
  std::string s = tab + "state:\n"
    + YAML_STATE(IE)
    + YAML_STATE(II);
  return p+s;
}

template<>
void bdei_proc_t::update_params (double *p, int n) {
  int m = 0;
  PARAM_SET(mu);
  PARAM_SET(la);
  PARAM_SET(psi);
  PARAM_SET(p);
  if (m != n) err("wrong number of parameters!");
}

template<>
void bdei_proc_t::update_IVPs (double *p, int n) {
  int m = 0;
  PARAM_SET(IE0);
  PARAM_SET(II0);
  if (m != n) err("wrong number of initial-value parameters!");
}

template<>
double bdei_proc_t::event_rates (double *rate, int n) const {
  int m = 0;
  double total = 0;
  RATE_CALC(params.mu * state.IE);
  RATE_CALC(params.la * state.II);
  RATE_CALC(params.psi * (1 - params.p) * state.II);
  RATE_CALC(params.psi * params.p * state.II);
  if (m != n) err("wrong number of events!");
  return total;
}

template<>
void bdei_genealogy_t::rinit (void) {
  state.IE = params.IE0;
state.II = params.II0;
if (params.IE0 > 0) graft(exposed, params.IE0);
graft(infectious, params.II0);
}

template<>
void bdei_genealogy_t::jump (int event) {
  switch (event) {
  case 0:
      state.IE -= 1; state.II += 1; migrate(exposed, infectious);
      break;
    case 1:
      state.IE += 1; birth(infectious, exposed);
      break;
    case 2:
      state.II -= 1; death(infectious);
      break;
    case 3:
      state.II -= 1; sample_death(infectious);
      break;
  default:                      // #nocov
    assert(0);                  // #nocov
    break;                      // #nocov
  }
}

GENERICS(BDEI,bdei_genealogy_t)
