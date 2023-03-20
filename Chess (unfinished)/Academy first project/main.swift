//
//  main.swift
//  Academy first project
//
//  Created by Breno Harris on 14/03/23.
//

/*  TODO
 movimentos
 verificacao de check
 criacao da jogada
 */

/*
 Reflexoes
 
 *isAlive eh uma propriedade inutil para a nossa implementacao
 
 *Coord poderia ter sido uma struct
 
 *fazer a parte de logica de movimento das pecas era mais dificil que eu pensava
 
 *Piece poderia ter sido um protocolo
 
 *Em muitas ocasioes foi usado o force-unwrap, o que nao foi uma boa pratica
 
 -- O que aprendemos:
 - portar os conhecimentos de outras linguagens orientadas a obj para swift
 - tratar alguns casos com Optional
 
 -- O que eu gostei:
 - fazer a orientacao a objetos de maneira semelhante a java, mas menos verboso
 
 
 
 */

enum Team {
    case black
    case white
}

class Coord {
    private var line: Int
    private var column: Int
    
    init(exp: String) {
        column = Int(exp.utf8.first!) - Int("a".utf8.first!) + 1
        line = Int(exp.utf8.last!) - Int("0".utf8.first!)
    }
    
    func getLine() -> Int {
        return line
    }
    func getColumn() -> Int {
        return column
    }
}

class Piece: Equatable {
    static func == (lhs: Piece, rhs: Piece) -> Bool {
        if lhs.getPosition().getLine() == rhs.getPosition().getLine() &&
            lhs.getPosition().getColumn() == rhs.getPosition().getColumn(){
            return true
        }
        return false
    }
    
    private var role: String
    private var isAlive: Bool
    private var team: Team
    private var coord: Coord
    
    init(role: String, isAlive: Bool, team: Team, posicao: Coord) {
        self.role = role
        self.isAlive = isAlive
        self.team = team
        self.coord = posicao
    }
    
    func getPosition() -> Coord {
        return self.coord
    }
    
    func setPosition(newCoord: Coord) {
        self.coord = newCoord
    }
    
    func getRole() -> String {
        return self.role
    }
}

class Rook: Piece {
    override init(role: String, isAlive: Bool, team: Team, posicao: Coord) {
        super.init(role: role, isAlive: true, team: team, posicao: posicao)
    }
}

class Bishop: Piece {
    override init(role: String, isAlive: Bool, team: Team, posicao: Coord) {
        super.init(role: role, isAlive: true, team: team, posicao: posicao)
    }
}

class Knight: Piece {
    override init(role: String, isAlive: Bool, team: Team, posicao: Coord) {
        super.init(role: role, isAlive: true, team: team, posicao: posicao)
    }
}

class Queen: Piece {
    override init(role: String, isAlive: Bool, team: Team, posicao: Coord) {
        super.init(role: role, isAlive: true, team: team, posicao: posicao)
    }
}

class King: Piece {
    private var check: Bool
    
    override init(role: String, isAlive: Bool, team: Team, posicao: Coord) {
        self.check = false
        super.init(role: role, isAlive: true, team: team, posicao: posicao)

    }
}

class Pawn: Piece {
    private var promotion: Bool
    
    override init(role: String, isAlive: Bool, team: Team, posicao: Coord) {
        self.promotion = false
        super.init(role: role, isAlive: true, team: team, posicao: posicao)
    }
}

class Play {
    /*
     o que uma jogada precisa?
     uma origem, um destino
     as pecas envolvidas no tabuleiro
     o fato dela ser uma jogada valida ou nao? (podemos implementar isso depois)
     
     */
    private var origin: Coord
    private var destination: Coord
    private var pieces: [Piece]
    private var valid: Bool
    private var player: Team
    
    init(sentence: String, pieces: [Piece], player: Team) {
        let move = sentence.split(separator: " ")
        origin = Coord(exp: String(move[0]))
        destination = Coord(exp: String(move[1]))
        self.pieces = pieces
        self.valid = true
        self.player = player
    }
    
    func update(board: [[String]]) -> Bool {
        var gameContinues = true
        var pieceInPlay: Piece?
        var attackedPiece: Piece?
        for piece in pieces {
            if piece.getPosition().getLine() == origin.getLine() &&
                piece.getPosition().getColumn() == origin.getColumn() {
                pieceInPlay = piece
            }
            
            if piece.getPosition().getLine() == destination.getLine() &&
                piece.getPosition().getColumn() == destination.getColumn() {
                attackedPiece = piece
            }
        }
        
        if let piece = attackedPiece {
            if let _ = piece as? King {
                gameContinues = false
            }
            
            let index = pieces.firstIndex(of: piece)!
            pieces.remove(at: index)
        }
        
        if let piece = pieceInPlay {
            piece.setPosition(newCoord: destination)
        }
        
        populateBoard(pieces: pieces, board: board)
        
        
        return gameContinues
    }
}

func populateBoard(pieces: [Piece], board: [[String]]) {
    let dummyColumn = ["  |--+--+--+--+--+--+--+--|"]
    var dummyBoard = board
    for piece in pieces {
        dummyBoard[piece.getPosition().getLine()-1][piece.getPosition().getColumn()] = piece.getRole()
    }
    dummyBoard.forEach({line in
        print(dummyColumn[0])
        line.forEach({elem in
            print(elem, terminator: "")
        })
        print("\n", terminator: "")
    })
    
}

var piecesInField = [Piece]()
var board = [[String]]()
let colunas = ["  ", " A ", " B ", " C ", " D ", " E ", " F ", " G ", " H "]

