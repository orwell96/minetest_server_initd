
-- Minetest initd mod
-- counterpart of minetest service system (see initd.sh)

minetest.override_chatcommand("shutdown", {
	params = "[message]",
	func = function(name, param)		
		core.log("action", name .. " shuts down server")
		core.chat_send_all("*** Server shutting down (operator request).")
		
		local filen = minetest.get_worldpath() .. DIR_DELIM .. minetest.settings:get("initd_loop_file")
		core.log("action", "Deleting loop file: "..filen)
		os.remove(filen)

		core.request_shutdown("\nServer is shutting down.\n"..param:trim(), false, 0)
	end,
})
minetest.register_chatcommand("restart", {
	description = "Restart server",
	params = "[message]",
	privs = {ban=true},
	func = function(name, param)
		core.log("action", name .. " restarts server")
		core.chat_send_all("*** Server restarting (operator request).")
		core.request_shutdown("\nServer is restarting.\n"..param:trim(), true, 0)
	end,
})
minetest.register_chatcommand("crash", {
	description = "Crash server (for testing)",
	params = "[message]",
	privs = {server=true},
	func = function(name, param)
		core.log("action", name .. " crashes server")
		core.chat_send_all("*** Server crashing (operator request).")
		error("Operator-requested crash!")
	end,
})

if minetest.settings:get_bool("ask_reconnect_on_crash") then
	minetest.after(5, function()
		local filen = minetest.get_worldpath() .. DIR_DELIM .. minetest.settings:get("initd_loop_file")
		core.log("action", "Creating loop file: "..filen)
		local file = io.open(filen, "w")
		file:write(os.time())
		file:close()
	end)
end
