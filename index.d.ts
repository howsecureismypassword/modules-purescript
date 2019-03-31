interface IChecks {
    name: string;
    message: string;
    level: string;
}

interface IResult {
    time: string;
    level: string;
    checks: IChecks[];
}

type returnFunction = (m: string | number) => IResult;

// TODO config Type
export default function setup(config: any): returnFunction;
