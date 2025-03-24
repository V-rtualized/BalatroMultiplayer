local Disableable_Button = MP.UI.Disableable_Button
local Disableable_Toggle = MP.UI.Disableable_Toggle
local Disableable_Option_Cycle = MP.UI.Disableable_Option_Cycle

-- This needs to have a parameter because its a callback for inputs
local function send_lobby_options(value)
	MP.ACTIONS.lobby_options()
end

G.HUD_connection_status = nil

function G.UIDEF.get_connection_status_ui()
	return UIBox({
		definition = {
			n = G.UIT.ROOT,
			config = {
				align = "cm",
				colour = G.C.UI.TRANSPARENT_DARK,
			},
			nodes = {
				{
					n = G.UIT.T,
					config = {
						scale = 0.3,
						text = (MP.LOBBY.code and localize("k_in_lobby")) or (MP.LOBBY.connected and localize(
							"k_connected"
						)) or localize("k_warn_service"),
						colour = G.C.UI.TEXT_LIGHT,
					},
				},
			},
		},
		config = {
			align = "tri",
			bond = "Weak",
			offset = {
				x = 0,
				y = 0.9,
			},
			major = G.ROOM_ATTACH,
		},
	})
end

function G.UIDEF.create_UIBox_view_code()
	local var_495_0 = 0.75

	return (
		create_UIBox_generic_options({
			contents = {
				{
					n = G.UIT.R,
					config = {
						padding = 0,
						align = "cm",
					},
					nodes = {
						{
							n = G.UIT.R,
							config = {
								padding = 0.5,
								align = "cm",
							},
							nodes = {
								{
									n = G.UIT.T,
									config = {
										text = MP.LOBBY.code,
										shadow = true,
										scale = var_495_0 * 0.6,
										colour = G.C.UI.TEXT_LIGHT,
									},
								},
							},
						},
						{
							n = G.UIT.R,
							config = {
								padding = 0,
								align = "cm",
							},
							nodes = {
								UIBox_button({
									label = { localize("b_copy_clipboard") },
									colour = G.C.BLUE,
									button = "copy_to_clipboard",
									minw = 5,
								}),
							},
						},
					},
				},
			},
		})
	)
end

