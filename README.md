# How Secure Is My Password?

These modules are written using [PureScript](http://www.purescript.org) and then transpiled into JavaScript. You **do not** need to know PureScript to use the built versions of the code as it functions as a standard JS library.

## Usage

Using ES6 modules:

```javascript
// import the hsimp-purescript module
import setup from "hsimp-purescript";

import language from "hsimp-purescript/language/english";
import characterSets from "hsimp-purescript/data/character-sets";
import common from "hsimp-purescript/data/common/top10k";
import patterns from "hsimp-purescript/data/patterns";

// create the hsimp function
// if passed valid config, setup will return a function
const hsimp = setup({
    // the number of calculations per second a computer can do
    calculationsPerSecond: 40e9,

    // whether to display named numbers
    namedNumbers: true,

    // a language file
    language,

    // different checks
    checks: {
        // character sets to check
        characterSets,

        // common passwords to check
        common,

        // patterns to check
        patterns,
    }
});

// to run
const result = hsimp("HowSecureIsMyPassword?");
```

You will get back an object with the following structure:

```javascript
{
    // how long it would take to crack the password as a human readable string
    time: "42 minutes",

    // the highest level of check (e.g. insecure, warning, notice - see below)
    level: "notice",

    // the checks - in level of importance
    checks: [
        {
            name: "Character Variety: No Symbols",
            message: "Your password only contains numbers and letters. Adding a symbol can make your password more secure. Don\'t forget you can often use spaces in passwords.",
            level: "notice",
        },
        // ...and so on
    ]
}
```

See `dist/test.js` for a fully working version of the code in Node.

### Levels

There are five levels:

- `insecure`: a really bad password, probably very common
- `warning`: might be ok, but things to be aware of
- `easter-egg`: they've found something silly
- `notice`: nothing major
- `achievement`: something to be proud of


## Building

To build the code you'll require [`spago`](https://github.com/spacchetti/spago). Then just run `make`.  However, the latest build should always be available in the `dist` directory.
