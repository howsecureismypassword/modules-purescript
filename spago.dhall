{ name = "how-secure-is-my-password"
, dependencies = [
  "spec",
  "nullable",
  "foreign",
  "bigints"
]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
