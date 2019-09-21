//
//  ChessBoardCellViewModel.swift
//  ChessBoardGame
//
//  Created by Shidong Lin on 9/20/19.
//  Copyright © 2019 Shidong Lin. All rights reserved.
//

import Foundation
import UIKit

struct ChessBoardCellViewModel {
    let model: ChessBoardCellModel

    var cellBackgroundColor: UIColor {
        switch model.selectedPlayer {
        case .player1:
            return UIColor.black
        case .player2:
            return UIColor.white
        case .none:
            return UIColor.lightGray
        }
    }
}
