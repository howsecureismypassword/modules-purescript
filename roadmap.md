## Refactor


## Bugs


## Features

- Use haveibeenpwned API
- Add Bloom Filter module?
- Should output highest security level found

## Doing

- Should throw an error if time comes back as Nothing in Main

## Done

- Import JSON using FFI
- Inject Periods dictionary into Periods module
- Remove safe from CharacterSet parsing
- Use BigInt for Periods
- Add checks module
    * [x] Add to Main
- Shouldn't convert things into lists every run - need to cache passed in lists
- Tidy up reduce in NamedNumber
    * [x] Shouldn't hard-code 2
    * [x] Tidy up code generally
- Use NonEmpty lists to throw errors/avoid maybes
- Main.setup should throw an error rather than returning a Maybe
- Remove Maybes from findLast?
    > Use NonEmpty for lists
- Period conks out if more than a year's worth of seconds and calcsPerSecond is less than 1
    > Store everything in yoctoseconds?
- Final output values need to be in JS native formats
