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
    ["Content-Type"] = "application/json"
  }
  local body = {
    token = kong.request.get_header("Authorization")
  }
  local res, err = client:request_uri(conf.url, {
    method = conf.method,
    path = conf.path,
    headers = headers,
    body = json.encode(body)
  })

  if not res then
    return kong.response.exit(500, {message=err})
  end

  if res.status == 200 then
    kong.service.request.set_header('x-token-data', json.encode(json.decode(res.body).data))
  else
    return kong.response.exit(401, json.decode(res.body))
  end
end

ExternalAuthHandler.PRIORITY = 900
ExternalAuthHandler.VERSION = "0.2.0"

return ExternalAuthHandler
