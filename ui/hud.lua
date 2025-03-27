function G.FUNCS.lobby_info(e)
	G.SETTINGS.paused = true
	G.FUNCS.overlay_menu({
		definition = MP.UI.lobby_info(),
	})
end

function MP.UI.lobby_info()
	return create_UIBox_generic_options({
		contents = {
			create_tabs({
				tabs = {
					{
						label = MP.LOBBY.player_count .. " " .. localize("b_players"),
						chosen = true,
						tab_definition_function = MP.UI.create_UIBox_players,
					},
					MP.LOBBY.is_started and {
						label = localize("b_lobby_options"),
						chosen = false,
						tab_definition_function = MP.UI.create_UIBox_lobby_settings,
					} or nil
				},
				tab_h = 8,
				snap_to_nav = true,
			}),
		},
	})
end

function MP.UI.show_message(message)
	attention_text({
		scale = 0.8,
		text = message,
		hold = 5,
		align = "cm",
		offset = { x = 0, y = -1.5 },
		major = G.play,
	})
end

function MP.UI.create_UIBox_empty_row(height)
	return {
		n = G.UIT.R,
		config = {
			align = "cm",
			minh = height,
			colour = HEX("00000000"),
		}
	}
end

function MP.UI.show_enemy_location()
	local row_dollars_chips = G.HUD:get_UIE_by_ID("row_dollars_chips")
	if row_dollars_chips then
		row_dollars_chips.children[1]:remove()
		row_dollars_chips.children[1] = nil
		G.HUD:add_child({
			n = G.UIT.C,
			config = { align = "cm", padding = 0.1 },
			nodes = {
				{
					n = G.UIT.C,
					config = { align = "cm", minw = 1.3 },
					nodes = {
						{
							n = G.UIT.R,
							config = { align = "cm", padding = 0, maxw = 1.3 },
							nodes = {
								{
									n = G.UIT.T,
									config = {
										text = localize("ml_enemy_loc")[1],
										scale = 0.42,
										colour = G.C.UI.TEXT_LIGHT,
										shadow = true,
									},
								},
							},
						},
						{
							n = G.UIT.R,
							config = { align = "cm", padding = 0, maxw = 1.3 },
							nodes = {
								{
									n = G.UIT.T,
									config = {
										text = localize("ml_enemy_loc")[2],
										scale = 0.42,
										colour = G.C.UI.TEXT_LIGHT,
										shadow = true,
									},
								},
							},
						},
					},
				},
				{
					n = G.UIT.C,
					config = { align = "cm", minw = 3.3, minh = 0.7, r = 0.1, colour = G.C.DYN_UI.BOSS_DARK },
					nodes = {
						{
							n = G.UIT.T,
							config = {
								ref_table = MP.LOBBY.enemy_id and MP.GAME.enemies[MP.LOBBY.enemy_id] or {location = "None"},
								ref_value = "location",
								scale = 0.35,
								colour = G.C.WHITE,
								id = "chip_UI_count",
								shadow = true,
							},
						},
					},
				},
			},
		}, row_dollars_chips)
	end
end

function MP.UI.create_UIBox_players()
	local player_boxes = {}

	for k, v in pairs(MP.LOBBY.players) do
		table.insert(player_boxes, MP.UI.create_UIBox_player_row(k))
	end

	local t = {
		n = G.UIT.ROOT,
		config = { align = "cm", minw = 3, padding = 0.1, r = 0.1, colour = G.C.CLEAR },
		nodes = {
			{ n = G.UIT.R, config = { align = "cm", padding = 0.04 }, nodes = player_boxes },
		},
	}

	return t
end

function MP.UI.create_UIBox_mods_list(player_id)
	return {
		n = G.UIT.R,
		config = { align = "cm", colour = G.C.WHITE, r = 0.1 },
		nodes = {
			MP.LOBBY.players[player_id] and MP.LOBBY.players[player_id].hash and{
				n = G.UIT.C,
				config = { align = "cm" },
				nodes = MP.UI.hash_str_to_view(
					MP.LOBBY.players[player_id].hash,
					G.C.UI.TEXT_DARK
				),
			} or nil,
		},
	}
