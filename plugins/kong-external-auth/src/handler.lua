local BasePlugin = require "kong.plugins.base_plugin"
local http = require "resty.http"
local json = require('cjson')

local kong = kong

local ExternalAuthHandler = BasePlugin:extend()

function ExternalAuthHandler:new()
  ExternalAuthHandler.super.new(self, "external-auth")
end

function ExternalAuthHandler:access(conf)
  ExternalAuthHandler.super.access(self)

  local client = http.new()
  client:set_timeouts(conf.connect_timeout, conf.send_timeout, conf.read_timeout)
  local headers = {
    ["Content-Type"] = "application/json",
    Authorization = kong.request.get_header("Authorization")
  }
  local res, err = client:request_uri(conf.url, {
    method = conf.method,
    path = conf.path,
    query = kong.request.get_raw_query(),
    headers = headers,
    body = "method=" + kong.request.get_method() + "&path=" + kong.request.get_path()
  })

  if not res then
    return kong.response.exit(500, {message=err})
  end

  if res.status ~= 200 then
    return kong.response.exit(401, json.decode(res.body))
  end
end

ExternalAuthHandler.PRIORITY = 900
ExternalAuthHandler.VERSION = "0.2.0"

return ExternalAuthHandler
