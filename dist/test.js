const setup = require("./build.min");

const config = {
    calculationsPerSecond: 40e9,
    namedNumbers: true,
    language: require("../language/english"),
    checks: {
        characterSets: require("../data/character-sets"),
        common: require("../data/common/top10k"),
        patterns: require("../data/patterns")
    }
};

let hsimp = setup(config);

console.log(hsimp("HowSecureIsMyPassword?"));
console.log(hsimp("password1"));
console.log(hsimp("ab14&fj8hdj*"));

config.namedNumbers = false;
hsimp = setup(config);

console.log(hsimp("HowSecureIsMyPassword?"));
console.log(hsimp("password1"));
console.log(hsimp("ab14&fj8hdj*"));

console.time();

for (let i = 0; i < 1000; i++) {
    hsimp("HowSecureIsMyPassword?");
}

console.timeEnd();
