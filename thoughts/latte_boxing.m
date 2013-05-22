static int set_objc_value_from_latte_value(void *objc_value, id latte_value, const char *type_string)
{
    char type_char = get_type_char_from_type_string(type_string);
    switch (type_char) {
        case '@':
        {
            if (latte_value == L$UndefinedObject) {
                *((id *) objc_value) = nil;
                return NO;
            }
            *((id *) objc_value) = latte_value;
            return NO;
        }
        case 'I':
#ifndef __ppc__
        case 'S':
        case 'C':
#endif
        {
            if (latte_value == L$UndefinedObject) {
                *((unsigned int *) objc_value) = 0;
                return NO;
            }
            *((unsigned int *) objc_value) = [latte_value unsignedIntValue];
            return NO;
        }
#ifdef __ppc__
        case 'S':
        {
            if (latte_value == L$UndefinedObject) {
                *((unsigned short *) objc_value) = 0;
                return NO;
            }
            *((unsigned short *) objc_value) = [latte_value unsignedShortValue];
            return NO;
        }
        case 'C':
        {
            if (latte_value == L$UndefinedObject) {
                *((unsigned char *) objc_value) = 0;
                return NO;
            }
            *((unsigned char *) objc_value) = [latte_value unsignedCharValue];
            return NO;
        }
#endif
        case 'i':
#ifndef __ppc__
        case 's':
        case 'c':
#endif
        {
            if (latte_value == L$UndefinedObject) {
                *((int *) objc_value) = 0;
                return NO;
            }
            *((int *) objc_value) = [latte_value intValue];
            return NO;
        }
#ifdef __ppc__
        case 's':
        {
            if (latte_value == L$UndefinedObject) {
                *((short *) objc_value) = 0;
                return NO;
            }
            *((short *) objc_value) = [latte_value shortValue];
            return NO;
        }
        case 'c':
        {
            if (latte_value == L$UndefinedObject) {
                *((char *) objc_value) = 0;
                return NO;
            }
            *((char *) objc_value) = [latte_value charValue];
            return NO;
        }
#endif
        case 'L':
        {
            if (latte_value == L$UndefinedObject) {
                *((unsigned long *) objc_value) = 0;
                return NO;
            }
            *((unsigned long *) objc_value) = [latte_value unsignedLongValue];
            return NO;
        }
        case 'l':
        {
            if (latte_value == L$UndefinedObject) {
                *((long *) objc_value) = 0;
                return NO;
            }
            *((long *) objc_value) = [latte_value longValue];
            return NO;
        }
        case 'Q':
        {
            if (latte_value == L$UndefinedObject) {
                *((unsigned long long *) objc_value) = 0;
                return NO;
            }
            *((unsigned long long *) objc_value) = [latte_value unsignedLongLongValue];
            return NO;
        }
        case 'q':
        {
            if (latte_value == L$UndefinedObject) {
                *((long long *) objc_value) = 0;
                return NO;
            }
            *((long long *) objc_value) = [latte_value longLongValue];
            return NO;
        }
        case 'd':
        {
            *((double *) objc_value) = [latte_value doubleValue];
            return NO;
        }
        case 'f':
        {
            *((float *) objc_value) = (float) [latte_value doubleValue];
            return NO;
        }
        case 'v':
        {
            return NO;
        }
        case ':':
        {
            // selectors must be strings (symbols could be ok too...)
            if (!latte_value || (latte_value == L$UndefinedObject)) {
                *((SEL *) objc_value) = 0;
                return NO;
            }
            const char *selectorName = [latte_value cStringUsingEncoding:NSUTF8StringEncoding];
            if (selectorName) {
                *((SEL *) objc_value) = sel_registerName(selectorName);
                return NO;
            }
            else {
                NSLog(@"can't convert %@ to a selector", latte_value);
                return NO;
            }
        }
        case '{':
        {
            if (
                !strcmp(typeString, NSRECT_SIGNATURE0) ||
                !strcmp(typeString, NSRECT_SIGNATURE1) ||
                !strcmp(typeString, NSRECT_SIGNATURE2) ||
                !strcmp(typeString, CGRECT_SIGNATURE0) ||
                !strcmp(typeString, CGRECT_SIGNATURE1) ||
                !strcmp(typeString, CGRECT_SIGNATURE2)
                ) {
                NSRect *rect = (NSRect *) objc_value;
                rect->origin.x = (CGFloat) [[[latte_value origin] x] doubleValue];
                rect->origin.y = (CGFloat) [[[latte_value origin] y] doubleValue];
                rect->size.width = (CGFloat) [[[latte_value corner] x] doubleValue] - rect->origin.x;
                rect->size.height = (CGFloat) [[[latte_value corner] y] doubleValue] - rect->origin.y;
                //NSLog(@"nu->rect: %x %f %f %f %f", (void *) rect, rect->origin.x, rect->origin.y, rect->size.width, rect->size.height);
                return NO;
            }
            else if (
                     !strcmp(typeString, NSRANGE_SIGNATURE) ||
                     !strcmp(typeString, NSRANGE_SIGNATURE1)
                     ) {
                NSRange *range = (NSRange *) objc_value;
                range->location = [[latte_value start] intValue];
                range->length = [[latte_value extent] intValue];
                return NO;
            }
            else if (
                     !strcmp(typeString, NSSIZE_SIGNATURE0) ||
                     !strcmp(typeString, NSSIZE_SIGNATURE1) ||
                     !strcmp(typeString, NSSIZE_SIGNATURE2) ||
                     !strcmp(typeString, CGSIZE_SIGNATURE)
                     ) {
                NSSize *size = (NSSize *) objc_value;
                size->width = [[latte_value x] doubleValue];
                size->height =  [[latte_value y] doubleValue];
                return NO;
            }
            else if (
                     !strcmp(typeString, NSPOINT_SIGNATURE0) ||
                     !strcmp(typeString, NSPOINT_SIGNATURE1) ||
                     !strcmp(typeString, NSPOINT_SIGNATURE2) ||
                     !strcmp(typeString, CGPOINT_SIGNATURE)
                     ) {
                NSPoint *point = (NSPoint *) objc_value;
                point->x = [[latte_value x] doubleValue];
                point->y =  [[latte_value x] doubleValue];
                return NO;
            }
            else {
                NSLog(@"UNIMPLEMENTED: can't wrap structure of type %s", typeString);
                return NO;
            }
        }
            
        case '^':
        {
            if (!latte_value || (latte_value == L$UndefinedObject)) {
                *((char ***) objc_value) = NULL;
                return NO;
            }
            // pointers require some work.. and cleanup. This LEAKS.
            if (!strcmp(typeString, "^*")) {
                // array of strings, which requires an NSArray or NSNull (handled above)
                if (latte_objectIsKindOfClass(latte_value, [L$ArrayedCollection class])) {
                    NSUInteger array_size = [latte_value count];
                    char **array = (char **) malloc (array_size * sizeof(char *));
                    int i;
                    for (i = 0; i < array_size; i++) {
                        array[i] = strdup([[latte_value objectAtIndex:i] cStringUsingEncoding:NSUTF8StringEncoding]);
                    }
                    *((char ***) objc_value) = array;
                    return NO;
                }
                else {
                    NSLog(@"can't convert value of type %s to a pointer to strings", class_getName([latte_value class]));
                    *((char ***) objc_value) = NULL;
                    return NO;
                }
            }
            else if (!strcmp(typeString, "^@")) {
                if (latte_objectIsKindOfClass(latte_value, [L$Reference class])) {
                    *((id **) objc_value) = [latte_value pointerToReferencedObject];
                    return YES;
                }
            }
            else if (latte_objectIsKindOfClass(latte_value, [L$Pointer class])) {
                if ([latte_value pointer] == 0)
                    [latte_value allocateSpaceForTypeString:[NSString stringWithCString:typeString encoding:NSUTF8StringEncoding]];
                *((void **) objc_value) = [latte_value pointer];
                return NO;                        // don't ask the receiver to retain this, it's just a pointer
            }
            else {
                *((void **) objc_value) = latte_value;
                return NO;                        // don't ask the receiver to retain this, it isn't expecting an object
            }
        }
            
        case '*':
        {
            *((char **) objc_value) = (char *)[[latte_value stringValue] cStringUsingEncoding:NSUTF8StringEncoding];
            return NO;
        }
            
        case '#':
        {
            if (latte_objectIsKindOfClass(latte_value, [L$Class class])) {
                *((Class *)objc_value) = [latte_value wrappedClass];
                return NO;
            }
            else {
                NSLog(@"can't convert value of type %s to CLASS", class_getName([latte_value class]));
                *((id *) objc_value) = 0;
                return NO;
            }
        }
        default:
            NSLog(@"can't wrap argument of type %s", typeString);
    }
    return NO;
}

