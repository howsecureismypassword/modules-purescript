## Refactor

- findLast can't ever return Nothing, so should use different method to keep track of progress
- Tidy up reduce in NamedNumber
    * [ ] Shouldn't hard-code 2
    * [ ] Tidy up code generally
- Shouldn't convert things into lists every run - need to cache passed in lists

## Bugs

- Period conks out if more than a year's worth of seconds and calcsPerSecond is less than 1

## Features

- Use haveibeenpwned API
- Add Bloom Filter module?

## Doing


## Done

- Import JSON using FFI
- Inject Periods dictionary into Periods module
- Remove safe from CharacterSet parsing
- Use BigInt for Periods
- Add checks module
    * [x] Add to Main