end

function MP.UI.create_UIBox_player_row(player_id)
	local player_name = MP.LOBBY.players[player_id].username
	if player_id == MP.LOBBY.player_id then
		player_name = player_name
	end

	-- Get shown values
	local note = "Enemy"
	local lives = nil
	local highest_score = nil

	if player_id == MP.LOBBY.player_id then
		note = "You"
	end

	if MP.LOBBY.is_started then
		if player_id == MP.LOBBY.player_id then
			lives = MP.GAME.lives
			highest_score = MP.GAME.highest_score
		elseif MP.GAME.enemies and MP.GAME.enemies[player_id] then
			lives = MP.GAME.enemies[player_id].lives
			highest_score = MP.GAME.enemies[player_id].highest_score
			note = lives > 0 and MP.GAME.enemies[player_id].location or "Dead"
		end
	elseif MP.LOBBY.players[player_id] and MP.LOBBY.players[player_id].is_host then
		note = note .. " (Host)"
	end

	-- Get inferred values
	local is_highest_scorer = to_big(highest_score) > to_big(0) and to_big(highest_score) >= MP.GAME.global_highest_score

	-- Get entry color
	local color = darken(G.C.JOKER_GREY, 0.1)
	if MP.LOBBY.is_started then
		if player_id == MP.LOBBY.player_id then
			color = G.C.BLUE
		elseif player_id == MP.LOBBY.enemy_id then
			color = darken(G.C.RED, 0.1)
		end

		if lives and lives <= 0 then
			color = darken(color, 0.5)
		end
	end

	return {
		n = G.UIT.R,
		config = {
			align = "cm",
			padding = 0.05,
			r = 0.1,
			colour = color,
			emboss = 0.05,
			hover = true,
			force_focus = true,
			on_demand_tooltip = {
				text = { localize("k_mods_list") },
				filler = { func = MP.UI.create_UIBox_mods_list, args = player_id },
			},
		},
		nodes = {
			{
				n = G.UIT.C,
				config = { align = "cl", padding = 0, minw = 5 },
				nodes = {
					{
						n = G.UIT.C,
						config = {
							align = "cm",
							padding = 0.02,
							r = 0.1,
							colour = G.C.RED,
							minw = 2,
							outline = 0.8,
							outline_colour = G.C.RED,
						},
						nodes = {
							{
								n = G.UIT.T,
								config = {
									text = tostring(MP.LOBBY.is_started and lives or MP.LOBBY.config.starting_lives) .. " " .. localize("k_lives"),
									scale = 0.4,
									colour = G.C.UI.TEXT_LIGHT,
								},
							},
						},
					},
					{
						n = G.UIT.C,
						config = { align = "cm", minw = 4, maxw = 4 },
						nodes = {
							{
								n = G.UIT.T,
								config = {
									text = " " .. player_name,
									scale = 0.45,
									colour = G.C.UI.TEXT_LIGHT,
									shadow = true,
								},
							},
						},
					},
				},
			},
			{
				n = G.UIT.C,
				config = { align = "cm", padding = 0.01, r = 0.1, colour = darken(G.C.JOKER_GREY, 0.6), minw = 4.5, maxw = 4.5  },
				nodes = {
					{ n = G.UIT.B, config = { w = 0.1, h = 0.01 } },
					{
						n = G.UIT.T,
						config = {
							text = note,
							scale = 0.45,
							colour = G.C.UI.TEXT_LIGHT,
						},
					},
					{ n = G.UIT.B, config = { w = 0.1, h = 0.01 } },
				},
			},
			{
				n = G.UIT.C,
				config = { align = "cm", padding = 0.05, colour = G.C.BLACK, r = 0.1 },
				nodes = {
					{
						n = G.UIT.C,
						config = { align = "cr", padding = 0.01, r = 0.1, colour = G.C.CHIPS, minw = 1.1 },
						nodes = {
							{
								n = G.UIT.T,
								config = {
									text = "???", -- Will be hands in the future
									scale = 0.45,
									colour = G.C.UI.TEXT_LIGHT,
								},
							},
							{ n = G.UIT.B, config = { w = 0.08, h = 0.01 } },
						},
					},
					{
						n = G.UIT.C,
						config = { align = "cl", padding = 0.01, r = 0.1, colour = G.C.MULT, minw = 1.1 },
						nodes = {
							{ n = G.UIT.B, config = { w = 0.08, h = 0.01 } },
							{
								n = G.UIT.T,
								config = {
									text = "???", -- Will be discards in the future
									scale = 0.45,
									colour = G.C.UI.TEXT_LIGHT,
								},
							},
						},
					},
				},
			},
			{
				n = G.UIT.C,
				config = { align = "cm", padding = 0.05, colour = is_highest_scorer and G.C.GOLD or G.C.L_BLACK, r = 0.1, minw = 1.5 },
				nodes = {
					{
						n = G.UIT.T,
						config = {
							text = number_format(MP.LOBBY.is_started and highest_score or 0, 1000000),
							scale = 0.45,
							colour = is_highest_scorer and G.C.UI.TEXT_LIGHT or G.C.FILTER,
							shadow = true,
						},
					},
				},
			},
				
			MP.LOBBY.is_host and MP.UI.Disableable_Button({
				id = "kick_" .. player_id,
				button = "lobby_kick_player",
				button_args = { player_id = player_id },
				colour = G.C.RED,
				label = { localize("b_kick") },
				scale = 0.45,
				minw = 1.3,
				minh = 0.45,
				
				col = true,
				enabled_ref_table = { enabled = player_id ~= MP.LOBBY.player_id },
				enabled_ref_value = "enabled",
			}) or nil,
		},
	}