function G.UIDEF.create_UIBox_lobby_menu()
	local text_scale = 0.45
	local back = MP.LOBBY.config.different_decks and MP.LOBBY.deck.back or MP.LOBBY.config.back
	local stake = MP.LOBBY.config.different_decks and MP.LOBBY.deck.stake or MP.LOBBY.config.stake

	local t = {
		n = G.UIT.ROOT,
		config = {
			align = "cm",
			colour = G.C.CLEAR,
		},
		nodes = {
			{
				n = G.UIT.C,
				config = {
					align = "bm",
				},
				nodes = {
					{
						n = G.UIT.R,
						config = {
							padding = 0.1,
							align = "cm",
						},
						nodes = {
							{
								n = G.UIT.T,
								config = {
									scale = 0.3,
									shadow = true,
									text = (
										(
												(MP.LOBBY.host and MP.LOBBY.host.hash)
												and (MP.LOBBY.guest and MP.LOBBY.guest.hash)
												and (MP.LOBBY.host.hash ~= MP.LOBBY.guest.hash)
											)
											and (localize("k_mod_hash_warning"))
										or ((MP.LOBBY.username == "Guest") and (localize("k_set_name")))
										or " "
									),
									colour = G.C.UI.TEXT_LIGHT,
								},
							},
						},
					} or nil,
					{
						n = G.UIT.R,
						config = {
							align = "cm",
							padding = 0.2,
							r = 0.1,
							emboss = 0.1,
							colour = G.C.L_BLACK,
							mid = true,
						},
						nodes = {
							Disableable_Button({
								id = "lobby_menu_start",
								button = "lobby_start_game",
								colour = G.C.BLUE,
								minw = 3.65,
								minh = 1.55,
								label = { localize("b_start") },
								disabled_text = MP.LOBBY.is_host and localize("b_wait_for_players")
									or localize("b_wait_for_host_start"),
								scale = text_scale * 2,
								col = true,
								enabled_ref_table = MP.LOBBY,
								enabled_ref_value = "ready_to_start",
							}),
							{
								n = G.UIT.C,
								config = {
									align = "cm",
								},
								nodes = {
									UIBox_button({
										button = "lobby_options",
										colour = G.C.ORANGE,
										minw = 3.15,
										minh = 1.35,
										label = {
											localize("b_lobby_options"),
										},
										scale = text_scale * 1.2,
										col = true,
									}),
									{
										n = G.UIT.C,
										config = {
											align = "cm",
											minw = 0.2,
										},
										nodes = {},
									},
									MP.LOBBY.is_host and Disableable_Button({
										id = "lobby_choose_deck",
										button = "lobby_choose_deck",
										colour = G.C.PURPLE,
										minw = 2.15,
										minh = 1.35,
										label = {
											back,
											localize({
												type = "name_text",
												key = SMODS.stake_from_index(
													type(stake) == "string" and tonumber(stake) or stake
												),
												set = "Stake",
											}),
										},
										scale = text_scale * 1.2,
										col = true,
										enabled_ref_table = MP.LOBBY,
										enabled_ref_value = "is_host",
									}) or Disableable_Button({
										id = "lobby_choose_deck",
										button = "lobby_choose_deck",
										colour = G.C.PURPLE,
										minw = 2.15,
										minh = 1.35,
										label = {
											back,
											localize({
												type = "name_text",
												key = SMODS.stake_from_index(
													type(stake) == "string" and tonumber(stake) or stake
												),
												set = "Stake",
											}),
										},
										scale = text_scale * 1.2,
										col = true,
										enabled_ref_table = MP.LOBBY.config,
										enabled_ref_value = "different_decks",
									}),
									{
										n = G.UIT.C,
										config = {
											align = "cm",
											minw = 0.2,
										},
										nodes = {},
									},
									{
										n = G.UIT.C,
										config = {
											align = "tm",
											minw = 2.65,
										},
										nodes = {
											{
												n = G.UIT.R,
												config = {
													padding = 0.15,
													align = "cm",
												},
												nodes = {
													{
														n = G.UIT.T,
														config = {
															text = localize("k_connect_player"),
															shadow = true,
															scale = text_scale * 0.8,
															colour = G.C.UI.TEXT_LIGHT,
														},
													},
												},
											},
											MP.LOBBY.host.username and {
												n = G.UIT.R,
												config = {
													padding = 0.1,
													align = "cm",
												},
												nodes = {
													{
														n = G.UIT.T,
														config = {
															ref_table = MP.LOBBY.host,
															ref_value = "username",
															shadow = true,
															scale = text_scale * 0.8,
															colour = G.C.UI.TEXT_LIGHT,
														},
													},
													{
														n = G.UIT.B,
														config = {
															w = 0.1,
															h = 0.1,
														},
													},
													MP.LOBBY.host.hash and UIBox_button({
														id = "host_hash",
														button = "view_host_hash",
														label = { MP.LOBBY.host.hash },
														minw = 0.75,
														minh = 0.3,
														scale = 0.25,
														shadow = false,
														colour = G.C.PURPLE,
														col = true,
													}),
												},
											} or nil,
											MP.LOBBY.guest.username and {
												n = G.UIT.R,
												config = {
													padding = 0.1,
													align = "cm",
												},
												nodes = {
													{
														n = G.UIT.T,
														config = {
															ref_table = MP.LOBBY.guest,
															ref_value = "username",
															shadow = true,
															scale = text_scale * 0.8,
															colour = G.C.UI.TEXT_LIGHT,
														},
													},
													{
														n = G.UIT.B,
														config = {
															w = 0.1,
															h = 0.1,
														},
													},
													MP.LOBBY.guest.hash and UIBox_button({
														id = "host_guest",
														button = "view_guest_hash",
														label = { MP.LOBBY.guest.hash },
														minw = 0.75,
														minh = 0.3,
														scale = 0.25,
														shadow = false,
														colour = G.C.PURPLE,
														col = true,
													}),
												},
											} or nil,
										},
									},
									{
										n = G.UIT.C,
										config = {
											align = "cm",
											minw = 0.2,
										},
										nodes = {},
									},
									UIBox_button({
										button = "view_code",
										colour = G.C.PALE_GREEN,
										minw = 3.15,
										minh = 1.35,
										label = { localize("b_view_code") },
										scale = text_scale * 1.2,
										col = true,
									}),
								},
							},
							UIBox_button({
								id = "lobby_menu_leave",
								button = "lobby_leave",
								colour = G.C.RED,
								minw = 3.65,
								minh = 1.55,
								label = { localize("b_leave") },
								scale = text_scale * 1.5,
								col = true,
							}),
						},
					},
				},
			},
		},
	}
	return t
