exports.configF = {
    calculationsPerSecond: 40e9,
    namedNumbers: true,
    language: require("../../language/english"),
    checks: {
        characterSets: require("../../data/character-sets"),
        common: require("../../data/common/top10k"),
        patterns: require("../../data/patterns")
    }
};
