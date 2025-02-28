G.MULTIPLAYER.HOOKS.create_UIBox_main_menu_buttons = function (r)
    local button = --{n=G.UIT.R, config={align = "cm", padding = 0.2, r = 0.1, emboss = 0.1, colour = G.C.L_BLACK, mid = true}, nodes={
        UIBox_button{id = 'lobby', button = "lobby_button", colour = G.C.BLUE, minw = 3.65, minh = 1.55, label = {"LOBBY"}, scale = 1, col = true}
    --}}
    r.nodes[1].nodes[1].nodes[1] = button
    return r
end

G.MULTIPLAYER.HOOKS.create_UIBox_HUD = function (r)
    local t = 
    {n=G.UIT.R, config={align = "cm", padding = 0.1}, nodes={
        {n=G.UIT.T, id="antsy_opponent_score", config={ref_table = G.MULTIPLAYER.PLAYER, ref_value = "score_statement", colour = G.C.UI.TEXT_LIGHT, scale=0.5}}
    }}
    local y = 
    {n=G.UIT.R, config={align = "cm", padding = 0.1}, nodes={
        {n=G.UIT.T, id="antsy_opponent_score", config={ref_table = G.MULTIPLAYER.PLAYER, ref_value = "won", colour = G.C.BLUE, scale=0.2}},
        {n=G.UIT.T, id="antsy_opponent_score", config={text = " | ", colour = G.C.UI.TEXT_LIGHT, scale=0.2}},
        {n=G.UIT.T, id="antsy_opponent_score", config={ref_table = G.MULTIPLAYER.OPPONENT, ref_value = "won", colour = G.C.RED, scale=0.2}}
    }}
    table.insert(r.nodes[1].nodes[1].nodes[4].nodes[1].nodes,2, t) 
    table.insert(r.nodes[1].nodes[1].nodes[4].nodes[1].nodes,2, y) 
    return r
end

function lobby_menu(playernumber)
    local t = 
    {n = G.UIT.ROOT, config = {r = 0.1, minw = 5, align = "cm", padding = 0.2, colour = G.C.BLACK}, nodes = {
    {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {
        {n = G.UIT.T, config = {text = "Lobby", colour = G.C.UI.TEXT_LIGHT, scale = 1}}
     }},
    {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {
        {n = G.UIT.T, config = {text = string.format("Connected to %s:%i", G.MULTIPLAYER.IP, G.MULTIPLAYER.PORT), colour = G.C.UI.TEXT_LIGHT, scale = 0.2}}
     }},
    {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {
        {n = G.UIT.T, config = {text = string.format("You are player %s", playernumber), colour = G.C.UI.TEXT_LIGHT, scale = 0.5}}
     }},
    {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {
        UIBox_button{id = 'main_menu_play', button = "setup_run", colour = G.C.RED, minw = 3.65, minh = 1.55, label = {"START MULTIPLAYER"}, scale = 1, col = true}
    }},
    }}

     return t
end

function wait_menu()
    local t =
    {n = G.UIT.ROOT, config = {r = 0.1, minw = 200, minh = 200, align = "cm", padding = 0.2, colour = G.C.CLEAR}, nodes = {
        {n = G.UIT.C, config = {r = 0.1, minw = 5, align = "cm", padding = 0.2, colour = G.C.BLACK}, nodes = {
            {n = G.UIT.C, config = {align = "cm", padding = 0.1}, nodes = {
                {n = G.UIT.T, config = {text = "Waiting for other player...", colour = G.C.UI.TEXT_LIGHT, scale = 0.5}}
            }}
        }}
    }}
    return t
end

function win_screen()
    local t =
    {n = G.UIT.ROOT, config = {r=0.1, minw=5, align="cm", padding=0.1, colour=G.C.BLACK}, nodes = {
        {n = G.UIT.R, config = {align="cm", padding=0.1}, nodes = {
            {n = G.UIT.T, config = {text="Round Won!", colour=G.C.BLUE, scale=2}}
        }},
        {n = G.UIT.R, config = {align="cm", padding=0.1}, nodes = {
            UIBox_button{id = 'won_round_button', button = "won_round_click", colour = G.C.RED, minw = 3.65, minh = 1.55, label = {"Cool"}, scale = 1, col = true}
        }}
    }}
    return t
end

function lose_screen()
    local t =
    {n = G.UIT.ROOT, config = {r=0.1, minw=5, align="cm", padding=0.1, colour=G.C.BLACK}, nodes = {
        {n = G.UIT.R, config = {align="cm", padding=0.1}, nodes = {
            {n = G.UIT.T, config = {text="Round Lost...", colour=G.C.RED, scale=2}}
        }},
        {n = G.UIT.R, config = {align="cm", padding=0.1}, nodes = {
            UIBox_button{id = 'won_round_button', button = "won_round_click", colour = G.C.RED, minw = 3.65, minh = 1.55, label = {"Damn"}, scale = 1, col = true}
        }}
    }}
    return t
end

