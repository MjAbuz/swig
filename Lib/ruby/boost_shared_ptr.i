%include <shared_ptr.i>

// Set SHARED_PTR_DISOWN to $disown if required, for example
// #define SHARED_PTR_DISOWN $disown
#if !defined(SHARED_PTR_DISOWN)
#define SHARED_PTR_DISOWN 0
#endif

%fragment("SWIG_null_deleter_python", "header", fragment="SWIG_null_deleter") {
%#define SWIG_NO_NULL_DELETER_SWIG_BUILTIN_INIT
}

// Language specific macro implementing all the customisations for handling the smart pointer
%define SWIG_SHARED_PTR_TYPEMAPS(CONST, TYPE...)

// %naturalvar is as documented for member variables
%naturalvar TYPE;
%naturalvar SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE >;

// destructor wrapper customisation
%feature("unref") TYPE
  %{(void)arg1;
    delete reinterpret_cast< SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< TYPE > * >(self);%}

// Typemap customisations...

// plain value
%typemap(in) CONST TYPE (void *argp, int res = 0) {
  swig_ruby_owntype newmem = {0, 0};
  res = SWIG_ConvertPtrAndOwn($input, &argp, $descriptor(SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< TYPE > *), %convertptr_flags, &newmem);
  if (!SWIG_IsOK(res)) {
    %argument_fail(res, "$type", $symname, $argnum);
  }
  if (!argp) {
    %argument_nullref("$type", $symname, $argnum);
  } else {
    $1 = *(%reinterpret_cast(argp, SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE > *)->get());
    if (newmem.own & SWIG_CAST_NEW_MEMORY) delete %reinterpret_cast(argp, SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE > *);
  }
}
%typemap(out) CONST TYPE {
  SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE > *smartresult = new SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE >(new $1_ltype(($1_ltype &)$1));
  %set_output(SWIG_NewPointerObj(%as_voidptr(smartresult), $descriptor(SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< TYPE > *), SWIG_POINTER_OWN));
}

%typemap(varin) CONST TYPE {
  void *argp = 0;
  swig_ruby_owntype newmem = {0, 0};
  int res = SWIG_ConvertPtrAndOwn($input, &argp, $descriptor(SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< TYPE > *), %convertptr_flags, &newmem);
  if (!SWIG_IsOK(res)) {
    %variable_fail(res, "$type", "$name");
  }
  if (!argp) {
    %variable_nullref("$type", "$name");
  } else {
    $1 = *(%reinterpret_cast(argp, SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE > *)->get());
    if (newmem.own & SWIG_CAST_NEW_MEMORY) delete %reinterpret_cast(argp, SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE > *);
  }
}
%typemap(varout) CONST TYPE {
  SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE > *smartresult = new SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE >(new $1_ltype(($1_ltype &)$1));
  %set_varoutput(SWIG_NewPointerObj(%as_voidptr(smartresult), $descriptor(SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< TYPE > *), SWIG_POINTER_OWN));
}

%typemap(directorout,noblock=1) CONST TYPE (void *argp, int res = 0) {
  swig_ruby_owntype newmem = {0, 0};
  res = SWIG_ConvertPtrAndOwn($input, &argp, $descriptor(SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< TYPE > *), %convertptr_flags, &newmem);
  if (!SWIG_IsOK(res)) {
    %dirout_fail(res, "$type");
  }
  if (!argp) {
    %dirout_nullref("$type");
  } else {
    $result = *(%reinterpret_cast(argp, SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE > *)->get());
    if (newmem.own & SWIG_CAST_NEW_MEMORY) delete %reinterpret_cast(argp, SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE > *);
  }
}
%typemap(directorin,noblock=1) CONST TYPE {
  SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE > *smartresult = new SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE >(new $1_ltype(($1_ltype &)$1));
  $input = SWIG_NewPointerObj(%as_voidptr(smartresult), $descriptor(SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< TYPE > *), SWIG_POINTER_OWN | %newpointer_flags);
}

