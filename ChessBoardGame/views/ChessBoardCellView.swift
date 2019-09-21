//
//  ChessBoardCellView.swift
//  ChessBoardGame
//
//  Created by Shidong Lin on 9/20/19.
//  Copyright © 2019 Shidong Lin. All rights reserved.
//

import Foundation
import UIKit

class ChessBoardCellView: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1.0
        backgroundColor = .lightGray
    }

    @available(*, unavailable, message: "Not implemented")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(to viewModel: ChessBoardCellViewModel) {
        backgroundColor = viewModel.cellBackgroundColor
    }
}
