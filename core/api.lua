-- Queues an action
function queueaction(func, delay, trigger)
    if not trigger then
        G.E_MANAGER:add_event(Event({
        delay = delay,
        func = func
    }))
    else
        G.E_MANAGER:add_event(Event({
            trigger = trigger,
            delay = delay,
            func = func
        }))
    end
end

-- Pushes a button
function pushbutton(button, delay)
    queueaction(function()
        if button and button.config and button.config.button then
            G.FUNCS[button.config.button](button)
        end
        return true
    end, delay)
end

local function pushbutton_instant(button, delay)
    if button and button.config and button.config.button then
        G.FUNCS[button.config.button](button)
    end
end

function get_current_blind_chips()
    return get_blind_amount(G.GAME.round_resets.ante)*G.GAME.round_resets.blind.mult*G.GAME.starting_params.ante_scaling
end

-- Function to receive from tcp
function receive_from_tcp(block)
    local ret = nil
    if block then
        while ret == nil do
            ret = G.MULTIPLAYER.tcp:receive()
        end
    else
        ret = G.MULTIPLAYER.tcp:receive()
    end
    return ret
end

-- Function that sends and then receives from tcp
function talk_to_tcp(msg, block)
    G.MULTIPLAYER.tcp:send(msg)
    return receive_from_tcp(block)
end

function send_to_tcp(msg)
    G.MULTIPLAYER.tcp:send(msg)
end

-- Function to let me split by spaces
function split_by_word(msg)
    local ret = {}
    for w in msg:gmatch("%S+") do table.insert(ret, w) end
    return ret
end

function finish_round()
    queueaction(function()
            G.STATE_COMPLETE = false
            G.STATE = G.STATES.HAND_PLAYED 
            return true
        end, 0, 'after')
end