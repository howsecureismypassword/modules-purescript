// for throwing errors to the outside world
var throwError = function (error) {
    throw error;
};

exports.unsafeThrow = throwError;

// for supporting Symbol like behaviour
var Constant = function (n) {
    this.n = n;
};

// trick PureScript into thinking its a string
Constant.prototype.replace = function () {};

exports.forever = new Constant("FOREVER");
exports.instantly = new Constant("INSTANTLY");
exports.empty = new Constant("EMPTY");
