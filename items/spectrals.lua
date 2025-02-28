SMODS.Consumable {
    key = "spam_mail",
    set = "Spectral",
    loc_txt = {name = "Possession", text = {"Sends a random one of", "your jokers to opponent", "and apply eternal to it"}},
    cost = 4,
    use = function(self, card, area, copier)
        local joker = pseudorandom_element(G.jokers.cards, pseudoseed('spam_mail'))
        joker:start_dissolve()
        send_to_tcp("[Spectral_Action] [Spam_Mail] " .. joker.config.center_key .. " " .. (joker:get_edition() ~= nil and joker.edition.key or "normal"))
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
        local non_eternal_jokers = {}
        for i = 1,#G.jokers.cards do
            if G.jokers.cards[i].ability.eternal ~= true then
                table.insert(non_eternal_jokers, G.jokers.cards[i])
            end
        end
        pseudorandom_element(non_eternal_jokers, pseudoseed('spam_mail')):start_dissolve()
        send_to_tcp("[Spectral_Action] [Jumpscare]")
    end,
    can_use = function(self, card)
        local non_eternal_jokers = {}
        for i = 1,#G.jokers.cards do
            if G.jokers.cards[i].ability.eternal ~= true then
                table.insert(non_eternal_jokers, G.jokers.cards[i])
            end
        end
        if #non_eternal_jokers > 0 then
            return true
        else
            return false
        end
    end
}