static id get_latte_value_from_objc_value(void *objc_value, const char *typeString)
{
    //NSLog(@"%s => VALUE", typeString);
    char typeChar = get_typeChar_from_typeString(typeString);
    switch(typeChar) {
        case 'v':
        {
            return L$UndefinedObject;
        }
        case '@':
        {
            id result = *((id *)objc_value);
            return result ? result : L$UndefinedObject;
        }
        case '#':
        {
            Class c = *((Class *)objc_value);
            return c ? [[[L$Class alloc] initWithClass:c] autorelease] : L$UndefinedObject;
        }
#ifndef __ppc__
        case 'c':
        {
            return [L$Character value:[NSNumber numberWithChar:*((char *)objc_value)]];
        }
        case 's':
        {
            return [NSNumber numberWithShort:*((short *)objc_value)];
        }
#else
        case 'c':
        case 's':
#endif
        case 'i':
        {
            return [NSNumber numberWithInt:*((int *)objc_value)];
        }
#ifndef __ppc__
        case 'C':
        {
            return [NSNumber numberWithUnsignedChar:*((unsigned char *)objc_value)];
        }
        case 'S':
        {
            return [NSNumber numberWithUnsignedShort:*((unsigned short *)objc_value)];
        }
#else
        case 'C':
        case 'S':
#endif
        case 'I':
        {
            return [NSNumber numberWithUnsignedInt:*((unsigned int *)objc_value)];
        }
        case 'l':
        {
            return [NSNumber numberWithLong:*((long *)objc_value)];
        }
        case 'L':
        {
            return [NSNumber numberWithUnsignedLong:*((unsigned long *)objc_value)];
        }
        case 'q':
        {
            return [NSNumber numberWithLongLong:*((long long *)objc_value)];
        }
        case 'Q':
        {
            return [NSNumber numberWithUnsignedLongLong:*((unsigned long long *)objc_value)];
        }
        case 'f':
        {
            return [NSNumber numberWithFloat:*((float *)objc_value)];
        }
        case 'd':
        {
            return [NSNumber numberWithDouble:*((double *)objc_value)];
        }
        case ':':
        {
            SEL sel = *((SEL *)objc_value);
            return [[NSString stringWithCString:sel_getName(sel) encoding:NSUTF8StringEncoding] retain];
        }
        case '{':
        {
            if (
                !strcmp(typeString, NSRECT_SIGNATURE0) ||
                !strcmp(typeString, NSRECT_SIGNATURE1) ||
                !strcmp(typeString, NSRECT_SIGNATURE2) ||
                !strcmp(typeString, CGRECT_SIGNATURE0) ||
                !strcmp(typeString, CGRECT_SIGNATURE1) ||
                !strcmp(typeString, CGRECT_SIGNATURE2)
                ) {
					return [Rectangle
						origin: [Point x: @(rect->origin.x) y: @(rect->origin.y)]
						extent: [Point x: @(rect->size.width) y: @(rect->size.height)]];
            }
            else if (
                     !strcmp(typeString, NSRANGE_SIGNATURE) ||
                     !strcmp(typeString, NSRANGE_SIGNATURE1)
                     ) {
				return [Interval from: @(range->location) to: @(range->location + range->length)];
            }
            else if (
                     !strcmp(typeString, NSPOINT_SIGNATURE0) ||
                     !strcmp(typeString, NSPOINT_SIGNATURE1) ||
                     !strcmp(typeString, NSPOINT_SIGNATURE2) ||
                     !strcmp(typeString, CGPOINT_SIGNATURE)
                     ) {
				return [Point x: @(point->x) y: @(point->y)];
            }
            else if (
                     !strcmp(typeString, NSSIZE_SIGNATURE0) ||
                     !strcmp(typeString, NSSIZE_SIGNATURE1) ||
                     !strcmp(typeString, NSSIZE_SIGNATURE2) ||
                     !strcmp(typeString, CGSIZE_SIGNATURE)
                     ) {
		 		return [Point x: @(size->width) y: @(size->height)];
            }
            else {
                NSLog(@"UNIMPLEMENTED: can't wrap structure of type %s", typeString);
            }
        }
        case '*':
        {
            return [NSString stringWithCString:*((char **)objc_value) encoding:NSUTF8StringEncoding];
        }
        case 'B':
        {
            if (*((unsigned int *)objc_value) == 0)
                return [NSNull null];
            else
                return [NSNumber numberWithInt:1];
        }
        case '^':
        {
            if (!strcmp(typeString, "^v")) {
                if (*((unsigned long *)objc_value) == 0)
                    return UndefinedObject;
                else {
					id pointer = [[Pointer new] autorelease];
					[pointer setPointer:*((void **)objc_value)];
                    [pointer setTypeString:[NSString stringWithCString:typeString encoding:NSUTF8StringEncoding]];
					return pointer;
                }
            }
            else if (!strcmp(typeString, "^@")) {
                id reference = [[Reference new] autorelease];
                [reference setPointer:*((id**)objc_value)];
                return reference;
            }
            // Certain pointer types are essentially just ids.
            // CGImageRef is one. As we find others, we can add them here.
            else if (!strcmp(typeString, "^{CGImage=}")) {
                id result = *((id *)objc_value);
                return result ? result : UndefinedObject;
            }
            else if (!strcmp(typeString, "^{CGColor=}")) {
                id result = *((id *)objc_value);
                return result ? result : UndefinedObject;
            }
            else {
                if (*((unsigned long *)objc_value) == 0)
                    return UndefinedObject;
                else {
					id pointer = [[Pointer new] autorelease];
					[pointer setPointer:*((void **)objc_value)];
                    [pointer setTypeString:[NSString stringWithCString:typeString encoding:NSUTF8StringEncoding]];
					return pointer;
                }
            }
            return UndefinedObject;
        }
        default:
            NSLog (@"UNIMPLEMENTED: unable to wrap object of type %s", typeString);
            return UndefinedObject;
    }
    
}
