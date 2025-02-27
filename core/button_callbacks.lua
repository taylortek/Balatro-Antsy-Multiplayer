G.FUNCS.lobby_button = function (e)
    local connected = G.MULTIPLAYER.tcp:connect(G.MULTIPLAYER.IP, G.MULTIPLAYER.PORT)
    if not connected then
        G.FUNCS.overlay_menu{
            definition = failed_connection_popup()
        }
    else
        G.MULTIPLAYER.tcp:settimeout(0)
        G.MULTIPLAYER.player_number = talk_to_tcp("Get Player Number", true)
        G.MULTIPLAYER.registered = true
        G.FUNCS.overlay_menu {
            definition = lobby_menu(G.MULTIPLAYER.player_number)
        }
    end
end

G.FUNCS.start_multiplayer_button = function (e)
    G.FUNCS.start_run(e, {})
end

G.FUNCS.won_round_click = function (e)
    G.FUNCS.exit_overlay_menu()
end