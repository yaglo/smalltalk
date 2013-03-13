"
AppDelegate.st
RandomApp

Created by Stanislav Yaglo on 3/13/13.
Copyright (c) 2013 Stanislav Yaglo. All rights reserved.
"

NSObject subclass: #AppDelegate
    instanceVariableNames: 'textField window'
    classVariableNames: ''
    poolDictionaries: ''
    conforms: 'NSApplicationDelegate'
    category: 'RandomApp'
!

! AppDelegate methodsFor: 'NSNibAwaking' !

awakeFromNib
    | now |
    now := NSCalendarDate calendarDate.
    textField setObjectValue: now
! !

! AppDelegate methodsFor: 'actions' !

seed: sender
    "Seed the random number generator with the time"

    Random seed: NSCalendarDate calendarDate timeIntervalSince1970.
    textField setStringValue: 'Generator seeded'
!

generate: sender
    "Generate a number between 1 and 100 inclusive"

    | generated |
    generated := Random between: 1 and: 100.

    Foundation log: 'generated = ', generated.

    "Ask the text field to change what it is displaying"
    textField setIntegerValue: generated
! !