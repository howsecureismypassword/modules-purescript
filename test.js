const main = require("./output/Main").main;

console.log(main({
    calcs: 40e9,
    periods: require("./dictionaries/periods"),
    namedNumbers: require("./dictionaries/named-numbers"),
    characterSets: require("./dictionaries/character-sets"),
    dictionary: require("./dictionaries/top10k"),
    patterns: require("./dictionaries/patterns"),
})("HowSecureIsMyPassword?"))
