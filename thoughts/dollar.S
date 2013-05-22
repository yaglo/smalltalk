; ModuleID = 'dollar.m'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.7.4"

%0 = type opaque
%1 = type opaque
%2 = type opaque
%struct.NSConstantString = type { i32*, i32, i8*, i64 }
%struct._objc_cache = type opaque
%struct._class_t = type { %struct._class_t*, %struct._class_t*, %struct._objc_cache*, i8* (i8*, i8*)**, %struct._class_ro_t* }
%struct._class_ro_t = type { i32, i32, i32, i8*, i8*, %struct.__method_list_t*, %struct._objc_protocol_list*, %struct._ivar_list_t*, i8*, %struct._prop_list_t* }
%struct.__method_list_t = type { i32, i32, [0 x %struct._objc_method] }
%struct._objc_method = type { i8*, i8*, i8* }
%struct._objc_protocol_list = type { i64, [0 x %struct._protocol_t*] }
%struct._protocol_t = type { i8*, i8*, %struct._objc_protocol_list*, %struct.__method_list_t*, %struct.__method_list_t*, %struct.__method_list_t*, %struct.__method_list_t*, %struct._prop_list_t*, i32, i32, i8** }
%struct._prop_list_t = type { i32, i32, [0 x %struct._prop_t] }
%struct._prop_t = type { i8*, i8* }
%struct._ivar_list_t = type { i32, i32, [0 x %struct._ivar_t] }
%struct._ivar_t = type { i64*, i8*, i8*, i32, i32 }
%struct._message_ref_t = type { i8*, i8* }