end

function G.UIDEF.create_UIBox_lobby_options()
	return create_UIBox_generic_options({
		contents = {
			{
				n = G.UIT.R,
				config = {
					padding = 0,
					align = "cm",
				},
				nodes = {
					not MP.LOBBY.is_host and {
						n = G.UIT.R,
						config = {
							padding = 0.3,
							align = "cm",
						},
						nodes = {
							{
								n = G.UIT.T,
								config = {
									scale = 0.6,
									shadow = true,
									text = localize("k_opts_only_host"),
									colour = G.C.UI.TEXT_LIGHT,
								},
							},
						},
					} or nil,
					create_tabs({
						snap_to_nav = true,
						colour = G.C.BOOSTER,
						tabs = {
							{
								label = localize("k_lobby_options"),
								chosen = true,
								tab_definition_function = function()
									return {
										n = G.UIT.ROOT,
										config = {
											emboss = 0.05,
											minh = 6,
											r = 0.1,
											minw = 10,
											align = "tm",
											padding = 0.2,
											colour = G.C.BLACK,
										},
										nodes = {
											{
												n = G.UIT.R,
												config = {
													padding = 0,
													align = "cr",
												},
												nodes = {
													Disableable_Toggle({
														id = "gold_on_life_loss_toggle",
														enabled_ref_table = MP.LOBBY,
														enabled_ref_value = "is_host",
														label = localize("b_opts_cb_money"),
														ref_table = MP.LOBBY.config,
														ref_value = "gold_on_life_loss",
														callback = send_lobby_options,
													}),
												},
											},
											{
												n = G.UIT.R,
												config = {
													padding = 0,
													align = "cr",
												},
												nodes = {
													Disableable_Toggle({
														id = "no_gold_on_round_loss_toggle",
														enabled_ref_table = MP.LOBBY,
														enabled_ref_value = "is_host",
														label = localize("b_opts_no_gold_on_loss"),
														ref_table = MP.LOBBY.config,
														ref_value = "no_gold_on_round_loss",
														callback = send_lobby_options,
													}),
												},
											},
											{
												n = G.UIT.R,
												config = {
													padding = 0,
													align = "cr",
												},
												nodes = {
													Disableable_Toggle({
														id = "death_on_round_loss_toggle",
														enabled_ref_table = MP.LOBBY,
														enabled_ref_value = "is_host",
														label = localize("b_opts_death_on_loss"),
														ref_table = MP.LOBBY.config,
														ref_value = "death_on_round_loss",
														callback = send_lobby_options,
													}),
												},
											},
											{
												n = G.UIT.R,
												config = {
													padding = 0,
													align = "cr",
												},
												nodes = {
													Disableable_Toggle({
														id = "different_seeds_toggle",
														enabled_ref_table = MP.LOBBY,
														enabled_ref_value = "is_host",
														label = localize("b_opts_diff_seeds"),
														ref_table = MP.LOBBY.config,
														ref_value = "different_seeds",
														callback = toggle_different_seeds,
													}),
												},
											},
											{
												n = G.UIT.R,
												config = {
													padding = 0,
													align = "cr",
												},
												nodes = {
													Disableable_Toggle({
														id = "different_decks_toggle",
														enabled_ref_table = MP.LOBBY,
														enabled_ref_value = "is_host",
														label = localize("b_opts_player_diff_deck"),
														ref_table = MP.LOBBY.config,
														ref_value = "different_decks",
														callback = send_lobby_options,
													}),
												},
											},
											{
												n = G.UIT.R,
												config = {
													padding = 0,
													align = "cr",
												},
												nodes = {
													Disableable_Toggle({
														id = "multiplayer_jokers_toggle",
														enabled_ref_table = MP.LOBBY,
														enabled_ref_value = "is_host",
														label = localize("b_opts_multiplayer_jokers"),
														ref_table = MP.LOBBY.config,
														ref_value = "multiplayer_jokers",
														callback = send_lobby_options,
													}),
												},
											},
											not MP.LOBBY.config.different_seeds and {
												n = G.UIT.R,
												config = {
													padding = 0,
													align = "cr",
												},
												nodes = {
													{
														n = G.UIT.C,
														config = {
															padding = 0,
															align = "cm",
														},
														nodes = {
															{
																n = G.UIT.R,
																config = {
																	padding = 0.2,
																	align = "cr",
																	func = "display_custom_seed",
																},
																nodes = {
																	{
																		n = G.UIT.T,
																		config = {
																			scale = 0.45,
																			text = localize("k_current_seed"),
																			colour = G.C.UI.TEXT_LIGHT,
																		},
																	},
																	{
																		n = G.UIT.T,
																		config = {
																			scale = 0.45,
																			text = MP.LOBBY.config.custom_seed,
																			colour = G.C.UI.TEXT_LIGHT,
																		},
																	},
																},
															},
															{
																n = G.UIT.R,
																config = {
																	padding = 0.2,
																	align = "cr",
																},
																nodes = {
																	Disableable_Button({
																		id = "custom_seed_overlay",
																		button = "custom_seed_overlay",
																		colour = G.C.BLUE,
																		minw = 3.65,
																		minh = 0.6,
																		label = {
																			localize("b_set_custom_seed"),
																		},
																		disabled_text = {
																			localize("b_set_custom_seed"),
																		},
																		scale = 0.45,
																		col = true,
																		enabled_ref_table = MP.LOBBY,
																		enabled_ref_value = "is_host",
																	}),
																	{
																		n = G.UIT.B,
																		config = {
																			w = 0.1,
																			h = 0.1,
																		},
																	},
																	Disableable_Button({
																		id = "custom_seed_reset",
																		button = "custom_seed_reset",
																		colour = G.C.RED,
																		minw = 1.65,
																		minh = 0.6,
																		label = {
																			localize("b_reset"),
																		},
																		disabled_text = {
																			localize("b_reset"),
																		},
																		scale = 0.45,
																		col = true,
																		enabled_ref_table = MP.LOBBY,
																		enabled_ref_value = "is_host",
																	}),
																},
															},
														},
													},
												},
											} or {
												n = G.UIT.B,
												config = {
													w = 0.1,
													h = 0.1,
												},
											},
										},
									}
								end,
							},
							{
								label = localize("k_opts_gm"),
								tab_definition_function = function()
									return {
										n = G.UIT.ROOT,
										config = {
											emboss = 0.05,
											minh = 6,
											r = 0.1,
											minw = 10,
											align = "tm",
											padding = 0.2,
											colour = G.C.BLACK,
										},
										nodes = {
											{
												n = G.UIT.R,
												config = {
													padding = 0,
													align = "cm",
												},
												nodes = {
													Disableable_Option_Cycle({
														id = "starting_lives_option",
														enabled_ref_table = MP.LOBBY,
														enabled_ref_value = "is_host",
														label = localize("b_opts_lives"),
														options = MP.UTILS.init_range_array(1, 16),
														current_option = MP.LOBBY.config.starting_lives,
														opt_callback = "change_starting_lives",
													}),
													Disableable_Option_Cycle({
														id = "starting_money_modifier_option",
														enabled_ref_table = MP.LOBBY,
														enabled_ref_value = "is_host",
														label = localize("b_opts_money_modifier"),
														options = MP.UTILS.init_increment_array(0, 50, 5),
														current_option = MP.LOBBY.config.starting_money_modifier + 1,
														opt_callback = "change_starting_money_modifier",
													}),
													Disableable_Option_Cycle({
														id = "starting_hand_modifier_option",
														enabled_ref_table = MP.LOBBY,
														enabled_ref_value = "is_host",
														label = localize("b_opts_hand_modifier"),
														options = MP.UTILS.init_range_array(0, 16),
														current_option = MP.LOBBY.config.starting_hand_modifier + 1,
														opt_callback = "change_starting_hand_modifier",
													}),
													Disableable_Option_Cycle({
														id = "starting_discard_modifier_option",
														enabled_ref_table = MP.LOBBY,
														enabled_ref_value = "is_host",
														label = localize("b_opts_discard_modifier"),
														options = MP.UTILS.init_range_array(0, 16),
														current_option = MP.LOBBY.config.starting_discard_modifier + 1,
														opt_callback = "change_starting_discard_modifier",
													}),
												},
											},
										},
									}
								end,
							},
						},
					}),
				},
			},
		},
	})
