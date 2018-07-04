// for throwing errors to the outside world
var throwError = function (error) {
    throw error;
};

exports.unsafeThrow = throwError;