@"OBJC_IVAR_$_$Object._latteObject" = global i64 8, section "__DATA, __objc_ivar", align 8
@__CFConstantStringClassReference = external global [0 x i32]
@.str = linker_private unnamed_addr constant [6 x i8] c"Hello\00", align 1
@_unnamed_cfstring_ = private constant %struct.NSConstantString { i32* getelementptr inbounds ([0 x i32]* @__CFConstantStringClassReference, i32 0, i32 0), i32 1992, i8* getelementptr inbounds ([6 x i8]* @.str, i32 0, i32 0), i64 5 }, section "__DATA,__cfstring"
@_objc_empty_cache = external global %struct._objc_cache
@_objc_empty_vtable = external global i8* (i8*, i8*)*
@"OBJC_METACLASS_$_NSObject" = external global %struct._class_t
@"\01L_OBJC_CLASS_NAME_" = internal global [8 x i8] c"$Object\00", section "__TEXT,__objc_classname,cstring_literals", align 1
@"\01l_OBJC_METACLASS_RO_$_$Object" = internal global %struct._class_ro_t { i32 1, i32 40, i32 40, i8* null, i8* getelementptr inbounds ([8 x i8]* @"\01L_OBJC_CLASS_NAME_", i32 0, i32 0), %struct.__method_list_t* null, %struct._objc_protocol_list* null, %struct._ivar_list_t* null, i8* null, %struct._prop_list_t* null }, section "__DATA, __objc_const", align 8
@"OBJC_METACLASS_$_$Object" = global %struct._class_t { %struct._class_t* @"OBJC_METACLASS_$_NSObject", %struct._class_t* @"OBJC_METACLASS_$_NSObject", %struct._objc_cache* @_objc_empty_cache, i8* (i8*, i8*)** @_objc_empty_vtable, %struct._class_ro_t* @"\01l_OBJC_METACLASS_RO_$_$Object" }, section "__DATA, __objc_data", align 8
@"OBJC_CLASS_$_NSObject" = external global %struct._class_t
@"\01L_OBJC_METH_VAR_NAME_" = internal global [11 x i8] c"$lattelize\00", section "__TEXT,__objc_methname,cstring_literals", align 1
@"\01L_OBJC_METH_VAR_TYPE_" = internal global [8 x i8] c"@16@0:8\00", section "__TEXT,__objc_methtype,cstring_literals", align 1
@"\01L_OBJC_METH_VAR_NAME_1" = internal global [6 x i8] c"hello\00", section "__TEXT,__objc_methname,cstring_literals", align 1
@"\01L_OBJC_METH_VAR_TYPE_2" = internal global [8 x i8] c"v16@0:8\00", section "__TEXT,__objc_methtype,cstring_literals", align 1
@"\01l_OBJC_$_INSTANCE_METHODS_$Object" = internal global { i32, i32, [2 x %struct._objc_method] } { i32 24, i32 2, [2 x %struct._objc_method] [%struct._objc_method { i8* getelementptr inbounds ([11 x i8]* @"\01L_OBJC_METH_VAR_NAME_", i32 0, i32 0), i8* getelementptr inbounds ([8 x i8]* @"\01L_OBJC_METH_VAR_TYPE_", i32 0, i32 0), i8* bitcast (i8* (%0*, i8*)* @"\01-[$Object $lattelize]" to i8*) }, %struct._objc_method { i8* getelementptr inbounds ([6 x i8]* @"\01L_OBJC_METH_VAR_NAME_1", i32 0, i32 0), i8* getelementptr inbounds ([8 x i8]* @"\01L_OBJC_METH_VAR_TYPE_2", i32 0, i32 0), i8* bitcast (void (%0*, i8*)* @"\01-[$Object hello]" to i8*) }] }, section "__DATA, __objc_const", align 8
@"\01L_OBJC_METH_VAR_NAME_3" = internal global [13 x i8] c"_latteObject\00", section "__TEXT,__objc_methname,cstring_literals", align 1
@"\01L_OBJC_METH_VAR_TYPE_4" = internal global [2 x i8] c"c\00", section "__TEXT,__objc_methtype,cstring_literals", align 1
@"\01l_OBJC_$_INSTANCE_VARIABLES_$Object" = internal global { i32, i32, [1 x %struct._ivar_t] } { i32 32, i32 1, [1 x %struct._ivar_t] [%struct._ivar_t { i64* @"OBJC_IVAR_$_$Object._latteObject", i8* getelementptr inbounds ([13 x i8]* @"\01L_OBJC_METH_VAR_NAME_3", i32 0, i32 0), i8* getelementptr inbounds ([2 x i8]* @"\01L_OBJC_METH_VAR_TYPE_4", i32 0, i32 0), i32 0, i32 1 }] }, section "__DATA, __objc_const", align 8
@"\01l_OBJC_CLASS_RO_$_$Object" = internal global %struct._class_ro_t { i32 0, i32 8, i32 9, i8* null, i8* getelementptr inbounds ([8 x i8]* @"\01L_OBJC_CLASS_NAME_", i32 0, i32 0), %struct.__method_list_t* bitcast ({ i32, i32, [2 x %struct._objc_method] }* @"\01l_OBJC_$_INSTANCE_METHODS_$Object" to %struct.__method_list_t*), %struct._objc_protocol_list* null, %struct._ivar_list_t* bitcast ({ i32, i32, [1 x %struct._ivar_t] }* @"\01l_OBJC_$_INSTANCE_VARIABLES_$Object" to %struct._ivar_list_t*), i8* null, %struct._prop_list_t* null }, section "__DATA, __objc_const", align 8
@"OBJC_CLASS_$_$Object" = global %struct._class_t { %struct._class_t* @"OBJC_METACLASS_$_$Object", %struct._class_t* @"OBJC_CLASS_$_NSObject", %struct._objc_cache* @_objc_empty_cache, i8* (i8*, i8*)** @_objc_empty_vtable, %struct._class_ro_t* @"\01l_OBJC_CLASS_RO_$_$Object" }, section "__DATA, __objc_data", align 8
@"\01L_OBJC_CLASSLIST_REFERENCES_$_" = internal global %struct._class_t* @"OBJC_CLASS_$_$Object", section "__DATA, __objc_classrefs, regular, no_dead_strip", align 8
@"\01L_OBJC_METH_VAR_NAME_5" = internal global [4 x i8] c"new\00", section "__TEXT,__objc_methname,cstring_literals", align 1
@"\01L_OBJC_SELECTOR_REFERENCES_" = internal global i8* getelementptr inbounds ([4 x i8]* @"\01L_OBJC_METH_VAR_NAME_5", i32 0, i32 0), section "__DATA, __objc_selrefs, literal_pointers, no_dead_strip"
@"\01L_OBJC_SELECTOR_REFERENCES_6" = internal global i8* getelementptr inbounds ([11 x i8]* @"\01L_OBJC_METH_VAR_NAME_", i32 0, i32 0), section "__DATA, __objc_selrefs, literal_pointers, no_dead_strip"
@"\01L_OBJC_SELECTOR_REFERENCES_7" = internal global i8* getelementptr inbounds ([6 x i8]* @"\01L_OBJC_METH_VAR_NAME_1", i32 0, i32 0), section "__DATA, __objc_selrefs, literal_pointers, no_dead_strip"
@"\01L_OBJC_CLASSLIST_REFERENCES_$_8" = internal global %struct._class_t* @"OBJC_CLASS_$_NSObject", section "__DATA, __objc_classrefs, regular, no_dead_strip", align 8
@"\01L_OBJC_METH_VAR_NAME_9" = internal global [6 x i8] c"alloc\00", section "__TEXT,__objc_methname,cstring_literals", align 1
@"\01l_objc_msgSend_fixup_alloc" = weak hidden global { i8* (i8*, %struct._message_ref_t*, ...)*, i8* } { i8* (i8*, %struct._message_ref_t*, ...)* @objc_msgSend_fixup, i8* getelementptr inbounds ([6 x i8]* @"\01L_OBJC_METH_VAR_NAME_9", i32 0, i32 0) }, section "__DATA, __objc_msgrefs, coalesced", align 16
@"\01L_OBJC_METH_VAR_NAME_10" = internal global [5 x i8] c"init\00", section "__TEXT,__objc_methname,cstring_literals", align 1
@"\01L_OBJC_SELECTOR_REFERENCES_11" = internal global i8* getelementptr inbounds ([5 x i8]* @"\01L_OBJC_METH_VAR_NAME_10", i32 0, i32 0), section "__DATA, __objc_selrefs, literal_pointers, no_dead_strip"
@.str12 = linker_private unnamed_addr constant [6 x i8] c"%d %d\00", align 1
@_unnamed_cfstring_13 = private constant %struct.NSConstantString { i32* getelementptr inbounds ([0 x i32]* @__CFConstantStringClassReference, i32 0, i32 0), i32 1992, i8* getelementptr inbounds ([6 x i8]* @.str12, i32 0, i32 0), i64 5 }, section "__DATA,__cfstring"
@"\01L_OBJC_LABEL_CLASS_$" = internal global [1 x i8*] [i8* bitcast (%struct._class_t* @"OBJC_CLASS_$_$Object" to i8*)], section "__DATA, __objc_classlist, regular, no_dead_strip", align 8
@"\01L_OBJC_IMAGE_INFO" = internal constant [2 x i32] [i32 0, i32 16], section "__DATA, __objc_imageinfo, regular, no_dead_strip"
@llvm.used = appending global [20 x i8*] [i8* getelementptr inbounds ([8 x i8]* @"\01L_OBJC_CLASS_NAME_", i32 0, i32 0), i8* getelementptr inbounds ([11 x i8]* @"\01L_OBJC_METH_VAR_NAME_", i32 0, i32 0), i8* getelementptr inbounds ([8 x i8]* @"\01L_OBJC_METH_VAR_TYPE_", i32 0, i32 0), i8* getelementptr inbounds ([6 x i8]* @"\01L_OBJC_METH_VAR_NAME_1", i32 0, i32 0), i8* getelementptr inbounds ([8 x i8]* @"\01L_OBJC_METH_VAR_TYPE_2", i32 0, i32 0), i8* bitcast ({ i32, i32, [2 x %struct._objc_method] }* @"\01l_OBJC_$_INSTANCE_METHODS_$Object" to i8*), i8* getelementptr inbounds ([13 x i8]* @"\01L_OBJC_METH_VAR_NAME_3", i32 0, i32 0), i8* getelementptr inbounds ([2 x i8]* @"\01L_OBJC_METH_VAR_TYPE_4", i32 0, i32 0), i8* bitcast ({ i32, i32, [1 x %struct._ivar_t] }* @"\01l_OBJC_$_INSTANCE_VARIABLES_$Object" to i8*), i8* bitcast (%struct._class_t** @"\01L_OBJC_CLASSLIST_REFERENCES_$_" to i8*), i8* getelementptr inbounds ([4 x i8]* @"\01L_OBJC_METH_VAR_NAME_5", i32 0, i32 0), i8* bitcast (i8** @"\01L_OBJC_SELECTOR_REFERENCES_" to i8*), i8* bitcast (i8** @"\01L_OBJC_SELECTOR_REFERENCES_6" to i8*), i8* bitcast (i8** @"\01L_OBJC_SELECTOR_REFERENCES_7" to i8*), i8* bitcast (%struct._class_t** @"\01L_OBJC_CLASSLIST_REFERENCES_$_8" to i8*), i8* getelementptr inbounds ([6 x i8]* @"\01L_OBJC_METH_VAR_NAME_9", i32 0, i32 0), i8* getelementptr inbounds ([5 x i8]* @"\01L_OBJC_METH_VAR_NAME_10", i32 0, i32 0), i8* bitcast (i8** @"\01L_OBJC_SELECTOR_REFERENCES_11" to i8*), i8* bitcast ([1 x i8*]* @"\01L_OBJC_LABEL_CLASS_$" to i8*), i8* bitcast ([2 x i32]* @"\01L_OBJC_IMAGE_INFO" to i8*)], section "llvm.metadata"

