G.MULTIPLAYER = {}
G.MULTIPLAYER.MOD_PATH = SMODS.current_mod.path
G.MULTIPLAYER.rounds_to_win = 3

G.MULTIPLAYER.CONFIG = SMODS.current_mod.config

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