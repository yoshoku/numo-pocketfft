#include "pocketfftext.h"

VALUE mNumo;
VALUE mPocketfft;

VALUE numo_pocketfft_fft(VALUE x_val, int is_forward)
{
  narray_t* x_nary;
  double* x_pt;
  size_t length;
  int n_dims;
  int n_repeats;
  int i;
  int res;
  int fail;
  double fct;
  VALUE z_val;
  double* z_pt;
  narray_t* z_nary;
  cfft_plan plan = NULL;

  if (CLASS_OF(x_val) != numo_cDComplex) {
    x_val = rb_funcall(numo_cDComplex, rb_intern("cast"), 1, x_val);
  }
  if (!RTEST(nary_check_contiguous(x_val))) {
    x_val = nary_dup(x_val);
  }

  GetNArray(x_val, x_nary);
  n_dims = NA_NDIM(x_nary);
  length = NA_SHAPE(x_nary)[n_dims - 1];
  x_pt = (double*)na_get_pointer_for_read(x_val);

  plan = make_cfft_plan(length);
  if (!plan) {
    rb_raise(rb_eNoMemError, "Failed to allocate memory for plan of pocketfft.");
    return Qnil;
  }

  z_val = nary_s_new_like(numo_cDComplex, x_val);
  z_pt = (double*)na_get_pointer_for_write(z_val);
  GetNArray(z_val, z_nary);
  for (i = 0; i < (int)(NA_SIZE(z_nary) * 2); z_pt[i++] = 0.0);

  fail = 0;
  fct = is_forward == 1 ? 1.0 : 1.0 / length;
  n_repeats = (int)(NA_SIZE(x_nary)) / length;
  for (i = 0; i < n_repeats; i++) {
    memcpy(z_pt, x_pt, 2 * length * sizeof(double));
    res = is_forward == 1 ? cfft_forward(plan, z_pt, fct) : cfft_backward(plan, z_pt, fct);
    if (res != 0) {
      fail = 1;
      break;
    }
    z_pt += length * 2;
    x_pt += length * 2;
  }

  if (plan) {
    destroy_cfft_plan(plan);
  }

  RB_GC_GUARD(x_val);

  if (fail) {
    rb_raise(rb_eNoMemError, "Failed to allocate memory in function of pocketfft.");
    rb_funcall(z_val, rb_intern("free"), 0);
    return Qnil;
  }

  return z_val;
}

/**
 * @!visibility private
 */
static VALUE numo_pocketfft_cfft(VALUE self, VALUE x_val)
{
  return numo_pocketfft_fft(x_val, 1);
}

/**
 * @!visibility private
 */
static VALUE numo_pocketfft_icfft(VALUE self, VALUE x_val)
{
  return numo_pocketfft_fft(x_val, 0);
}

/**
 * @!visibility private
 */
static VALUE numo_pocketfft_rfft(VALUE self, VALUE x_val)
{
  narray_t* x_nary;
  double* x_pt;
  int n_dims;
  size_t length;
  int n_repeats;
  int i;
  int fail;
  size_t* z_shape;
  VALUE z_val;
  narray_t* z_nary;
  double* z_pt;
  int z_step;
  rfft_plan plan = NULL;

  if (CLASS_OF(x_val) != numo_cDFloat) {
    x_val = rb_funcall(numo_cDFloat, rb_intern("cast"), 1, x_val);
  }
  if (!RTEST(nary_check_contiguous(x_val))) {
    x_val = nary_dup(x_val);
  }

  GetNArray(x_val, x_nary);
  n_dims = NA_NDIM(x_nary);
  length = NA_SHAPE(x_nary)[n_dims - 1];
  x_pt = (double*)na_get_pointer_for_read(x_val);

  plan = make_rfft_plan(length);
  if (!plan) {
    rb_raise(rb_eNoMemError, "Failed to allocate memory for plan of pocketfft.");
    return Qnil;
  }

  z_shape = ALLOCA_N(size_t, n_dims);
  for (i = 0; i < n_dims - 1; i++) {
    z_shape[i] = NA_SHAPE(x_nary)[i];
  }
  z_shape[n_dims - 1] = length / 2 + 1;
  z_val = rb_narray_new(numo_cDComplex, n_dims, z_shape);
  z_pt = (double*)na_get_pointer_for_write(z_val);
  GetNArray(z_val, z_nary);
  for (i = 0; i < (int)(NA_SIZE(z_nary) * 2); z_pt[i++] = 0.0);

  fail = 0;
  z_step = (int)(NA_SHAPE(z_nary)[n_dims - 1]) * 2;
  n_repeats = (int)(NA_SIZE(x_nary)) / length;
  for (i = 0; i < n_repeats; i++) {
    z_pt[z_step - 1] = 0.0;
    memcpy(z_pt + 1, x_pt, length * sizeof(double));
    if (rfft_forward(plan, z_pt + 1, 1.0) != 0) {
      fail = 1;
      break;
    }
    z_pt[0] = z_pt[1];
    z_pt[1] = 0.0;
    z_pt += z_step;
    x_pt += length;
  }

  if (plan) {
    destroy_rfft_plan(plan);
  }

  RB_GC_GUARD(x_val);

  if (fail) {
    rb_raise(rb_eNoMemError, "Failed to allocate memory in function of pocketfft.");
    rb_funcall(z_val, rb_intern("free"), 0);
    return Qnil;
  }

  return z_val;
}