end

function G.FUNCS.display_custom_seed(e)
	local display = MP.LOBBY.config.custom_seed == "random" and localize("k_random") or MP.LOBBY.config.custom_seed
	if display ~= e.children[1].config.text then
		e.children[2].config.text = display
		e.UIBox:recalculate(true)
	end
end

function G.UIDEF.create_UIBox_custom_seed_overlay()
	return create_UIBox_generic_options({
		back_func = "lobby_options",
		contents = {
			{
				n = G.UIT.R,
				config = { align = "cm", colour = G.C.CLEAR },
				nodes = {
					{
						n = G.UIT.C,
						config = { align = "cm", minw = 0.1 },
						nodes = {
							create_text_input({
								max_length = 8,
								all_caps = true,
								ref_table = MP.LOBBY,
								ref_value = "temp_seed",
								prompt_text = localize("k_enter_seed"),
								callback = function(val)
									MP.LOBBY.config.custom_seed = MP.LOBBY.temp_seed
									send_lobby_options()
								end,
							}),
							{
								n = G.UIT.B,
								config = { w = 0.1, h = 0.1 },
							},
							{
								n = G.UIT.T,
								config = {
									scale = 0.3,
									text = localize("k_enter_to_save"),
									colour = G.C.UI.TEXT_LIGHT,
								},
							},
						},
					},
				},
			},
		},
	})
