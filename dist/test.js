const HSIMP = require("./build.min");

const hsimp = HSIMP.setup({
    calcs: 40e9,
    periods: require("../dictionaries/periods"),
    namedNumbers: require("../dictionaries/named-numbers"),
    characterSets: require("../dictionaries/character-sets"),
    dictionary: require("../dictionaries/top10k"),
    patterns: require("../dictionaries/patterns"),
});

console.log(hsimp("HowSecureIsMyPassword?"));
console.log(hsimp("password1"));

console.log(hsimp("HowSecureIsMyPassword?").checks[0].value === HSIMP.empty);
console.log(hsimp("password1").time === HSIMP.instantly);

console.time();

for (let i = 0; i < 1000; i++) {
    hsimp("HowSecureIsMyPassword?");
}

console.timeEnd();