// plain pointer
// Note: $disown not implemented by default as it will lead to a memory leak of the shared_ptr instance
%typemap(in) CONST TYPE * (void  *argp = 0, int res = 0, SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE > tempshared, SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE > *smartarg = 0) {
  swig_ruby_owntype newmem = {0, 0};
  res = SWIG_ConvertPtrAndOwn($input, &argp, $descriptor(SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< TYPE > *), SHARED_PTR_DISOWN | %convertptr_flags, &newmem);
  if (!SWIG_IsOK(res)) {
    %argument_fail(res, "$type", $symname, $argnum);
  }
  if (newmem.own & SWIG_CAST_NEW_MEMORY) {
    tempshared = *%reinterpret_cast(argp, SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE > *);
    delete %reinterpret_cast(argp, SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE > *);
    $1 = %const_cast(tempshared.get(), $1_ltype);
  } else {
    smartarg = %reinterpret_cast(argp, SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE > *);
    $1 = %const_cast((smartarg ? smartarg->get() : 0), $1_ltype);
  }
}

%typemap(out, fragment="SWIG_null_deleter_python") CONST TYPE * {
  SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE > *smartresult = $1 ? new SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE >($1 SWIG_NO_NULL_DELETER_$owner) : 0;
  %set_output(SWIG_NewPointerObj(%as_voidptr(smartresult), $descriptor(SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< TYPE > *), $owner | SWIG_POINTER_OWN));
}

%typemap(varin) CONST TYPE * {
  void *argp = 0;
  swig_ruby_owntype newmem = {0, 0};
  int res = SWIG_ConvertPtrAndOwn($input, &argp, $descriptor(SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< TYPE > *), %convertptr_flags, &newmem);
  if (!SWIG_IsOK(res)) {
    %variable_fail(res, "$type", "$name");
  }
  SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE > tempshared;
  SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE > *smartarg = 0;
  if (newmem.own & SWIG_CAST_NEW_MEMORY) {
    tempshared = *%reinterpret_cast(argp, SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE > *);
    delete %reinterpret_cast(argp, SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE > *);
    $1 = %const_cast(tempshared.get(), $1_ltype);
  } else {
    smartarg = %reinterpret_cast(argp, SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE > *);
    $1 = %const_cast((smartarg ? smartarg->get() : 0), $1_ltype);
  }
}
%typemap(varout, fragment="SWIG_null_deleter_python") CONST TYPE * {
  SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE > *smartresult = $1 ? new SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE >($1 SWIG_NO_NULL_DELETER_0) : 0;
  %set_varoutput(SWIG_NewPointerObj(%as_voidptr(smartresult), $descriptor(SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< TYPE > *), SWIG_POINTER_OWN));
}

%typemap(directorin,noblock=1) CONST TYPE * %{
#error "directorin typemap for plain pointer not implemented"
%}
%typemap(directorout,noblock=1) CONST TYPE * %{
#error "directorout typemap for plain pointer not implemented"
%}

// plain reference
%typemap(in) CONST TYPE & (void  *argp = 0, int res = 0, SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE > tempshared) {
  swig_ruby_owntype newmem = {0, 0};
  res = SWIG_ConvertPtrAndOwn($input, &argp, $descriptor(SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< TYPE > *), %convertptr_flags, &newmem);
  if (!SWIG_IsOK(res)) {
    %argument_fail(res, "$type", $symname, $argnum);
  }
  if (!argp) { %argument_nullref("$type", $symname, $argnum); }
  if (newmem.own & SWIG_CAST_NEW_MEMORY) {
    tempshared = *%reinterpret_cast(argp, SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE > *);
    delete %reinterpret_cast(argp, SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE > *);
    $1 = %const_cast(tempshared.get(), $1_ltype);
  } else {
    $1 = %const_cast(%reinterpret_cast(argp, SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE > *)->get(), $1_ltype);
  }
}
%typemap(out, fragment="SWIG_null_deleter_python") CONST TYPE & {
  SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE > *smartresult = new SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE >($1 SWIG_NO_NULL_DELETER_$owner);
  %set_output(SWIG_NewPointerObj(%as_voidptr(smartresult), $descriptor(SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< TYPE > *), SWIG_POINTER_OWN));
}