end

function G.UIDEF.create_UIBox_view_hash(type)
	return (
		create_UIBox_generic_options({
			contents = {
				{
					n = G.UIT.C,
					config = {
						padding = 0.2,
						align = "cm",
					},
					nodes = MP.UI.hash_str_to_view(
						type == "host" and MP.LOBBY.host.hash_str or MP.LOBBY.guest.hash_str,
						G.C.UI.TEXT_LIGHT
					),
				},
			},
		})
	)
end

function MP.UI.hash_str_to_view(str, text_colour)
	local t = {}

	if not str then
		return t
	end

	for s in str:gmatch("[^;]+") do
		table.insert(t, {
			n = G.UIT.R,
			config = {
				padding = 0.05,
				align = "cm",
			},
			nodes = {
				{
					n = G.UIT.T,
					config = {
						text = s,
						shadow = true,
						scale = 0.45,
						colour = text_colour,
					},
				},
			},
		})
	end
	return t
end

G.FUNCS.view_host_hash = function(e)
	G.FUNCS.overlay_menu({
		definition = G.UIDEF.create_UIBox_view_hash("host"),
	})
end

G.FUNCS.view_guest_hash = function(e)
	G.FUNCS.overlay_menu({
		definition = G.UIDEF.create_UIBox_view_hash("guest"),
	})
end

function toggle_different_seeds()
	G.FUNCS.lobby_options()
	send_lobby_options()
end

G.FUNCS.change_starting_lives = function(args)
	MP.LOBBY.config.starting_lives = args.to_val
	send_lobby_options()
end

