// lst_objc_msgReceive <- receives an Objective-C message
// lst_objc_msgSend <- sends an Objective-C message
// lst_msgSend <- sends a message
// 
// objc_msgSend

static const int ls_classVersion = 0xC0FFFEEE;

void
lst_isLatteObject (id object)
{
  return class_getVersion(object_getClass(self)) == ls_classVersion;
}

// Objective-C -> Latte
id
lst_msgReceive (id self, SEL _cmd, ...)
{
  if (lst_shouldBoxArguments(...))
    lst_msgDispatch(self, _cmd, lst_boxArguments(...));
  else
    lst_msgDispatch(self, _cmd, ...);
}

// Latte -> Latte
id
lst_msgDispatch(id self, SEL _cmd, ...)
{
  // http://www.mikeash.com/pyblog/friday-qa-2012-11-16-lets-build-objc_msgsend.html
}

// Latte -> Any
id
lst_msgSend (id self, SEL _cmd, ...)
{
  if (lst_isLatteObject(self))
    return lst_msgDispatch(self, _cmd, ...)
  else
    return lst_objc_msgSend(self, _cmd, ...);
}

// Latte -> Objective-C
id
lst_objc_msgSend (id self, SEL _cmd, ...)
{
  if (lst_shouldUnboxArguments(...))
    return objc_msgSend(self, _cmd, lst_unboxArguments(...));
  else
    return objc_msgSend(self, _cmd, ...);
}
	