%typemap(varin) CONST TYPE & {
  void *argp = 0;
  swig_ruby_owntype newmem = {0, 0};
  int res = SWIG_ConvertPtrAndOwn($input, &argp, $descriptor(SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< TYPE > *), %convertptr_flags, &newmem);
  if (!SWIG_IsOK(res)) {
    %variable_fail(res, "$type", "$name");
  }
  SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE > tempshared;
  if (!argp) {
    %variable_nullref("$type", "$name");
  }
  if (newmem.own & SWIG_CAST_NEW_MEMORY) {
    tempshared = *%reinterpret_cast(argp, SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE > *);
    delete %reinterpret_cast(argp, SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE > *);
    $1 = *%const_cast(tempshared.get(), $1_ltype);
  } else {
    $1 = *%const_cast(%reinterpret_cast(argp, SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE > *)->get(), $1_ltype);
  }
}
%typemap(varout, fragment="SWIG_null_deleter_python") CONST TYPE & {
  SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE > *smartresult = new SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE >(&$1 SWIG_NO_NULL_DELETER_0);
  %set_varoutput(SWIG_NewPointerObj(%as_voidptr(smartresult), $descriptor(SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< TYPE > *), SWIG_POINTER_OWN));
}

%typemap(directorin,noblock=1) CONST TYPE & %{
#error "directorin typemap for plain reference not implemented"
%}
%typemap(directorout,noblock=1) CONST TYPE & %{
#error "directorout typemap for plain reference not implemented"
%}

// plain pointer by reference
// Note: $disown not implemented by default as it will lead to a memory leak of the shared_ptr instance
%typemap(in) TYPE *CONST& (void  *argp = 0, int res = 0, $*1_ltype temp = 0, SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE > tempshared) {
  swig_ruby_owntype newmem = {0, 0};
  res = SWIG_ConvertPtrAndOwn($input, &argp, $descriptor(SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< TYPE > *), SHARED_PTR_DISOWN | %convertptr_flags, &newmem);
  if (!SWIG_IsOK(res)) {
    %argument_fail(res, "$type", $symname, $argnum);
  }
  if (newmem.own & SWIG_CAST_NEW_MEMORY) {
    tempshared = *%reinterpret_cast(argp, SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE > *);
    delete %reinterpret_cast(argp, SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE > *);
    temp = %const_cast(tempshared.get(), $*1_ltype);
  } else {
    temp = %const_cast(%reinterpret_cast(argp, SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE > *)->get(), $*1_ltype);
  }
  $1 = &temp;
}
%typemap(out, fragment="SWIG_null_deleter_python") TYPE *CONST& {
  SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE > *smartresult = new SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE >(*$1 SWIG_NO_NULL_DELETER_$owner);
  %set_output(SWIG_NewPointerObj(%as_voidptr(smartresult), $descriptor(SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< TYPE > *), SWIG_POINTER_OWN));
}

%typemap(varin) TYPE *CONST& %{
#error "varin typemap not implemented"
%}
%typemap(varout) TYPE *CONST& %{
#error "varout typemap not implemented"
%}

%typemap(directorin,noblock=1) TYPE *CONST& %{
#error "directorin typemap for plain pointer by reference not implemented"
%}
%typemap(directorout,noblock=1) TYPE *CONST& %{
#error "directorout typemap for plain pointer by reference not implemented"
%}