G.FUNCS.change_starting_money_modifier = function(args)
	MP.LOBBY.config.starting_money_modifier = args.to_val
	print("Money: " .. args.to_val)
	send_lobby_options()
end

G.FUNCS.change_starting_hand_modifier = function(args)
	MP.LOBBY.config.starting_hand_modifier = args.to_val
	print("Hands: " .. args.to_val)
	send_lobby_options()
end

G.FUNCS.change_starting_discard_modifier = function(args)
	MP.LOBBY.config.starting_discard_modifier = args.to_val
	print("Discards: " .. args.to_val)
	send_lobby_options()
end

G.FUNCS.change_showdown_starting_antes = function(args)
	MP.LOBBY.config.showdown_starting_antes = args.to_val
	send_lobby_options()
end

function G.FUNCS.get_lobby_main_menu_UI(e)
	return UIBox({
		definition = G.UIDEF.create_UIBox_lobby_menu(),
		config = {
			align = "bmi",
			offset = {
				x = 0,
				y = 10,
			},
			major = G.ROOM_ATTACH,
			bond = "Weak",
		},
	})
end

---@type fun(e: table | nil, args: { deck: string, stake: number | nil, seed: string | nil })
function G.FUNCS.lobby_start_run(e, args)
	if MP.LOBBY.config.different_decks == false then
		G.FUNCS.copy_host_deck()
	end

	local challenge = G.CHALLENGES[get_challenge_int_from_id(MP.Rulesets[MP.LOBBY.config.ruleset].challenge_deck)]

	G.FUNCS.start_run(e, {
		mp_start = true,
		challenge = challenge,
		stake = tonumber(MP.LOBBY.deck.stake),
		seed = args.seed,
	})
end

function G.FUNCS.copy_host_deck()
	MP.LOBBY.deck.back = MP.LOBBY.config.back
	MP.LOBBY.deck.sleeve = MP.LOBBY.config.sleeve
	MP.LOBBY.deck.stake = MP.LOBBY.config.stake
end

function G.FUNCS.lobby_start_game(e)
	MP.ACTIONS.start_game()
end

function G.FUNCS.lobby_options(e)
	G.FUNCS.overlay_menu({
		definition = G.UIDEF.create_UIBox_lobby_options(),
	})
end

function G.FUNCS.view_code(e)
	G.FUNCS.overlay_menu({
		definition = G.UIDEF.create_UIBox_view_code(),
	})
end

function G.FUNCS.lobby_leave(e)
	MP.LOBBY.code = nil
	MP.ACTIONS.leave_lobby()
	MP.UI.update_connection_status()
end

function G.FUNCS.lobby_choose_deck(e)
	G.FUNCS.setup_run(e)
	if G.OVERLAY_MENU then
		G.OVERLAY_MENU:get_UIE_by_ID("run_setup_seed"):remove()
	end
end

local start_run_ref = G.FUNCS.start_run
G.FUNCS.start_run = function(e, args)
	if MP.LOBBY.code then
		if not args.mp_start then
			G.FUNCS.exit_overlay_menu()
			local chosen_stake = args.stake
			if MP.DECK.MAX_STAKE > 0 and chosen_stake > MP.DECK.MAX_STAKE then
				MP.UTILS.overlay_message(
					"Selected stake is incompatible with Multiplayer, stake set to "
						.. SMODS.stake_from_index(MP.DECK.MAX_STAKE)
				)
				chosen_stake = MP.DECK.MAX_STAKE
			end
			if MP.LOBBY.is_host then
				MP.LOBBY.config.back = (args.deck and args.deck.name) or G.GAME.viewed_back.name
				MP.LOBBY.config.stake = chosen_stake
				MP.LOBBY.config.sleeve = G.viewed_sleeve
				send_lobby_options()
			end
			MP.LOBBY.deck.back = (args.deck and args.deck.name) or G.GAME.viewed_back.name
			MP.LOBBY.deck.stake = chosen_stake
			MP.LOBBY.deck.sleeve = G.viewed_sleeve
			MP.ACTIONS.update_player_usernames()
		else
			local back = args.challenge
			back.deck.type = MP.LOBBY.deck.back
			back.sleeve = MP.LOBBY.deck.sleeve
			start_run_ref(e, {
				challenge = back,
				stake = tonumber(MP.LOBBY.deck.stake),
				seed = args.seed,
			})
		end
	else
		start_run_ref(e, args)
	end
