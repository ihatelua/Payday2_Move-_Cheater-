Hooks:PostHook(NetworkPeer, "set_ip_verified", "cheaterz_go_to_hell_haha", function(self, state)

	if not Network:is_server() then
		return
	end

	DelayedCalls:Add( "cheaterz_go_to_hell_d", 2, function()
		local user = Steam:user(self:ip())
		if user and user:rich_presence("is_modded") == "1" or self:is_modded() then
			managers.chat:feed_system_message(1, self:name() .. " HAS MODS! Checking...")
			for i, mod in ipairs(self:synced_mods()) do
				local mod_mini = string.lower(mod.name)	
				local kick_on = {}
				local potential_hax = {}
				local prob_not_clean = nil

				kick_on = {
					"pirate perfection",
					"p3dhack",
					"p3dhack free",
					"p3dunlocker",
					"arsium's weapons rebalance recoil",
					"overkill mod",
					"selective dlc unlocker",
					"the great skin unlock",
					"beyond cheats"
				}

				for _, v in pairs(kick_on) do
					if mod_mini == v then
						local identifier = "cheater_banned_" .. tostring(self:id())
						Slow_Peer(self:id())
						managers.chat:feed_system_message(1, self:name() .. " has been slowmotion because of using the mod: " .. mod.name)
						return
					end
				end

				potential_hax = {
					"pirate",
					"p3d",
					"hack",
					"cheat",
					"unlocker",
					"unlock",
					"dlc",
					"trainer",
					"silent assassin",
					"carry stacker",
					"god",
					"x-ray",
					"dlc unlocker",
					"skin unlocker",
					"mvp"
				}

				for k, pc in pairs(potential_hax) do
					if string.find(mod_mini, pc) then
						log("found something!")
						managers.chat:feed_system_message(1, self:name() .. " is using a mod that can be a potential cheating mod: " .. mod.name)
						prob_not_clean = 1
					end
				end
			end

			if prob_not_clean then
				managers.chat:feed_system_message(1, self:name() .. " has a warning... Check his mods/profile manually to be sure.")
			else
				managers.chat:feed_system_message(1, self:name() .. " seems to be clean.")
			end
		else
			managers.chat:feed_system_message(1, self:name() .. " doesn't seem to have mods.")
		end
	end)
end)

function Slow_Peer(id)
	local peer = managers.network._session:peer(id)
	if peer then
		peer:send("start_timespeed_effect", "pause", "pausable", "player;game;game_animation", 0.05, 1, 3600, 1)
	end
end
if managers.network._session then
	local menu_options = {}
	for _, peer in pairs(managers.network:session():peers()) do
		if peer:rank() and peer:level() then
			menu_options[#menu_options+1] ={text = "(" .. peer:user_id() .. ") " .. peer:name(), data = peer:id(), callback = Slow_Peer}
		else
			menu_options[#menu_options+1] ={text = peer:name(), data = peer:id(), callback = Slow_Peer}
		end
	end
	menu_options[#menu_options+1] = {text = "Return", is_cancel_button = true}
	local menu = QuickMenu:new("Slow-mo", "Select who gets slow", menu_options)
	menu:Show()
end
