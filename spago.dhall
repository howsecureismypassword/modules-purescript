{ name = "how-secure-is-my-password"
, dependencies = [
  "spec",
  "nullable",
  "bigints"
]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