end

function G.FUNCS.display_lobby_main_menu_UI(e)
	G.MAIN_MENU_UI = G.FUNCS.get_lobby_main_menu_UI(e)
	G.MAIN_MENU_UI.alignment.offset.y = 0
	G.MAIN_MENU_UI:align_to_major()

	G.CONTROLLER:snap_to({ node = G.MAIN_MENU_UI:get_UIE_by_ID("lobby_menu_start") })
end

function G.FUNCS.mp_return_to_lobby()
	MP.ACTIONS.stop_game()
end

function G.FUNCS.custom_seed_overlay(e)
	G.FUNCS.overlay_menu({
		definition = G.UIDEF.create_UIBox_custom_seed_overlay(),
	})
end

function G.FUNCS.custom_seed_reset(e)
	MP.LOBBY.config.custom_seed = "random"
	send_lobby_options()
end

local set_main_menu_UI_ref = set_main_menu_UI
---@diagnostic disable-next-line: lowercase-global
function set_main_menu_UI()
	if MP.LOBBY.code then
		G.FUNCS.display_lobby_main_menu_UI()
	else
		set_main_menu_UI_ref()
	end
end

local in_lobby = false
local gameUpdateRef = Game.update
---@diagnostic disable-next-line: duplicate-set-field
function Game:update(dt)
	if (MP.LOBBY.code and not in_lobby) or (not MP.LOBBY.code and in_lobby) then
		in_lobby = not in_lobby
		G.F_NO_SAVING = in_lobby
		self.FUNCS.go_to_menu()
		MP.reset_game_states()
	end
	gameUpdateRef(self, dt)
end

function G.UIDEF.create_UIBox_unstuck()
	return (
		create_UIBox_generic_options({
			contents = {
				{
					n = G.UIT.C,
					config = {
						padding = 0.2,
						align = "cm",
					},
					nodes = {
						UIBox_button({
							label = { localize("b_unstuck_arcana") },
							button = "mp_unstuck_arcana",
							minw = 5,
						}),
						UIBox_button({ label = { localize("b_unstuck_blind") }, button = "mp_unstuck_blind", minw = 5 }),
					},
				},
			},
		})
	)
end

function G.FUNCS.mp_unstuck()
	G.FUNCS.overlay_menu({
		definition = G.UIDEF.create_UIBox_unstuck(),
	})
end

function G.FUNCS.mp_unstuck_arcana()
	G.FUNCS.skip_booster()
end

function G.FUNCS.mp_unstuck_blind()
	MP.GAME.ready_blind = false
	if MP.GAME.next_blind_context then
		G.FUNCS.select_blind(MP.GAME.next_blind_context)
	else
		sendErrorMessage("No next blind context", "MULTIPLAYER")
	end
end

function MP.UI.update_connection_status()
	if G.HUD_connection_status then
		G.HUD_connection_status:remove()
	end
	if G.STAGE == G.STAGES.MAIN_MENU then
		G.HUD_connection_status = G.UIDEF.get_connection_status_ui()
	end
end

local gameMainMenuRef = Game.main_menu
---@diagnostic disable-next-line: duplicate-set-field
function Game:main_menu(change_context)
	MP.UI.update_connection_status()
	gameMainMenuRef(self, change_context)
end

function G.FUNCS.copy_to_clipboard(e)
	MP.UTILS.copy_to_clipboard(MP.LOBBY.code)
end

function G.FUNCS.reconnect(e)
	MP.ACTIONS.connect()
	G.FUNCS:exit_overlay_menu()
end

function MP.update_player_usernames()
	if MP.LOBBY.code then
		if G.MAIN_MENU_UI then
			G.MAIN_MENU_UI:remove()
		end

		G.FUNCS.display_lobby_main_menu_UI()
	end
end
