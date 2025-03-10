G.MULTIPLAYER.DECK.BANNED_CARDS_DRMONTY = { -- banned cards for the dr monty special (weekly tournament 3)
    { id = "j_caino" }, -- legendaries
    { id = "j_perkeo" },
    { id = "j_triboulet" },
    { id = "j_yorick" },
    { id = "j_chicot" }, -- alredy banned

    { id = "j_blueprint" }, -- rares
    { id = "j_brainstorm" },
    { id = "j_ancient" },
    { id = "j_baron" },
    { id = "j_baseball" },
    { id = "j_dna" },
    { id = "j_family" };
    { id = "j_trio" },
    { id = "j_vagabond" },

    { id = "j_acrobat" }, -- uncommons
    { id = "j_card_sharp" },
    { id = "j_cartomancer" },
    { id = "j_certificate" },
    { id = "j_dusk" },
    { id = "j_fibonacci" },
    { id = "j_hologram" },
    { id = "j_loyalty_card" },
    { id = "j_lucky_cat" },
    { id = "j_midas_mask" },
    { id = "j_bloodstone" },
    { id = "j_arrowhead" },
    { id = "j_onyx_agate" },
    { id = "j_selzer" },
    { id = "j_trading" },
    { id = "j_mime"},
    { id = "j_steel_joker" },
    { id = "j_mr_bones" }, -- alredy banned
    { id = "j_luchador" }, -- alredy banned
    { id = "j_matador" }, -- alredy banned


    { id = "j_abstract" }, -- commons
    { id = "j_blue_joker" },
    { id = "j_cavendish" },
    { id = "j_photograph" },
    { id = "j_hanging_chad" },
    { id = "j_mail" },
    { id = "j_reserved_parking" },
    { id = "j_mp_defensive_joker" },
    { id = "j_mp_hanging_bad" },

    { id = "c_trance" }, -- spectrals
    { id = "c_deja_vu" },

    { id = "c_justice" }, -- tarots

    { id = "v_magic_trick" }, -- vouchers
    { id = "v_illusion" },
    { id = "v_hieroglyph" }, -- alredy banned
	{ id = "v_petroglyph" }, -- alredy banned
	{ id = "v_directors_cut" }, -- alredy banned
	{ id = "v_retcon" }, -- alredy banned
}

G.MULTIPLAYER.DECK.BANNED_TAGS_DRMONTY = { -- banned tags for the dr monty special (weekly tournament 3)
    { id = "tag_uncommon" } ,
    { id = "tag_meteor" },
    { id = "tag_garbage" },
    { id = "tag_top_up" },
    { id = "tag_handy" },
    { id = "tag_boss" }, -- alredy banned
}

SMODS.Enhancement:take_ownership("glass", { -- change mult and chance of breaking of breaking glass
	config = {
		Xmult = 1,
		extra = 1000000,
	},
}, true)