for i in 1...8 {
    var auxBoard = [String]()
    auxBoard.append(String(i) + " |")
    for _ in 0...7 {
        auxBoard.append("  |")
    }
    board.append(auxBoard)
}
board.append(colunas)


for i in 0...7 {
    let pawnWhite = Pawn(role: " ♟|", isAlive: true, team: .white, posicao: Coord(exp: String(String(UnicodeScalar(i+97)!) + "7")))
    
    let pawnBlack = Pawn(role: " ♙|", isAlive: true, team: .black, posicao: Coord(exp: String(String(UnicodeScalar(i+97)!) + "2")))
    
    piecesInField.append(pawnWhite)
    piecesInField.append(pawnBlack)
}

for i in 0...1 {
    let rookWhite = Rook(role: " ♜|", isAlive: true, team: .white, posicao: Coord(exp: String(String(UnicodeScalar(i*7 + 97)!) + "8")))
    let rookBlack = Rook(role: " ♖|", isAlive: true, team: .black, posicao: Coord(exp: String(String(UnicodeScalar(i*7 + 97)!) + "1")))
    
    let knightWhite = Knight(role: " ♞|", isAlive: true, team: .white, posicao: Coord(exp: String(String(UnicodeScalar(i*5 + 98)!) + "8")))
    let knightBlack = Knight(role: " ♘|", isAlive: true, team: .black, posicao: Coord(exp: String(String(UnicodeScalar(i*5 + 98)!) + "1")))
    
    let bishopWhite = Bishop(role: " ♝|", isAlive: true, team: .white, posicao: Coord(exp: String(String(UnicodeScalar(i*3 + 99)!) + "8")))
    let bishopBlack = Knight(role: " ♗|", isAlive: true, team: .black, posicao: Coord(exp: String(String(UnicodeScalar(i*3 + 99)!) + "1")))
    
    piecesInField.append(rookWhite)
    piecesInField.append(rookBlack)
    piecesInField.append(knightWhite)
    piecesInField.append(knightBlack)
    piecesInField.append(bishopWhite)
    piecesInField.append(bishopBlack)
}

let whiteQueen = Queen(role: " ♛|", isAlive: true, team: .white, posicao: Coord(exp: String(String(UnicodeScalar(100)!) + "8")))
let blackQueen = Queen(role: " ♕|", isAlive: true, team: .black, posicao: Coord(exp: String(String(UnicodeScalar(100)!) + "1")))
let whiteKing = King(role: " ♚|", isAlive: true, team: .white, posicao: Coord(exp:
    String(String(UnicodeScalar(101)!) + "8")))
let blackKing = King(role: " ♔|", isAlive: true, team: .black, posicao: Coord(exp:
    String(String(UnicodeScalar(101)!) + "1")))

piecesInField.append(whiteQueen)
piecesInField.append(blackQueen)
piecesInField.append(whiteKing)
piecesInField.append(blackKing)

//introduction
print("""
                                                                 _:_
                                                                '-.-'
                                                       ()      __.'.__
                                                    .-:--:-.  |_______|
                                             ()      \\____/    \\=====/
                                             /\\      {====}     )___(
                                  (\\=,      //\\\\      )__(     /_____\\
                  __    |'-'-'|  //  .\\    (    )    /____\\     |   |
                 /  \\   |_____| (( \\_  \\    )__(      |  |      |   |
                 \\__/    |===|   ))  `\\_)  /____\\     |  |      |   |
                /____\\   |   |  (/     \\    |  |      |  |      |   |
                 |  |    |   |   | _.-'|    |  |      |  |      |   |
                 |__|    )___(    )___(    /____\\    /____\\    /_____\\
                (====)  (=====)  (=====)  (======)  (======)  (=======)
                }===={  }====={  }====={  }======{  }======{  }======={
               (______)(_______)(_______)(________)(________)(_________)

                WELCOME to my silly chess game ♙ ♖ ♘ ♗ ♕ ♔

                Moving a chess piece: type the coordinates of the piece you want to move
                and the coordinates of where you want it to move to (ie: "e7 e5"
                moves a piece from e7 to e5)

                Press ENTER to begin playing!!
""")
let _ = readLine()

populateBoard(pieces: piecesInField, board: board)
var movesMade = 0
var gameContinues = true
while gameContinues {
    var currentPlayer: Team
    if movesMade % 2 == 0 {
        currentPlayer = .white
    } else {
        currentPlayer = .black
    }
    print("Make your move \(currentPlayer): ")
    let movimento = readLine()!
    let jogada = Play(sentence: movimento, pieces: piecesInField, player: currentPlayer)
    gameContinues = jogada.update(board: board)
    movesMade += 1
    if !gameContinues {
        print("""
                                                                       .::.
                                                            _()_       _::_
                                                  _O      _/____\\_   _/____\\_
                           _  _  _     ^^__      / //\\    \\      /   \\      /
                          | || || |   /  - \\_   {     }    \\____/     \\____/
                          |_______| <|    __<    \\___/     (____)     (____)
                    _     \\__ ___ / <|    \\      (___)      |  |       |  |
                   (_)     |___|_|  <|     \\      |_|       |__|       |__|
                  (___)    |_|___|  <|______\\    /   \\     /    \\     /    \\
                  _|_|_    |___|_|   _|____|_   (_____)   (______)   (______)
                 (_____)  (_______) (________) (_______) (________) (________)
                 /_____\\  /_______\\ /________\\ /_______\\ /________\\ /________\\
              
                    Game ended!! The winner is player \(currentPlayer)!!
            """)
    }
}

