G.MULTIPLAYER.HOOKS = {}

G.MULTIPLAYER.HOOKS.start_run = function(r) return r end
local old_func = G.start_run
G.start_run = function(self, args)
    ret = old_func(self, args)
    return G.MULTIPLAYER.HOOKS.start_run(ret)
end

G.MULTIPLAYER.HOOKS.new_round = function(r) return r end
local old_func = new_round
new_round = function()
    ret = old_func()
    return G.MULTIPLAYER.HOOKS.new_round(ret)
end

G.MULTIPLAYER.HOOKS.game_update = function(r) return r end
local old_func = Game.update
Game.update = function(self, dt)
    local ret = old_func(self, dt)
    return G.MULTIPLAYER.HOOKS.game_update(ret)
end

G.MULTIPLAYER.HOOKS.create_UIBox_main_menu_buttons = function(r) return r end
local old_func = create_UIBox_main_menu_buttons
create_UIBox_main_menu_buttons = function()
    local ret = old_func()
    return G.MULTIPLAYER.HOOKS.create_UIBox_main_menu_buttons(ret)
end

G.MULTIPLAYER.HOOKS.evaluate_play = function(r) return r end
local old_func = G.FUNCS.evaluate_play
G.FUNCS.evaluate_play = function(e)
    local ret = old_func(e)
    return G.MULTIPLAYER.HOOKS.evaluate_play(ret)
end

G.MULTIPLAYER.HOOKS.select_blind = function(r) return r end
local old_func = G.FUNCS.select_blind
G.FUNCS.select_blind = function(e)
    local ret = old_func(e)
    return G.MULTIPLAYER.HOOKS.select_blind(ret)
end

G.MULTIPLAYER.HOOKS.reset_blinds = function(r) return r end
local old_func = reset_blinds
reset_blinds = function(e)
    local ret = old_func(e)
    return G.MULTIPLAYER.HOOKS.reset_blinds(ret)
end

G.MULTIPLAYER.HOOKS.get_blind_amount = function(r) return r end
local old_func = get_blind_amount
get_blind_amount = function(ante)
    local ret = old_func(ante)
    return G.MULTIPLAYER.HOOKS.get_blind_amount(ret)
end

G.MULTIPLAYER.HOOKS.create_UIBox_HUD = function(r) return r end
local old_func = create_UIBox_HUD
create_UIBox_HUD = function()
    local ret = old_func()
    return G.MULTIPLAYER.HOOKS.create_UIBox_HUD(ret)
end

G.MULTIPLAYER.HOOKS.end_round = function (r) return r end
local old_func = end_round
end_round = function()
    local ret = old_func()
    return G.MULTIPLAYER.HOOKS.end_round(ret)
end