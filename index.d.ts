interface IChecks {
    name: string;
    message: string;
    level: string;
}

export interface IResult {
    time: string;
    level: string;
    checks: IChecks[];
}

type returnFunction = (m: string | number) => IResult;

interface ICharacterSet {
    name: string;
    matches: string;
    value: value;
}

type CharacterSets = ICharacterSet[];

interface ICalculation {
    calcs: number;
    characterSets: CharacterSets;
}

interface IPeriod {
    singular: string;
    plural: string;
    seconds: number;
}

type Periods = IPeriod[];

interface INameNumber {
    name: string;
    value: number;
}

type NamedNumbers = INameNumber[];

interface ITime {
    periods: Periods;
    namedNumbers: NamedNumbers;
    forever: string;
    instantly: string;
}

type Dictionary = string[];

interface IPattern {
    level: string;
    id: string;
    regex: string;
}

type Patterns = IPattern[];

interface IMessage {
    id: string;
    name: string;
    message: string;
}

type Messages = IMessage[];

interface IChecks {
    dictionary: Dictionary;
    patterns: Patterns;
    messages: Messages;
}

export interface ISetupConfig {
    calculation: ICalculation;
    time: ITime;
    checks: IChecks;
}

export default function setup(config: ISetupConfig): returnFunction;