// shared_ptr by value
%typemap(in) SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE > (void *argp, int res = 0) {
  swig_ruby_owntype newmem = {0, 0};
  res = SWIG_ConvertPtrAndOwn($input, &argp, $descriptor(SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< TYPE > *), %convertptr_flags, &newmem);
  if (!SWIG_IsOK(res)) {
    %argument_fail(res, "$type", $symname, $argnum);
  }
  if (argp) $1 = *(%reinterpret_cast(argp, $&ltype));
  if (newmem.own & SWIG_CAST_NEW_MEMORY) delete %reinterpret_cast(argp, $&ltype);
}
%typemap(out) SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE > {
  SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE > *smartresult = $1 ? new SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE >($1) : 0;
  %set_output(SWIG_NewPointerObj(%as_voidptr(smartresult), $descriptor(SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< TYPE > *), SWIG_POINTER_OWN));
}

%typemap(varin) SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE > {
  swig_ruby_owntype newmem = {0, 0};
  void *argp = 0;
  int res = SWIG_ConvertPtrAndOwn($input, &argp, $descriptor(SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< TYPE > *), %convertptr_flags, &newmem);
  if (!SWIG_IsOK(res)) {
    %variable_fail(res, "$type", "$name");
  }
  $1 = argp ? *(%reinterpret_cast(argp, $&ltype)) : SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< TYPE >();
  if (newmem.own & SWIG_CAST_NEW_MEMORY) delete %reinterpret_cast(argp, $&ltype);
}
%typemap(varout) SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE > {
  SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE > *smartresult = $1 ? new SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE >($1) : 0;
  %set_varoutput(SWIG_NewPointerObj(%as_voidptr(smartresult), $descriptor(SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< TYPE > *), SWIG_POINTER_OWN));
}

%typemap(directorin,noblock=1) SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE > {
  if ($1) {
    SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE > *smartresult = new SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE >($1);
    $input = SWIG_NewPointerObj(%as_voidptr(smartresult), $descriptor(SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< TYPE > *), SWIG_POINTER_OWN | %newpointer_flags);
  } else {
    $input = Qnil;
  }
}
%typemap(directorout,noblock=1) SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE > (void * swig_argp, int swig_res = 0) {
  if (NIL_P($input)) {
    $result = $ltype();
  } else {
    swig_res = SWIG_ConvertPtr($input, &swig_argp, $descriptor(SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< TYPE > *), %convertptr_flags);
    if (!SWIG_IsOK(swig_res)) {
      %dirout_fail(swig_res,"$type");
    }
    $result = *(%reinterpret_cast(swig_argp, $&ltype));
  }
}

// shared_ptr by reference
%typemap(in) SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE > & (void *argp, int res = 0, $*1_ltype tempshared) {
  swig_ruby_owntype newmem = {0, 0};
  res = SWIG_ConvertPtrAndOwn($input, &argp, $descriptor(SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< TYPE > *), %convertptr_flags, &newmem);
  if (!SWIG_IsOK(res)) {
    %argument_fail(res, "$type", $symname, $argnum);
  }
  if (newmem.own & SWIG_CAST_NEW_MEMORY) {
    if (argp) tempshared = *%reinterpret_cast(argp, $ltype);
    delete %reinterpret_cast(argp, $ltype);
    $1 = &tempshared;
  } else {
    $1 = (argp) ? %reinterpret_cast(argp, $ltype) : &tempshared;
  }
}
%typemap(out) SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE > & {
  SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE > *smartresult = *$1 ? new SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE >(*$1) : 0;
  %set_output(SWIG_NewPointerObj(%as_voidptr(smartresult), $descriptor(SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< TYPE > *), SWIG_POINTER_OWN));
}

%typemap(varin) SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE > & %{
#error "varin typemap not implemented"
%}
%typemap(varout) SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE > & %{
#error "varout typemap not implemented"
%}

%typemap(directorin,noblock=1) SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE > & {
  if ($1) {
    $input = SWIG_NewPointerObj(%as_voidptr(&$1), $descriptor(SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< TYPE > *), %newpointer_flags);
  } else {
    $input = Qnil;
  }
}