define internal i8* @"\01-[$Object $lattelize]"(%0* %self, i8* %_cmd) uwtable ssp {
  %1 = alloca %0*, align 8
  %2 = alloca i8*, align 8
  store %0* %self, %0** %1, align 8
  store i8* %_cmd, i8** %2, align 8
  %3 = load %0** %1, align 8
  %4 = load i64* @"OBJC_IVAR_$_$Object._latteObject"
  %5 = bitcast %0* %3 to i8*
  %6 = getelementptr inbounds i8* %5, i64 %4
  store i8 1, i8* %6
  %7 = load %0** %1, align 8
  %8 = bitcast %0* %7 to i8*
  ret i8* %8
}

define internal void @"\01-[$Object hello]"(%0* %self, i8* %_cmd) uwtable ssp {
  %1 = alloca %0*, align 8
  %2 = alloca i8*, align 8
  store %0* %self, %0** %1, align 8
  store i8* %_cmd, i8** %2, align 8
  call void (%1*, ...)* @NSLog(%1* bitcast (%struct.NSConstantString* @_unnamed_cfstring_ to %1*))
  ret void
}

declare void @NSLog(%1*, ...)

define signext i8 @ObjectIsLatteObject(i8* %object) nounwind uwtable ssp {
  %1 = alloca i8*, align 8
  store i8* %object, i8** %1, align 8
  %2 = load i8** %1, align 8
  %3 = bitcast i8* %2 to %0*
  %4 = load i64* @"OBJC_IVAR_$_$Object._latteObject"
  %5 = bitcast %0* %3 to i8*
  %6 = getelementptr inbounds i8* %5, i64 %4
  %7 = load i8* %6
  ret i8 %7
}

