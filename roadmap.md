## Refactor


## Bugs


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
- Should output highest security level found
- More tests for Main
    * [x] Check errors
- Should throw an error if time comes back as Nothing in Main
- Handles Instant and Infinity
    > Should handle Infinity and Instant results somehow
    * [x] Instant
    * [x] Infinity
- Use Symbol for Instantly/Forever
- Return `null` instead of empty strings from Main
- Should accept Checks dictionary and output message properly
- Should accept values for "Forever"/"Instantly"
    * [x] Add config
    * [x] Remove Constant stuff
- Use Internal modules to separate testing entry points
- Tidy up Main
    * [x] ParseConfig module
    * [x] Calculations config