// shared_ptr by pointer
%typemap(in) SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE > * (void *argp, int res = 0, $*1_ltype tempshared) {
  swig_ruby_owntype newmem = {0, 0};
  res = SWIG_ConvertPtrAndOwn($input, &argp, $descriptor(SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< TYPE > *), %convertptr_flags, &newmem);
  if (!SWIG_IsOK(res)) {
    %argument_fail(res, "$type", $symname, $argnum);
  }
  if (newmem.own & SWIG_CAST_NEW_MEMORY) {
    if (argp) tempshared = *%reinterpret_cast(argp, $ltype);
    delete %reinterpret_cast(argp, $ltype);
    $1 = &tempshared;
  } else {
    $1 = (argp) ? %reinterpret_cast(argp, $ltype) : &tempshared;
  }
}
%typemap(out) SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE > * {
  SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE > *smartresult = $1 && *$1 ? new SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE >(*$1) : 0;
  %set_output(SWIG_NewPointerObj(%as_voidptr(smartresult), $descriptor(SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< TYPE > *), SWIG_POINTER_OWN));
  if ($owner) delete $1;
}

%typemap(varin) SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE > * %{
#error "varin typemap not implemented"
%}
%typemap(varout) SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE > * %{
#error "varout typemap not implemented"
%}

%typemap(directorin,noblock=1) SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE > *, SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE > *const& {
  if ($1 && *$1) {
    $input = SWIG_NewPointerObj(%as_voidptr($1), $descriptor(SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< TYPE > *), %newpointer_flags);
  } else {
    $input = Qnil;
  }
}

// shared_ptr by pointer reference
%typemap(in) SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE > *& (void *argp, int res = 0, SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE > tempshared, $*1_ltype temp = 0) {
  swig_ruby_owntype newmem = {0, 0};
  res = SWIG_ConvertPtrAndOwn($input, &argp, $descriptor(SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< TYPE > *), %convertptr_flags, &newmem);
  if (!SWIG_IsOK(res)) {
    %argument_fail(res, "$type", $symname, $argnum);
  }
  if (argp) tempshared = *%reinterpret_cast(argp, $*ltype);
  if (newmem.own & SWIG_CAST_NEW_MEMORY) delete %reinterpret_cast(argp, $*ltype);
  temp = &tempshared;
  $1 = &temp;
}
%typemap(out) SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE > *& {
  SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE > *smartresult = *$1 && **$1 ? new SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE >(**$1) : 0;
  %set_output(SWIG_NewPointerObj(%as_voidptr(smartresult), $descriptor(SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< TYPE > *), SWIG_POINTER_OWN));
}

%typemap(varin) SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE > *& %{
#error "varin typemap not implemented"
%}
%typemap(varout) SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE > *& %{
#error "varout typemap not implemented"
%}

// Typecheck typemaps
// Note: SWIG_ConvertPtr with void ** parameter set to 0 instead of using SWIG_ConvertPtrAndOwn, so that the casting
// function is not called thereby avoiding a possible smart pointer copy constructor call when casting up the inheritance chain.
%typemap(typecheck,precedence=SWIG_TYPECHECK_POINTER,noblock=1)
                      TYPE CONST,
                      TYPE CONST &,
                      TYPE CONST *,
                      TYPE *CONST&,
                      SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE >,
                      SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE > &,
                      SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE > *,
                      SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE > *& {
  int res = SWIG_ConvertPtr($input, 0, $descriptor(SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< TYPE > *), 0);
  $1 = SWIG_CheckState(res);
}


// various missing typemaps - If ever used (unlikely) ensure compilation error rather than runtime bug
%typemap(in) CONST TYPE[], CONST TYPE[ANY], CONST TYPE (CLASS::*) %{
#error "typemaps for $1_type not available"
%}
%typemap(out) CONST TYPE[], CONST TYPE[ANY], CONST TYPE (CLASS::*) %{
#error "typemaps for $1_type not available"
%}


%template() SWIG_SHARED_PTR_QNAMESPACE::shared_ptr< CONST TYPE >;


%enddef
