--[[
--  web.lua
--  created by narate
--  created on 1-3-2014
--]]

local router = require "router"
local uri = string.lower(ngx.var.uri) -- string

function index()
  ngx.say("Welcome to openresty")
  ngx.exit(200)
end

function hello(params)
  if params then
    ngx.say("hello "..params.name)
  else
    ngx.say("hello world")
  end
  ngx.exit(200)
end

function read_body()
  -- to test this function
  -- $ curl 127.0.0.1:8080/body # return 403 page
  -- $ curl 127.0.0.1:8080/body -d "hello body" # return hello body
  if ngx.req.get_method() ~= "POST" then
    ngx.exit(403)
  end
  ngx.req.read_body()
  local data = ngx.req.get_body_data()
  if data then
    ngx.say(data)
  else
    ngx.say("no request body")
  end
  ngx.exit(200)
end

router.get("/", function() index() end)
router.get("/hello", function() hello() end)
router.get("/hello/:name", function(params) hello(params) end)
router.get("/body", function() read_body() end)

router.execute("get", uri)  -- router by uri