/**
 * @!visibility private
 */
static VALUE numo_pocketfft_irfft(VALUE self, VALUE x_val)
{
  narray_t* x_nary;
  double* x_pt;
  size_t length;
  int n_dims;
  int n_repeats;
  int i;
  int fail;
  double fct;
  size_t* z_shape;
  VALUE z_val;
  double* z_pt;
  narray_t* z_nary;
  rfft_plan plan = NULL;

  if (CLASS_OF(x_val) != numo_cDComplex) {
    x_val = rb_funcall(numo_cDComplex, rb_intern("cast"), 1, x_val);
  }
  if (!RTEST(nary_check_contiguous(x_val))) {
    x_val = nary_dup(x_val);
  }

  GetNArray(x_val, x_nary);
  n_dims = NA_NDIM(x_nary);
  length = NA_SHAPE(x_nary)[n_dims - 1];
  x_pt = (double*)na_get_pointer_for_read(x_val);

  plan = make_rfft_plan(length);
  if (!plan) {
    rb_raise(rb_eNoMemError, "Failed to allocate memory for plan of pocketfft.");
    return Qnil;
  }

  z_shape = ALLOCA_N(size_t, n_dims);
  for (i = 0; i < n_dims - 1; i++) {
    z_shape[i] = NA_SHAPE(x_nary)[i];
  }
  z_shape[n_dims - 1] = length;
  z_val = rb_narray_new(numo_cDFloat, n_dims, z_shape);
  z_pt = (double*)na_get_pointer_for_write(z_val);
  GetNArray(z_val, z_nary);
  for (i = 0; i < (int)NA_SIZE(z_nary); z_pt[i++] = 0.0);

  fail = 0;
  fct = 1.0 / length;
  n_repeats = (int)(NA_SIZE(z_nary)) / length;
  for (i = 0; i < n_repeats; i++) {
    memcpy(z_pt + 1, x_pt + 2, (length - 1) * sizeof(double));
    z_pt[0] = x_pt[0];
    if (rfft_backward(plan, z_pt, fct) != 0) {
      fail = 1;
      break;
    }
    z_pt += length;
    x_pt += length * 2;
  }

  if (plan) {
    destroy_rfft_plan(plan);
  }

  RB_GC_GUARD(x_val);

  if (fail) {
    rb_raise(rb_eNoMemError, "Failed to allocate memory in function of pocketfft.");
    rb_funcall(z_val, rb_intern("free"), 0);
    return Qnil;
  }

  return z_val;
}

void Init_pocketfftext()
{
  rb_require("numo/narray");

  mNumo = rb_define_module("Numo");

  mPocketfft = rb_define_module_under(mNumo, "Pocketfft");

  rb_define_module_function(mPocketfft, "ext_rfft", numo_pocketfft_rfft, 1);
  rb_define_module_function(mPocketfft, "ext_irfft", numo_pocketfft_irfft, 1);
  rb_define_module_function(mPocketfft, "ext_cfft", numo_pocketfft_cfft, 1);
  rb_define_module_function(mPocketfft, "ext_icfft", numo_pocketfft_icfft, 1);
}
