const Maybe = require("./output/Data.Maybe");

const Calculator = require("./output/Calculator");
const Period = require("./output/Period");
const NamedNumber = require("./output/NamedNumber");

const namedNumbers = require("./dictionaries/named-numbers");
const characterSets = require("./dictionaries/character-sets");
const periods = require("./dictionaries/periods");

const calcs = 40e9;

let possibilities = Calculator.calculate(characterSets)("HowSecureIsMyPassword?")
let time = Maybe.fromMaybe(null)(Period.period(periods)(calcs)(possibilities));

console.log(`${NamedNumber.namedNumber(namedNumbers)(time.value)} ${time.name}`);
