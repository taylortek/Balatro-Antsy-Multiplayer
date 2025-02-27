SMODS.Back{
    name = "Test Deck",
    key = "test",
    pos = {x = 1, y = 3},
    loc_txt = {
        name ="Test Deck",
        text={
            "Test deck"
        },
    },
    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                SMODS.add_card({
                    set = "Spectral",
                    key = "c_antsy_multiplayer_spam_mail"
                })
                SMODS.add_card({
                    set = "Joker",
                    key = "j_joker"
                })
                return true
            end
        }))
    end
}