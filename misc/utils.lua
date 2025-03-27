MP.UTILS = {}

-- Credit to Henrik Ilgen (https://stackoverflow.com/a/6081639)
function MP.UTILS.serialize_table(val, name, skipnewlines, depth)
	skipnewlines = skipnewlines or false
	depth = depth or 0

	local tmp = string.rep(" ", depth)

	if name then
		tmp = tmp .. name .. " = "
	end

	if type(val) == "table" then
		tmp = tmp .. "{" .. (not skipnewlines and "\n" or "")

		for k, v in pairs(val) do
			tmp = tmp
				.. Utils.serialize_table(v, k, skipnewlines, depth + 1)
				.. ","
				.. (not skipnewlines and "\n" or "")
		end

		tmp = tmp .. string.rep(" ", depth) .. "}"
	elseif type(val) == "number" then
		tmp = tmp .. tostring(val)
	elseif type(val) == "string" then
		tmp = tmp .. string.format("%q", val)
	elseif type(val) == "boolean" then
		tmp = tmp .. (val and "true" or "false")
	else
		tmp = tmp .. '"[inserializeable datatype:' .. type(val) .. ']"'
	end

	return tmp
end

-- Credit to Steamo (https://github.com/Steamopollys/Steamodded/blob/main/core/core.lua)
function MP.UTILS.wrapText(text, maxChars)
	local wrappedText = ""
	local currentLineLength = 0

	for word in text:gmatch("%S+") do
		if currentLineLength + #word <= maxChars then
			wrappedText = wrappedText .. word .. " "
			currentLineLength = currentLineLength + #word + 1
		else
			wrappedText = wrappedText .. "\n" .. word .. " "
			currentLineLength = #word + 1
		end
	end

	return wrappedText
end

function MP.UTILS.save_username(text)
	MP.ACTIONS.set_username(text)
	SMODS.Mods["NanoMultiplayer"].config.username = text
end

function MP.UTILS.get_username()
	return SMODS.Mods["NanoMultiplayer"].config.username
end

function MP.UTILS.string_split(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t = {}
	for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
		table.insert(t, str)
	end
	return t
end

function MP.UTILS.copy_to_clipboard(text)
	if G.F_LOCAL_CLIPBOARD then
		G.CLIPBOARD = text
	else
		love.system.setClipboardText(text)
	end
end

function MP.UTILS.get_from_clipboard()
	if G.F_LOCAL_CLIPBOARD then
		return G.F_LOCAL_CLIPBOARD
	else
		return love.system.getClipboardText()
	end
end

function MP.UTILS.overlay_message(message)
	G.SETTINGS.paused = true
	local message_table = MP.UTILS.string_split(message, "\n")
	local message_ui = {
		{
			n = G.UIT.R,
			config = {
				padding = 0.2,
				align = "cm",
			},
			nodes = {
				{
					n = G.UIT.T,
					config = {
						scale = 0.8,
						shadow = true,
						text = "MULTIPLAYER",
						colour = G.C.UI.TEXT_LIGHT,
					},
				},
			},
		},
	}

	for _, v in ipairs(message_table) do
		table.insert(message_ui, {
			n = G.UIT.R,
			config = {
				padding = 0.1,
				align = "cm",
			},
			nodes = {
				{
					n = G.UIT.T,
					config = {
						scale = 0.6,
						shadow = true,
						text = v,
						colour = G.C.UI.TEXT_LIGHT,
					},
				},
			},
		})
	end

	G.FUNCS.overlay_menu({
		definition = create_UIBox_generic_options({
			contents = {
				{
					n = G.UIT.C,
					config = {
						padding = 0.2,
						align = "cm",
					},
					nodes = message_ui,
				},
			},
		}),
	})
end

function MP.UTILS.get_joker(key)
	if not G.jokers or not G.jokers.cards then
		return nil
	end
	for i = 1, #G.jokers.cards do
		if G.jokers.cards[i].ability.name == key then
			return G.jokers.cards[i]
		end
	end
	return nil
end

function MP.UTILS.get_phantom_joker(key)
	if not MP.shared or not MP.shared.cards then
		return nil
	end
	for i = 1, #MP.shared.cards do
		if
			MP.shared.cards[i].ability.name == key
			and MP.shared.cards[i].edition
			and MP.shared.cards[i].edition.type == "mp_phantom"
		then
			return MP.shared.cards[i]
		end
	end
	return nil
end

function MP.UTILS.run_for_each_joker(key, func)
	if not G.jokers or not G.jokers.cards then
		return
	end
	for i = 1, #G.jokers.cards do
		if G.jokers.cards[i].ability.name == key then
			func(G.jokers.cards[i])
		end
	end
end

function MP.UTILS.run_for_each_phantom_joker(key, func)
	if not MP.shared or not MP.shared.cards then
		return
	end
	for i = 1, #MP.shared.cards do
		if MP.shared.cards[i].ability.name == key then
			func(MP.shared.cards[i])
		end
	end
end

-- Credit to Cryptid devs for this function
local create_mod_badges_ref = SMODS.create_mod_badges
function SMODS.create_mod_badges(obj, badges)
	create_mod_badges_ref(obj, badges)
	if obj and obj.mp_credits then
		obj.mp_credits.art = obj.mp_credits.art or {}
		obj.mp_credits.idea = obj.mp_credits.idea or {}
		obj.mp_credits.code = obj.mp_credits.code or {}
		local function calc_scale_fac(text)
			local size = 0.9
			local font = G.LANG.font
			local max_text_width = 2 - 2 * 0.05 - 4 * 0.03 * size - 2 * 0.03
			local calced_text_width = 0
			-- Math reproduced from DynaText:update_text
			for _, c in utf8.chars(text) do
				local tx = font.FONT:getWidth(c) * (0.33 * size) * G.TILESCALE * font.FONTSCALE
					+ 2.7 * 1 * G.TILESCALE * font.FONTSCALE
				calced_text_width = calced_text_width + tx / (G.TILESIZE * G.TILESCALE)
			end
			local scale_fac = calced_text_width > max_text_width and max_text_width / calced_text_width or 1
			return scale_fac
		end
		if obj.mp_credits.art or obj.mp_credits.code or obj.mp_credits.idea then
			local scale_fac = {}
			local min_scale_fac = 1
			local strings = { "MULTIPLAYER" }
			for _, v in ipairs({ "art", "idea", "code" }) do
				if obj.mp_credits[v] then
					for i = 1, #obj.mp_credits[v] do
						strings[#strings + 1] =
							localize({ type = "variable", key = "a_mp_" .. v, vars = { obj.mp_credits[v][i] } })[1]
					end
				end
			end
			for i = 1, #strings do
				scale_fac[i] = calc_scale_fac(strings[i])
				min_scale_fac = math.min(min_scale_fac, scale_fac[i])
			end
			local ct = {}
			for i = 1, #strings do
				ct[i] = {
					string = strings[i],
				}
			end
			local mp_badge = {
				n = G.UIT.R,
				config = { align = "cm" },
				nodes = {
					{
						n = G.UIT.R,
						config = {
							align = "cm",
							colour = G.C.MULITPLAYER,
							r = 0.1,
							minw = 2 / min_scale_fac,
							minh = 0.36,
							emboss = 0.05,
							padding = 0.03 * 0.9,
						},
						nodes = {
							{ n = G.UIT.B, config = { h = 0.1, w = 0.03 } },
							{
								n = G.UIT.O,
								config = {
									object = DynaText({
										string = ct or "ERROR",
										colours = { obj.mp_credits and obj.mp_credits.text_colour or G.C.WHITE },
										silent = true,
										float = true,
										shadow = true,
										offset_y = -0.03,
										spacing = 1,
										scale = 0.33 * 0.9,
									}),
								},
							},
							{ n = G.UIT.B, config = { h = 0.1, w = 0.03 } },
						},
					},
				},
			}
			local function eq_col(x, y)
				for i = 1, 4 do
					if x[1] ~= y[1] then
						return false
					end
				end
				return true
			end
			for i = 1, #badges do
				if eq_col(badges[i].nodes[1].config.colour, G.C.MULITPLAYER) then
					badges[i].nodes[1].nodes[2].config.object:remove()
					badges[i] = mp_badge
					break
				end
			end
		end
	end
end

function add_nemesis_info(info_queue)
	if MP.LOBBY.code then
		info_queue[#info_queue + 1] = {
			set = "Other",
			key = "current_nemesis",
			vars = { MP.LOBBY.enemy_id and MP.LOBBY.players[MP.LOBBY.enemy_id] and MP.LOBBY.players[MP.LOBBY.enemy_id].username or "No one" },
		}
	end
end

function MP.UTILS.get_host_id()
	for id, player in pairs(MP.LOBBY.players) do
		if player.is_host then
			return player.id
		end
	end

	-- This shouldn't happen
	return nil
end

function MP.UTILS.shallow_copy(t)
	local copy = {}
	for k, v in pairs(t) do
		copy[k] = v
	end
	return copy
end

function MP.UTILS.string_to_table(str, pair_seperator, key_value_seperator)
	local tbl = {}
	for part in string.gmatch(str, "([^"..pair_seperator.."]+)") do
		local key, value = string.match(part, "([^"..key_value_seperator.."]+)"..key_value_seperator.."(.+)")
		if key and value then
			tbl[key] = value
		end
	end
	return tbl
end

-- Turn any characters necessary for parsing into a special sequence
function MP.UTILS.preProcessStringForNetwork(str)
	local processed_str = str

	-- Seperated each call for readability's sake
	processed_str = string.gsub(processed_str, ",", "{a}") -- Needed to seperate action values
	processed_str = string.gsub(processed_str, ":", "{b}") -- Needed to parse action values

	processed_str = string.gsub(processed_str, "|", "{c}") -- Needed to seperate sub-list entries
	processed_str = string.gsub(processed_str, "-", "{d}") -- Needed to seperate sub-list entry values
	processed_str = string.gsub(processed_str, ">", "{e}") -- Needed to parse sub-list entry values

	return processed_str
end

-- Turn any characters that were needed for parsing back into their original characters
function MP.UTILS.postProcessStringFromNetwork(str)
	local processed_str = str

	-- Seperated each call for readability's sake
	processed_str = string.gsub(processed_str, "{a}", ",") -- Needed to seperate action values
	processed_str = string.gsub(processed_str, "{b}", ":") -- Needed to parse action values

	processed_str = string.gsub(processed_str, "{c}", "|") -- Needed to seperate sub-list entries
	processed_str = string.gsub(processed_str, "{d}", "-") -- Needed to seperate sub-list entry values
	processed_str = string.gsub(processed_str, "{e}", ">") -- Needed to parse sub-list entry values

	return processed_str
end

-- Creates an array of integers containing the range of numbers between and including min and max, using step as an increment. (Won't include max if step skips it)
function MP.UTILS.init_increment_array(min, max, step)
	local range_array = {}
	for i = min, max, step do
		table.insert(range_array, i)
	end
	return range_array
end

-- Creates an array of integers containing the range of numbers between and including the min and max
function MP.UTILS.init_range_array(min, max)
	return MP.UTILS.init_increment_array(min, max, 1)
end