define i32 @main(i32 %argc, i8** %argv) uwtable ssp {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i8**, align 8
  %o = alloca %0*, align 8
  %nso = alloca %2*, align 8
  store i32 0, i32* %1
  store i32 %argc, i32* %2, align 4
  store i8** %argv, i8*** %3, align 8
  %4 = call i8* @objc_autoreleasePoolPush() nounwind
  %5 = load %struct._class_t** @"\01L_OBJC_CLASSLIST_REFERENCES_$_"
  %6 = load i8** @"\01L_OBJC_SELECTOR_REFERENCES_", !invariant.load !0
  %7 = bitcast %struct._class_t* %5 to i8*
  %8 = call i8* bitcast (i8* (i8*, i8*, ...)* @objc_msgSend to i8* (i8*, i8*)*)(i8* %7, i8* %6)
  %9 = bitcast i8* %8 to %0*
  %10 = load i8** @"\01L_OBJC_SELECTOR_REFERENCES_6", !invariant.load !0
  %11 = bitcast %0* %9 to i8*
  %12 = call i8* bitcast (i8* (i8*, i8*, ...)* @objc_msgSend to i8* (i8*, i8*)*)(i8* %11, i8* %10)
  %13 = bitcast i8* %12 to %0*
  store %0* %13, %0** %o, align 8
  %14 = load %0** %o, align 8
  %15 = load i8** @"\01L_OBJC_SELECTOR_REFERENCES_7", !invariant.load !0
  %16 = bitcast %0* %14 to i8*
  call void bitcast (i8* (i8*, i8*, ...)* @objc_msgSend to void (i8*, i8*)*)(i8* %16, i8* %15)
  %17 = load %struct._class_t** @"\01L_OBJC_CLASSLIST_REFERENCES_$_8"
  %18 = bitcast %struct._class_t* %17 to i8*
  %19 = load i8** getelementptr inbounds (%struct._message_ref_t* bitcast ({ i8* (i8*, %struct._message_ref_t*, ...)*, i8* }* @"\01l_objc_msgSend_fixup_alloc" to %struct._message_ref_t*), i32 0, i32 0)
  %20 = bitcast i8* %19 to i8* (i8*, %struct._message_ref_t*)*
  %21 = call i8* %20(i8* %18, %struct._message_ref_t* bitcast ({ i8* (i8*, %struct._message_ref_t*, ...)*, i8* }* @"\01l_objc_msgSend_fixup_alloc" to %struct._message_ref_t*))
  %22 = bitcast i8* %21 to %2*
  %23 = load i8** @"\01L_OBJC_SELECTOR_REFERENCES_11", !invariant.load !0
  %24 = bitcast %2* %22 to i8*
  %25 = call i8* bitcast (i8* (i8*, i8*, ...)* @objc_msgSend to i8* (i8*, i8*)*)(i8* %24, i8* %23)
  %26 = bitcast i8* %25 to %2*
  store %2* %26, %2** %nso, align 8
  %27 = load %0** %o, align 8
  %28 = bitcast %0* %27 to i8*
  %29 = call signext i8 @ObjectIsLatteObject(i8* %28)
  %30 = sext i8 %29 to i32
  %31 = load %2** %nso, align 8
  %32 = bitcast %2* %31 to i8*
  %33 = call signext i8 @ObjectIsLatteObject(i8* %32)
  %34 = sext i8 %33 to i32
  call void (%1*, ...)* @NSLog(%1* bitcast (%struct.NSConstantString* @_unnamed_cfstring_13 to %1*), i32 %30, i32 %34)
  call void @objc_autoreleasePoolPop(i8* %4) nounwind
  ret i32 0
}

declare i8* @objc_autoreleasePoolPush()

declare i8* @objc_msgSend(i8*, i8*, ...) nonlazybind

declare i8* @objc_msgSend_fixup(i8*, %struct._message_ref_t*, ...)

declare void @objc_autoreleasePoolPop(i8*)

!0 = metadata !{}
