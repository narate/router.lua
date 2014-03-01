router.lua
==========

A very basic router for lua.

Features:

* Allows binding a method and a path to a function
* Parses parameters like `/app/services/:service_id`
* It's platform-agnostic. It has been tested with openresty.

Example of use
==============

    local router = require 'router'

    router.get('/hello',       function()       print('someone said hello') end)
    router.get('/hello/:name', function(params) print('hello ' .. params.name) end)

    router.post('/app/:id/comments', function(params) print('comment ' .. params.comment .. ' created on app ' .. params.id))

    router.execute('get',  '/hello')
    -- someone said hello

    router.execute('get',  '/hello/peter')
    -- hello peter

    router.execute('post', '/app/4/comments', { comment = 'fascinating'})
    -- comment fascinating created on app 4

Example of use with OpenResty
=============================
- nginx.conf
		...
		location / {
			content_by_lua_file	path/to/file.lua;
		}
		...
	
	> copy or link lib/router.lua to nginx working directory
- file.lua
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

License
=======

MIT licenxe

Specs
=====

This library uses [busted](http://olivinelabs.com/busted) for its specs. In order to run the specs, install `busted` and then do

    cd path/to/the/folder/where/the/spec/folder/is
    busted
