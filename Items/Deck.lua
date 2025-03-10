SMODS.Challenge({
	key = "c_multiplayer_1",
	name = "MULTIPLAYER",
	rules = {
		custom = {},
		modifiers = {},
	},
	jokers = {},
	consumeables = {},
	vouchers = {},
	restrictions = {
		banned_cards = G.MULTIPLAYER.DECK.BANNED_CARDS_DRMONTY,
		banned_tags = G.MULTIPLAYER.DECK.BANNED_TAGS_DRMONTY,
		banned_other = G.MULTIPLAYER.DECK.BANNED_BLINDS,
	},
	deck = {
		type = G.MULTIPLAYER.DECK_TYPE,
	},
	unlocked = function(self)
		return false
	end,
	prefix_config = { key = false },
})