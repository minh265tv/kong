package = "verify-decoded-token"
version = "0.1-1"
supported_platforms = {"linux", "macosx"}
source = {
  url = "git://github.com/minhnq/verify-decoded-token",
  tag = "master"
}
description = {
  summary = "Kong plugin to authenticate requests using http services.",
  license = "MIT",
  detailed = [[
      Kong plugin to authenticate requests using http services.
  ]]
}
dependencies = {
}
build = {
  type = "builtin",
  modules = {
    ["kong.plugins.verify-decoded-token.handler"] = "src/handler.lua",
    ["kong.plugins.verify-decoded-token.schema"] = "src/schema.lua"
  }
}