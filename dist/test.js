const setup = require("./build.min");

const hsimp = setup({
    calcs: 40e9,
    periods: require("../dictionaries/periods"),
    namedNumbers: require("../dictionaries/named-numbers"),
    characterSets: require("../dictionaries/character-sets"),
    checks: {
        dictionary: require("../dictionaries/top10k"),
        patterns: require("../dictionaries/patterns"),
        messages: require("../dictionaries/checks"),
    },
});

console.log(hsimp("HowSecureIsMyPassword?"));
console.log(hsimp("password1"));
console.log(hsimp("ab14&fj8hdj*"));

console.time();

for (let i = 0; i < 1000; i++) {
    hsimp("HowSecureIsMyPassword?");
}

console.timeEnd();
