G.MULTIPLAYER = {}
G.MULTIPLAYER.MOD_PATH = SMODS.current_mod.path
G.MULTIPLAYER.rounds_to_win = 3

G.MULTIPLAYER.CONFIG = SMODS.current_mod.config

if G.MULTIPLAYER.CONFIG.enable_multiplayer then

G.MULTIPLAYER.IP, G.MULTIPLAYER.PORT = G.MULTIPLAYER.CONFIG.ip:gsub("O", "0"), G.MULTIPLAYER.CONFIG.port:gsub("O", "0")

G.MULTIPLAYER.STATES = {}
G.MULTIPLAYER.OPPONENT = {
    score = "0",
    won = 0
}
G.MULTIPLAYER.PLAYER = {
    score = "0",
    won = 0,
    score_statement = "0 | 0",
}
G.MULTIPLAYER.registered = false

local socket = require "socket"
G.MULTIPLAYER.tcp = assert(socket.tcp())

-- New Balatro Logo
SMODS.Atlas {
    key = "logo",
    path = "balatro.png",
    px = 333,
    py = 216
}

SMODS.Atlas {
    key = 'antsymulttarotatlas',
    path = 'tarotsatlas.png',
    px = 71,
    py = 95
}

SMODS.load_file("core/hooks.lua")()
SMODS.load_file("core/api.lua")()
SMODS.load_file("core/ui.lua")()
SMODS.load_file("core/button_callbacks.lua")()
SMODS.load_file("main.lua")()

SMODS.load_file("items/jokers.lua")()
SMODS.load_file("items/spectrals.lua")()
SMODS.load_file("items/backs.lua")()
end

G.FUNCS.apply_multiplayer_settings = function(e)
    SMODS.save_mod_config(G.MULTIPLAYER.CONFIG)
end

G.FUNCS.paste_multiplayer_server = function(e)
    local clipboard_test = love.system.getClipboardText()
    local t = {}
    for str in string.gmatch(clipboard_test, "([^"..":".."]+)") do
        table.insert(t, str)
    end
    G.MULTIPLAYER.CONFIG.ip = t[1]
    G.MULTIPLAYER.CONFIG.port = t[2]
    G.FUNCS.apply_multiplayer_settings(G.MULTIPLAYER.CONFIG)
end
-- Make config to allow for ip and port selection
SMODS.current_mod.config_tab = function()
	return {n = G.UIT.ROOT, config = {r = 0.1, minw = 5, align = "cm", padding = 0.2, colour = G.C.BLACK
	}, nodes = {
        create_toggle({label = '*Enable Multiplayer', ref_table = G.MULTIPLAYER.CONFIG, ref_value = 'enable_multiplayer'}),
         {n = G.UIT.R, config = { align = "cm", padding = 0.01 }, nodes = {
             create_text_input({
                w = 4, max_length = 100, prompt_text = "ip",
                extended_corpus = true, ref_table = G.MULTIPLAYER.CONFIG, ref_value = 'ip', keyboard_offset = 1,
                callback = function(e)
                    SMODS.save_mod_config(G.MULTIPLAYER.CONFIG)
                    love.keyboard.setTextInput(true, math.floor(100/2 - 100), math.floor(100/2), 200, 20)
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
            UIBox_button({label = {'Paste (ip:port)'}, button = "paste_multiplayer_server"}),
            UIBox_button({label = {'Apply'}, button = "apply_multiplayer_settings"}),
            {n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
                {n=G.UIT.T, config={text = "*requires restart", scale = 0.2, colour = G.C.UI.TEXT_LIGHT}}
            }},
            {n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
                {n=G.UIT.T, config={text = "Due to mobile restrictions. You are required to paste the ip and port.", scale = 0.2, colour = G.C.UI.TEXT_LIGHT}}
            }},
	}}
end