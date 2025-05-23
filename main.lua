SMODS.Blind {
    key = "comp_blind",
    loc_txt = {name = "Competitive Blind", text = {"Fight!"}},
    mult = 1,
    boss = {min = 1, max = 100},
    boss_colour = HEX('ffadfc')
}

-- Remove boss tag from game
SMODS.Tag:take_ownership('boss',
    {
        in_pool = function()
            return false
        end
    }
,true)

SMODS.Voucher:take_ownership('directors_cut',
    {
        in_pool = function()
            return false
        end
    }
,true)

SMODS.Joker:take_ownership('luchador',
    {
        in_pool = function()
            return false
        end
    }
,true)

-- Main server communication
G.MULTIPLAYER.HOOKS.game_update = function (r)
    if G.MULTIPLAYER.registered then
        local response = nil
        response = receive_from_tcp(false)
        if response ~= nil then
            local command = split_by_word(response)
            if command[1] == "[Wait]" then
                queueaction(function()
                    G.FUNCS.overlay_menu {
                        definition = wait_menu(),
                        config = {
                            no_esc = true
                        }
                    }
                    return true
                end, 0, 'after')
            end
            if command[1] == "[Stop_Wait]" then
                if G.OVERLAY_MENU then G.FUNCS.exit_overlay_menu() end
            end
            if command[1] == "[Opponent_Chips]" then
                G.MULTIPLAYER.OPPONENT.score = command[2]
                G.MULTIPLAYER.PLAYER.score_statement = string.format("%s | %s", G.MULTIPLAYER.PLAYER.score, G.MULTIPLAYER.OPPONENT.score)
            end
            if command[1] == "[Won_Round]" then
                G.MULTIPLAYER.PLAYER.won = G.MULTIPLAYER.PLAYER.won + 1
                G.FUNCS.overlay_menu {
                    definition = win_screen()
                }
            end
            if command[1] == "[Lost_Round]" then
                G.MULTIPLAYER.OPPONENT.won = G.MULTIPLAYER.OPPONENT.won + 1
                G.FUNCS.overlay_menu {
                    definition = lose_screen()
                }
            end
            if command[1] == "[Tied_Round]" then
                G.FUNCS.overlay_menu {
                    definition = tie_screen()
                }
            end
            if command[1] == "[Won_Round]" or command[1] == "[Lost_Round]" then
                if G.MULTIPLAYER.PLAYER.won >= G.MULTIPLAYER.rounds_to_win then
                    G.FUNCS.overlay_menu {
                        definition = win_game_screen()
                    }
                elseif G.MULTIPLAYER.OPPONENT.won >= G.MULTIPLAYER.rounds_to_win then
                    G.FUNCS.overlay_menu {
                        definition = lose_game_screen()
                    }
                end
                if G.MULTIPLAYER.PLAYER.won >= G.MULTIPLAYER.rounds_to_win or G.MULTIPLAYER.OPPONENT.won >= G.MULTIPLAYER.rounds_to_win then
                    G.MULTIPLAYER.OPPONENT.won = 0
                    G.MULTIPLAYER.PLAYER.won = 0
                end
            end
            if command[1] == "[Won_Game]" then
                G.MULTIPLAYER.OPPONENT.won = 0
                G.MULTIPLAYER.PLAYER.won = 0
                G.FUNCS.overlay_menu {
                    definition = win_game_screen()
                } 
            end
            if command[1] == "[Lost_Game]" then
                G.MULTIPLAYER.OPPONENT.won = 0
                G.MULTIPLAYER.PLAYER.won = 0
                G.FUNCS.overlay_menu {
                    definition = lose_game_screen()
                } 
            end
            if command[1] == "[Add_Joker]" then
                if command[4] ~= "normal" then
                    SMODS.add_card({
                        set = "Joker",
                        key = command[2],
                        stickers = {command[3]},
                        edition = command[4],
                        no_edition = true
                    })
                else
                    SMODS.add_card({
                        set = "Joker",
                        key = command[2],
                        stickers = {command[3]},
                        no_edition = true
                    })
                end
            end
            if command[1] == "[Set]" then
                if command[2] == "Rounds_To_Win" then
                    G.MULTIPLAYER.rounds_to_win = tonumber(command[3])
                    print("set rounds to win to " .. G.MULTIPLAYER.rounds_to_win)
                end
            end
            if command[1] == "[Up_Ante]" then
                ease_ante(1)
            end
            if command[1] == "[Other_Player_Disconnect]" then
                G.FUNCS.overlay_menu {
                    definition = disconnected_from_server_popup()
                }
            end
        end
    end
    return r
end

G.MULTIPLAYER.HOOKS.select_blind = function (r)
    G.MULTIPLAYER.PLAYER.score = "0"
    G.MULTIPLAYER.OPPONENT.score = "0"
    G.MULTIPLAYER.PLAYER.score_statement = string.format("%s | %s", G.MULTIPLAYER.PLAYER.score, G.MULTIPLAYER.OPPONENT.score)
    queueaction(function()
        send_to_tcp("[Selected_Blind] " .. G.GAME.round_resets.blind.name:gsub("%s+", "_"))
        return true
    end, 0, 'after')
    if G.GAME.blind_on_deck == "Boss" then
        queueaction(function()
            return true
        end, 0, 'after')
    end
    return r
end

G.MULTIPLAYER.HOOKS.get_blind_amount = function (r)
    return r
end

G.MULTIPLAYER.HOOKS.evaluate_play = function (r)
   if G.GAME.round_resets.blind.name ~= "Small Blind" and G.GAME.round_resets.blind.name ~= "Big Blind" then 
        queueaction(function()
            send_to_tcp("[Hand_Played] " .. G.GAME.chips .. " " .. get_current_blind_chips() .. " " .. G.GAME.current_round.hands_left)
            G.MULTIPLAYER.PLAYER.score = tostring(tonumber(G.MULTIPLAYER.PLAYER.score) + G.GAME.chips)
            G.MULTIPLAYER.PLAYER.score_statement = string.format("%s | %s", G.MULTIPLAYER.PLAYER.score, G.MULTIPLAYER.OPPONENT.score)
            if G.GAME.current_round.hands_left == 0 then
                G.GAME.chips = get_current_blind_chips()
            else
                G.GAME.chips = 0
            end
            return true
        end, 0, 'after')
    end
    return r
end

G.MULTIPLAYER.HOOKS.reset_blinds = function (r)
    G.GAME.round_resets.blind_choices.Boss = "bl_antsy_multiplayer_comp_blind"
    return r
end

G.MULTIPLAYER.HOOKS.end_round = function (r)
    if G.GAME.chips < get_current_blind_chips() then
        send_to_tcp("[Lost_Round]")
    end
    if G.GAME.round_resets.blind.name ~= "Small Blind" and G.GAME.round_resets.blind.name ~= "Big Blind" then 
        send_to_tcp("[Beat_Boss]")
    end
    return r
end

G.MULTIPLAYER.HOOKS.start_run = function (r)
    send_to_tcp("[Started_Run] " .. G.GAME.pseudorandom.seed .. (G.GAME.seeded and " Seeded" or " Not_Seeded"))
    return r
end