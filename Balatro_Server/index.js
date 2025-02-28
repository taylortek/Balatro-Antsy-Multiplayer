// This code is trying it's best...

const { argv } = require('node:process');
const net = require('net');

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

sockets = []

const blockList = new net.BlockList();
//blockList.addAddress("::ffff:127.0.0.1", 'ipv6')

rounds_to_win = 3

if (argv.length > 2) {
    rounds_to_win = Number(argv[2])
    console.log("Setting rounds to win to " + rounds_to_win)
}

console.log("Starting Balatro Server...")

const server = net.createServer(function (socket) {
    if (blockList.check(socket.remoteAddress, 'ipv6')) {
        console.log("Tried to get a connection from: " + socket.remoteAddress)
        socket.destroy()
    } else {
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
                socket.write("[Set] Rounds_To_Win " + rounds_to_win + "\n")
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
            case "[Spectral_Action]":
                switch (command[1]){
                    case "[Spam_Mail]":
                        sockets[opponent_number-1].write("[Add_Joker] " + command[2] + " eternal " + command[3] + "\n")
                        break
                    case "[Jumpscare]":
                        sockets[opponent_number-1].write("[Up_Ante]\n")
                        break
                }
                break
        }
    });

    socket.on('end', () => {
        console.log("Player " + player_number + " disconnected")
        if (sockets.length > 1) {
            sockets[opponent_number-1].write("[Other_Player_Disconnect]\n")
        }
        players = []
        sockets = []
    })
    }
})

server.maxConnections = 2
server.listen(12345);