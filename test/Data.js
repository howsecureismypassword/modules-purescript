exports.configF = {
    calculation: {
        calcs: 40e9,
        characterSets: require("../../dictionaries/en-gb/character-sets"),
    },
    time: {
        periods: require("../../dictionaries/en-gb/periods"),
        namedNumbers: require("../../dictionaries/en-gb/named-numbers"),
        forever: "Forever",
        instantly: "Instantly",
    },
    output: {
        namedNumbers: true,
    },
    checks: {
        dictionary: require("../../dictionaries/en-gb/top10k"),
        patterns: require("../../dictionaries/en-gb/patterns"),
        messages: require("../../dictionaries/en-gb/checks"),
    },
};
