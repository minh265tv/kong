package = "verify-decode-token"
version = "0.1-1"
supported_platforms = {"linux", "macosx"}
source = {
  url = "git://github.com/minhnq/verify-decode-token",
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
    ["kong.plugins.verify-decode-token.handler"] = "src/handler.lua",
    ["kong.plugins.verify-decode-token.schema"] = "src/schema.lua"
  }
}