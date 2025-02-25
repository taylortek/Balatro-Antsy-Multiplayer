G.MULTIPLAYER = {}

G.MULTIPLAYER.CONFIG = SMODS.current_mod.config

G.MULTIPLAYER.IP, G.MULTIPLAYER.PORT = G.MULTIPLAYER.CONFIG.ip:gsub("O", "0"), tonumber(G.MULTIPLAYER.CONFIG.port)

G.MULTIPLAYER.STATES = {}
G.MULTIPLAYER.OPPONENT = {
    score = "0",
    won = 0
}
G.MULTIPLAYER.PLAYER = {
    score = "0",
    won = 0,
    score_statement = "0 | 0"
}
G.MULTIPLAYER.registered = false

local mod_path = "" .. SMODS.current_mod.path
local socket = require "socket"
G.MULTIPLAYER.tcp = assert(socket.tcp())

SMODS.load_file("core/hooks.lua")()
SMODS.load_file("core/api.lua")()
SMODS.load_file("core/ui.lua")()
SMODS.load_file("core/button_callbacks.lua")()
SMODS.load_file("main.lua")()

