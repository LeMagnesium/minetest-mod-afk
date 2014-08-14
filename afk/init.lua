-- Minetest Mod afk

local S = nil
if intllib then
	S = intllib.Getter()
else
	S = function(s) return s end
end
print(S)

afk = {}
posafk = {}
posequi = {}
total = 1

core.register_chatcommand("afk", {
	description = S("Become afk"),
	privs = {},
	func = function(name, param)
		core.chat_send_all("* " .. name .. S(" is afk"))
		if not posequi[name] then
      afk[total] = name
      posafk[total] = minetest.get_player_by_name(name):getpos()
      posequi[name] = total
      total = total+1
    else
      afk[posequi[name]] = name
      posafk[posequi[name]] = minetest.get_player_by_name(name):getpos()
    end
	end,
})

core.register_chatcommand("re", {
	description = S("Came back"),
	privs = {},
	func = function(name, param)
		core.chat_send_all("* " .. name .. S(" is re!"))
		if total == 1 then return end
		afk[posequi[name]] = ""
		posafk[posequi[name]] = nil
	end,
})

minetest.register_on_leaveplayer(function(player)
  if not afk[posequi[player:get_player_name()]] then return end
  -- Test to prevent server crashing
  afk[posequi[player:get_player_name()]] = ""
end)

minetest.register_globalstep(function(dtime)
  i = 1
  if total == 1 then return end
  while i <= table.getn(afk) do
    if afk[i] ~= "" then
      default.player_set_animation(minetest.get_player_by_name(afk[i]), "sit", 20)
    end
    i = i+1
  end
end)