end

function G.FUNCS.lobby_kick_player(e)
	local player_id = e.config.button_args.player_id
	if player_id and MP.LOBBY.is_host then
		MP.ACTIONS.kick_player(player_id)
	end
end

function MP.UI.create_UIBox_lobby_settings()
	return {
		n = G.UIT.ROOT,
		config = { align = "cm", minw = 4, padding = 0.5, r = 0.1, colour = G.C.CLEAR },
		nodes = {
			{ n = G.UIT.R, config = { align = "cm", padding = 0.04 }, nodes = {
				{
					n = G.UIT.R,
					config = { align = "cm", padding = 0.1, r = 0.1, colour = darken(G.C.JOKER_GREY, 0.2) },
					nodes = {
						MP.UI.create_UIBox_value_row("b_opts_player_diff_deck", MP.LOBBY.config.different_decks and "Yes" or "No"),
						MP.UI.create_UIBox_value_row("b_opts_diff_seeds", MP.LOBBY.config.different_seeds and "Yes" or "No"),
						MP.UI.create_UIBox_value_row("k_current_seed", MP.LOBBY.config.custom_seed == "random" and "Random" or MP.LOBBY.config.custom_seed),		
					}
				},
				MP.UI.create_UIBox_empty_row(0.45),
				{
					n = G.UIT.R,
					config = { align = "cm", padding = 0.1, r = 0.1, colour = darken(G.C.JOKER_GREY, 0.2) },
					nodes = {
						MP.UI.create_UIBox_value_row("b_opts_lives", MP.LOBBY.config.starting_lives),
						MP.UI.create_UIBox_value_row("b_opts_money_modifier", MP.LOBBY.config.starting_money_modifier),
						MP.UI.create_UIBox_value_row("b_opts_hand_modifier", MP.LOBBY.config.starting_hand_modifier),
						MP.UI.create_UIBox_value_row("b_opts_discard_modifier", MP.LOBBY.config.starting_discard_modifier),
					}
				}
			} },
		}
	}
end

