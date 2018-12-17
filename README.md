# How Secure Is My Password?

These modules are written using [PureScript](http://www.purescript.org) and then transpiled into JavaScript. You **do not** need to know PureScript to use the built versions of the code as it functions as a standard JS library.

## Usage

Using ES6 modules:

```javascript
// import the hsimp-purescript module
import setup from "hsimp-purescript";

// the english version of the dictionaries
// feel free to use your own dictionaries, just make sure they have the same format
import characterSets from "hsimp-purescript/dictionaries/characters-sets";
import periods from "hsimp-purescript/dictionaries/periods";
import namedNumbers from "hsimp-purescript/dictionaries/named-numbers";
import dictionary from "hsimp-purescript/dictionaries/top10k";
import patterns from "hsimp-purescript/dictionaries/patterns";
import messages from "hsimp-purescript/dictionaries/checks";

// create the hsimp function
// if passed valid config, setup will return a function
const hsimp = setup({
    calculation: {
        // the number of calculations per-second
        calcs: 40e9,

        // characters sets to check
        characterSets,
    },
    time: {
        // a list of how long each period is in seconds
        periods,

        // a list of named numbers
        namedNumbers,

        // if the amount of time it will take gets ridiculous, what should be displayed
        forever: "Forever",

        // if the amount of time is basically immediate, what should be displayed
        instantly: "Instantly",
    },
    checks: {
        // a list of common passwords
        dictionary,

        // a list of patterns to check
        patterns,

        // the messages to display for each check
        messages,
    },
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

To build the code you'll require [`pulp`](https://www.npmjs.com/package/pulp). Then just run `make`.  However, the latest build should always be available in the `dist` directory.