function tie_screen()
    local t =
    {n = G.UIT.ROOT, config = {r=0.1, minw=5, align="cm", padding=0.1, colour=G.C.BLACK}, nodes = {
        {n = G.UIT.R, config = {align="cm", padding=0.1}, nodes = {
            {n = G.UIT.T, config = {text="Round Tied.", colour=G.C.YELLOW, scale=2}}
        }},
        {n = G.UIT.R, config = {align="cm", padding=0.1}, nodes = {
            UIBox_button{id = 'won_round_button', button = "won_round_click", colour = G.C.RED, minw = 3.65, minh = 1.55, label = {"Ok"}, scale = 1, col = true}
        }}
    }}
    return t
end

function win_game_screen()
    local t =
    {n = G.UIT.ROOT, config = {r=0.1, minw=5, align="cm", padding=0.1, colour=G.C.BLACK}, nodes = {
        {n = G.UIT.R, config = {align="cm", padding=0.1}, nodes = {
            {n = G.UIT.T, config = {text="Game Won!", colour=G.C.BLUE, scale=2}}
        }},
        {n = G.UIT.R, config = {align="cm", padding=0.1}, nodes = {
            UIBox_button{id = 'won_round_button', button = "setup_run", colour = G.C.RED, minw = 3.65, minh = 1.55, label = {"Rematch"}, scale = 1, col = true}
        }}
    }}
    return t
end

function lose_game_screen()
    local t =
    {n = G.UIT.ROOT, config = {r=0.1, minw=5, align="cm", padding=0.1, colour=G.C.BLACK}, nodes = {
        {n = G.UIT.R, config = {align="cm", padding=0.1}, nodes = {
            {n = G.UIT.T, config = {text="Game Lost...", colour=G.C.RED, scale=2}}
        }},
        {n = G.UIT.R, config = {align="cm", padding=0.1}, nodes = {
            UIBox_button{id = 'won_round_button', button = "setup_run", colour = G.C.RED, minw = 3.65, minh = 1.55, label = {"Rematch"}, scale = 1, col = true}
        }}
    }}
    return t
end

function failed_connection_popup()
    local t =
    {n = G.UIT.ROOT, config = {r=0.1, minw=5, align="cm", padding=0.1, colour=G.C.BLACK}, nodes = {
        {n = G.UIT.R, config = {align="cm", padding=0.1}, nodes = {
            {n = G.UIT.T, config = {text="Failed to connect...", colour=G.C.UI.TEXT_LIGHT, scale=1}}
        }},
        {n = G.UIT.R, config = {align="cm", padding=0.1}, nodes = {
            UIBox_button{id = 'won_round_button', button = "exit_overlay_menu", colour = G.C.RED, minw = 3.65, minh = 1.55, label = {"Ok"}, scale = 1, col = true}
        }}
    }}
    return t
end

function disconnected_from_server_popup()
    local t = 
    {n = G.UIT.ROOT, config = {r=0.1, minw=5, align="cm", padding=0.1, colour=G.C.BLACK}, nodes = {
        {n = G.UIT.R, config = {align="cm", padding=0.1}, nodes = {
            {n = G.UIT.T, config = {text="Disconnected from server", colour=G.C.UI.TEXT_LIGHT, scale=1}}
        }},
        {n = G.UIT.R, config = {align="cm", padding=0.1}, nodes = {
            UIBox_button{id = 'antsy_quit_button', button = "quit", colour = G.C.RED, minw = 3.65, minh = 1.55, label = {"Quit", scale = 1, col = true}}
        }}
    }}
    return t
end

-- Make config to allow for ip and port selection
SMODS.current_mod.config_tab = function()
	return {n = G.UIT.ROOT, config = {r = 0.1, minw = 5, align = "cm", padding = 0.2, colour = G.C.BLACK
	}, nodes = {
         {n = G.UIT.R, config = { align = "cm", padding = 0.01 }, nodes = {
             create_text_input({
                w = 4, max_length = 100, prompt_text = "ip",
                extended_corpus = true, ref_table = G.MULTIPLAYER.CONFIG, ref_value = 'ip', keyboard_offset = 1,
                callback = function(e)
                    SMODS.save_mod_config(G.MULTIPLAYER.CONFIG)
                    G.MULTIPLAYER.IP, G.MULTIPLAYER.PORT = G.MULTIPLAYER.CONFIG.ip:gsub("O", "0"), G.MULTIPLAYER.CONFIG.port:gsub("O", "0")
                end
            }),
             create_text_input({
                w = 4, max_length = 100, prompt_text = "port",
                extended_corpus = true, ref_table = G.MULTIPLAYER.CONFIG, ref_value = 'port', keyboard_offset = 1,
                callback = function(e)
                    SMODS.save_mod_config(G.MULTIPLAYER.CONFIG) 
                    G.MULTIPLAYER.IP, G.MULTIPLAYER.PORT = G.MULTIPLAYER.CONFIG.ip:gsub("O", "0"), G.MULTIPLAYER.CONFIG.port:gsub("O", "0")
                end
            }),
        }}, 
	}}
end