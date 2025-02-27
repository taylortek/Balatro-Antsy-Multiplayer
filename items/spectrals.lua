SMODS.Consumable {
    key = "spam_mail",
    set = "Spectral",
    loc_txt = {name = "Possession", text = {"Sends a random one of", "your jokers to opponent", "and apply eternal to it"}},
    cost = 4,
    use = function(self, card, area, copier)
        local joker = pseudorandom_element(G.jokers.cards, pseudoseed('spam_mail'))
        joker:start_dissolve()
        send_to_tcp("[Spectral_Action] [Spam_Mail] " .. joker.config.center_key)
    end,
    can_use = function(self, card)
        if #G.jokers.cards > 0 then
            return true
        else
            return false
        end
    end
}

SMODS.Consumable {
    key = "jumpscare",
    set = "Spectral",
    loc_txt = {name = "Jumpscare", text = {"Up opponent's ante by one", "and destroy a random joker"}},
    cost = 4,
    use = function(self, card, area, copier)
        local joker = pseudorandom_element(G.jokers.cards, pseudoseed('spam_mail'))
        joker:start_dissolve()
        send_to_tcp("[Spectral_Action] [Jumpscare]")
    end,
    can_use = function(self, card)
        if #G.jokers.cards > 0 then
            return true
        else
            return false
        end
    end
}