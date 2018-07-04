## Refactor

- Refactor Calculator `parseArray` to remove do

## Bugs

- Period conks out if more than a year's worth of seconds and calcsPerSecond is less than 1

## Features

- Use haveibeenpwned API
- Add Bloom Filter module?
- Should output highest security level found

## Doing

- Main.setup should throw an error rather than returning a Maybe
- Tests should throw errors instead of returning a Maybe

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
- Remove Maybes from findLast?
    > Use NonEmpty for lists