function MP.UI.create_UIBox_value_row(name_loc_key, value)
	local name = localize(name_loc_key)
	if name == "ERROR" then
		name = name_loc_key
	end

	return {
		n = G.UIT.R,
		config = {
			align = "cm",
			padding = 0.05,
			r = 0.1,
			colour = G.C.JOKER_GREY,
			emboss = 0.05,
		},
		nodes = {
			{
				n = G.UIT.C,
				config = { align = "cr", padding = 0.1, r = 0.1, colour = G.C.CHIPS, minw = 6, maxw = 6 },
				nodes = {
					{
						n = G.UIT.T,
						config = {
							text = name,
							scale = 0.45,
							colour = G.C.UI.TEXT_LIGHT,
						},
					},
					{ n = G.UIT.B, config = { w = 0.1, h = 0.01 } },
				},
			},
			{
				n = G.UIT.C,
				config = { align = "cl", padding = 0.1, r = 0.1, colour = G.C.MULT, minw = 6, maxw = 6 },
				nodes = {
					{ n = G.UIT.B, config = { w = 0.1, h = 0.01 } },
					{
						n = G.UIT.T,
						config = {
							text = value,
							scale = 0.45,
							colour = G.C.UI.TEXT_LIGHT,
						},
					},
				},
			},
		}
	}
end

local ease_round_ref = ease_round
function ease_round(mod)
	if MP.LOBBY.code then
		return
	end
	ease_round_ref(mod)
end

function G.FUNCS.mp_timer_button(e)
	if not MP.GAME.timer_started and MP.GAME.ready_blind then
		MP.ACTIONS.start_ante_timer()
	end
end

function MP.UI.timer_hud()
	return {
		n = G.UIT.C,
		config = {
			align = "cm",
			padding = 0.05,
			minw = 1.45,
			minh = 1,
			colour = G.C.DYN_UI.BOSS_MAIN,
			emboss = 0.05,
			r = 0.1,
		},
		nodes = {
			{
				n = G.UIT.R,
				config = { align = "cm", maxw = 1.35 },
				nodes = {
					{
						n = G.UIT.T,
						config = {
							text = localize("k_timer"),
							minh = 0.33,
							scale = 0.34,
							colour = G.C.UI.TEXT_LIGHT,
							shadow = true,
						},
					},
				},
			},
			{
				n = G.UIT.R,
				config = {
					align = "cm",
					r = 0.1,
					minw = 1.2,
					colour = G.C.DYN_UI.BOSS_DARK,
					id = "row_round_text",
					func = "set_timer_box",
					button = "mp_timer_button",
				},
				nodes = {
					{
						n = G.UIT.O,
						config = {
							object = DynaText({
								string = { { ref_table = MP.GAME, ref_value = "timer" } },
								colours = { G.C.UI.TEXT_DARK },
								shadow = true,
								scale = 0.8,
							}),
							id = "timer_UI_count",
						},
					},
				},
			},
		},
	}
end

function G.FUNCS.set_timer_box(e)
	if MP.GAME.timer_started then
		e.config.colour = G.C.DYN_UI.BOSS_DARK
		e.children[1].config.object.colours = { G.C.IMPORTANT }
		return
	end
	if not MP.GAME.timer_started and MP.GAME.ready_blind then
		e.config.colour = G.C.IMPORTANT
		e.children[1].config.object.colours = { G.C.UI.TEXT_LIGHT }
		return
	end
	e.config.colour = G.C.DYN_UI.BOSS_DARK
	e.children[1].config.object.colours = { G.C.UI.TEXT_DARK }
end

MP.timer_event = Event({
	blockable = false,
	blocking = false,
	pause_force = true,
	no_delete = true,
	trigger = "after",
	delay = 1,
	timer = "UPTIME",
	func = function()
		if not MP.GAME.timer_started then
			return true
		end
		MP.GAME.timer = MP.GAME.timer - 1
		if MP.GAME.timer <= 0 then
			MP.GAME.timer = 0
			if not MP.GAME.ready_blind then
				MP.ACTIONS.fail_timer()
			end
			return true
		end
		MP.timer_event.start_timer = false
	end,
})
