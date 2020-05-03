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
				local potential_hax = {}
				local prob_not_clean = nil


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
						Slow_Peer(self:id())
						managers.chat:feed_system_message(1, self:name() .. " has been slowmotion because of using the mod: " .. mod.name)
						prob_not_clean = 1
					end
				end
			end

			if prob_not_clean then
				managers.chat:feed_system_message(1, self:name() .. " Move! Cheater!")
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
