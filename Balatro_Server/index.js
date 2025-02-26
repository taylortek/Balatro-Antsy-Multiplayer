// This code is trying it's best...

class Player {
    id = 0
    round = -1
     Player(id) {
        this.id = id
    }
    waiting = false
    chips = 0
}

players = []
seed = ""
total_chips = 0
total_hands = 0

sockets = [{}, {}]

require('net').createServer(function (socket) {
    players.push(new Player(players.length+1))
    console.log("Player " + players.length + " joined");
    
    let player_number = players.length
    let opponent_number = 0
    if (player_number == 1) {
        opponent_number = 2
        sockets[0] = socket
    } else {
        opponent_number = 1
        sockets[1] = socket
    }

    socket.on('data', function (data) {
        let command = data.toString().split(" ")
        console.log("Player [" + player_number + "]: " + data.toString());
        switch (data.toString()) {
            case "Get Player Number":
                console.log("[Server] Fetching player number")
                socket.write(String(player_number)+"\n")
                break
            case "Get Seed":
                if (seed != "") {
                    socket.write(seed+"\n")
                 } else {
                    socket.write("null\n")
                }
                break
        }
        switch (command[0]) {
            case "SEED":
                seed = command[1]
                break
            case "ROUND":
                players[player_number-1].round = command[1]
                break
            case "HANDS":
                sockets[opponent_number-1].write("[Add_Hands] " + command[1] + "\n")
                break
            case "[Hand_Played]":
                players[player_number-1].chips += Number(command[1])
                sockets[opponent_number-1].write("[Opponent_Chips] " + players[player_number-1].chips + "\n")
                break
            case "[Selected_Blind]":
                players[player_number-1].chips = 0
                players[opponent_number-1].chips = 0
                if (command[1] != "Small_Blind" && command[1] != "Big_Blind") {
                    if (!players[opponent_number-1].waiting) {
                        socket.write("[Wait]\n")
                        players[player_number-1].waiting = true
                    } else {
                        sockets[opponent_number-1].write("[Stop_Wait]\n")
                        players[opponent_number-1].waiting = false
                    }
                }
                console.log("[Server] Blind selected")
                break
            case "[Skipped_Blind]":
                sockets[opponent_number-1].write("[Skip_Blind]\n")
                console.log("[Server] Skipping Blind")
                break
            case "[Cashed_Out]":
                sockets[opponent_number-1].write("[Cash_Out]\n")
                console.log("[Server] Cashing Out")
                break
            case "[Left_Shop]":
                sockets[opponent_number-1].write("[Leave_Shop]\n")
                console.log("[Server] Leaving Shop")
                break
            case "[Beat_Boss]":
                if (!players[opponent_number-1].waiting) {
                    socket.write("[Wait]\n")
                    players[player_number-1].waiting = true
                } else {
                    sockets[opponent_number-1].write("[Stop_Wait]\n")
                    players[opponent_number-1].waiting = false
                    if (players[opponent_number-1].chips < players[player_number-1].chips) {
                        socket.write("[Won_Round]\n")
                        sockets[opponent_number-1].write("[Lost_Round]\n")
                    } else if (players[opponent_number-1].chips > players[player_number-1].chips) {
                        socket.write("[Lost_Round]\n")
                        sockets[opponent_number-1].write("[Won_Round]\n")
                    } else {
                        socket.write("[Tied_Round]\n")
                        sockets[opponent_number-1].write("[Tied_Round]\n")
                    }
                }
                break
            case "[Lost_Round]":
                socket.write("[Lost_Game]\n")
                sockets[opponent_number-1].write("[Won_Game]\n")
                break
        }
    });
})

.listen(12345);