exports.config = {
    calcs: 40e9,
    periods: require("../../dictionaries/periods"),
    namedNumbers: require("../../dictionaries/named-numbers"),
    characterSets: require("../../dictionaries/character-sets"),
    dictionary: require("../../dictionaries/top10k"),
    patterns: require("../../dictionaries/patterns"),
    checkMessages: require("../../dictionaries/checks"),
};

exports.dodgyPeriod = {
    singular: "blahtosecond",
    plural: "blahtoseconds",
    seconds: Infinity
};

var catchError = function (fn) {
    return function (arg) {
        try {
            fn(arg);
        } catch (e) {
            return e;
        }

        return "";
    };
};

exports.catchSetupError = catchError;
exports.catchTimeError = catchError;
