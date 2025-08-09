local act = require("wezterm").action

local kernel = io.popen("uname");
local action_key

if kernel == "Darwin" then
  action_key = "SUPER"
else
  action_key = "ALT"
end

M = {}

local function tmux_key_table(tmux_key)
	if type(tmux_key) == "table" then
		return tmux_key
	else
		return { key = tmux_key }
	end
end

M.cmd_key = function(key, action)
	return {
		mods = action_key,
		key = key,
		action = action,
	}
end

M.cmd_to_tmux = function(key, tmux_key)
	return M.cmd_key(
		key,
		act.Multiple({
			act.SendKey({ mods = "CTRL", key = "b" }),
			act.SendKey(tmux_key_table(tmux_key)),
		})
	)
end

return M
