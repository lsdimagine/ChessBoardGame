//
//  ChessBoardController.swift
//  ChessBoardGame
//
//  Created by Shidong Lin on 9/20/19.
//  Copyright © 2019 Shidong Lin. All rights reserved.
//

import Foundation

enum Player {
    case player1
    case player2
    case none

    func playText() -> String {
        switch self {
        case .player1:
            return "Player1 to play"
        case .player2:
            return "Player2 to play"
        case .none:
            return ""
        }
    }

    func wonText() -> String {
        switch self {
        case .player1:
            return "Player1 won"
        case .player2:
            return "Player2 won"
        case .none:
            return ""
        }
    }
}

enum Result {
    case success(Int, Int)
    case fail
}

class ChessBoardController {
    let rowCount: Int
    let colCount: Int
    private(set) var wonPlayer = Player.none
    private(set) var currentPlayer = Player.player1
    private let winCount: Int
    private(set) var cellModels = [[ChessBoardCellModel]]()

    init(rowCount: Int, colCount: Int, winCount: Int) {
        self.rowCount = rowCount
        self.colCount = colCount
        self.winCount = winCount
        for _ in 0..<rowCount {
            var rowModels = [ChessBoardCellModel]()
            for _ in 0..<colCount {
                rowModels.append(ChessBoardCellModel(selectedPlayer: .none))
            }
            cellModels.append(rowModels)
        }
    }
    
    func tapCellAt(row: Int, col: Int, _ completion: ((Result) -> Void)) {
        if wonPlayer != .none {
            completion(.fail)
            return
        }

        var selectedRow = -1
        for (rowIdx, cellRow) in cellModels.enumerated().reversed() {
            if cellRow[col].selectedPlayer == .none {
                selectedRow = rowIdx
                break
            }
        }

        if selectedRow == -1 {
            completion(.fail)
        } else {
            cellModels[selectedRow][col] = ChessBoardCellModel(selectedPlayer: currentPlayer)
            if isWonAtRow(selectedRow, col: col) {
                // Update wonplayer
                wonPlayer = currentPlayer
            } else {
                // Update to next player to play
                currentPlayer = (currentPlayer == .player1) ? .player2 : .player1
            }
            completion(.success(selectedRow, col))
        }
    }

    private func isWonAtRow(_ row: Int, col: Int) -> Bool {
        let horizontalCount = countSameColor(row, col, [(0, 1), (0, -1)])
        if horizontalCount >= winCount {
            return true
        }

        let verticalCount = countSameColor(row, col, [(1, 0), (-1, 0)])
        if verticalCount >= winCount {
            return true
        }

        let diacount = countSameColor(row, col, [(1, 1), (-1, -1)])
        if diacount >= winCount {
            return true
        }
        return false
    }

    private func countSameColor(_ row: Int, _ col: Int, _ dirs: [(Int, Int)]) -> Int {
        let player = cellModels[row][col].selectedPlayer
        if player == .none {
            return 0
        }

        var res = 0
        for dir in dirs {
            var currentRow = row, currentCol = col
            while (0..<cellModels.count).contains(currentRow) && (0..<cellModels[0].count).contains(currentCol) {
                if cellModels[currentRow][currentCol].selectedPlayer == player {
                    res += 1
                } else {
                    break
                }
                currentRow += dir.0
                currentCol += dir.1
            }
        }
        return res - dirs.count + 1
    }
}
