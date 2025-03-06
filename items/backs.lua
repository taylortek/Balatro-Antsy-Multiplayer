SMODS.Back{
    name = "Multiplayer Test Deck",
    key = "multiplayer_test",
    pos = {x = 1, y = 3},
    loc_txt = {
        name ="Multiplayer Test Deck",
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
                    set = "Spectral",
                    key = "c_antsy_multiplayer_jumpscare"
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