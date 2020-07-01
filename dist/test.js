const setup = require("./build.min");

const hsimp = setup({
    calculation: {
        calcs: 40e9,
        characterSets: require("../dictionaries/en-gb/character-sets"),
    },
    time: {
        periods: require("../dictionaries/en-gb/periods"),
        namedNumbers: require("../dictionaries/en-gb/named-numbers"),
        forever: "Forever",
        instantly: "Instantly",
    },
    checks: {
        dictionary: require("../dictionaries/en-gb/top10k"),
        patterns: require("../dictionaries/en-gb/patterns"),
        messages: require("../dictionaries/en-gb/checks"),
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
