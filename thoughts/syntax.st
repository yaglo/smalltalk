"Created by Stanislav Yaglo on 3/13/13.
Copyright (c) 2013 Stanislav Yaglo. All rights reserved."

Object < #AppDelegate {
| @textField @window |

- awakeFromNib
    | now |
    now := NSCalendarDate calendarDate.
    textField setObjectValue: now

- seed: sender
    "Seed the random number generator with the time"

    Random seed: NSCalendarDate calendarDate timeIntervalSince1970.
    textField setStringValue: 'Generator seeded'

- generate: sender
    "Generate a number between 1 and 100 inclusive"

    | generated |
    generated := Random between: 1 and: 100.

    Transcript show: 'generated = ', generated printString.

    "Ask the text field to change what it is displaying"
    textField setIntegerValue: generated
}