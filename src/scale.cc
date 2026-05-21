#include "genealogy.h"
#include "generics.h"
#include "internal.h"

#include <R.h>
#include <Rdefines.h>

extern "C" {

  //! rescale and/or reset origin
  SEXP genealScaleShift (SEXP State, SEXP Scale, SEXP Origin) {
    genealogy_t A(State);
    slate_t scale = *REAL(AS_NUMERIC(Scale));
    slate_t origin = *REAL(AS_NUMERIC(Origin));
    SEXP S;
    A.time_rescale(scale,origin);
    PROTECT(S = serial(A));
    SET_ATTR(S,install("class"),mkString("gpgen"));
    UNPROTECT(1);
    return S;
  }

}
