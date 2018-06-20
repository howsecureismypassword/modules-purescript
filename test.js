const main = require("./output/Main").main;

console.log(main({
    periods: require("./dictionaries/periods"),
    namedNumbers: require("./dictionaries/named-numbers"),
    characterSets: require("./dictionaries/character-sets"),
    calcs: 40e9,
})("HowSecureIsMyPassword?"))
