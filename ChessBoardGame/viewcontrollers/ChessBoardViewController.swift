//
//  ChessBoardViewController.swift
//  ChessBoardGame
//
//  Created by Shidong Lin on 9/20/19.
//  Copyright © 2019 Shidong Lin. All rights reserved.
//

import Foundation
import UIKit

class ChessBoardViewController: UIViewController {
    private let rowCount = 20
    private let colCount = 20
    private let winCount = 4
    private var cellDimension: CGFloat = 30.0
    private let cellSpacing: CGFloat = 0.0
    private let flowLayout: ChessCollectionViewFlowLayout
    private let collectionView: UICollectionView
    private let boardController: ChessBoardController
    private let cellIdentifier = "ChessBoardCellView"
    private let statusLabel = UILabel()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        flowLayout = ChessCollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        boardController = ChessBoardController(rowCount: rowCount,
                                               colCount: colCount,
                                               winCount: winCount)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    @available(*, unavailable, message: "Not implemented")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "ChessBoard"

        view.backgroundColor = .white
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ChessBoardCellView.self, forCellWithReuseIdentifier: cellIdentifier)
        view.addSubview(collectionView)

        view.addSubview(statusLabel)

        cellDimension = view.bounds.width / CGFloat(colCount)
        flowLayout.itemSize = CGSize(width: cellDimension, height: cellDimension)
        flowLayout.minimumLineSpacing = cellSpacing
        flowLayout.minimumInteritemSpacing = cellSpacing
        flowLayout.scrollDirection = .vertical

        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        flowLayout.contentSize = CGSize(width: cellDimension * CGFloat(colCount) + cellSpacing * CGFloat(colCount - 1), height: cellDimension * CGFloat(rowCount) + cellSpacing * CGFloat(rowCount - 1))
        NSLayoutConstraint.activate([
            statusLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5.0),
            statusLabel.leftAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leftAnchor),
            statusLabel.rightAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.rightAnchor),
            statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collectionView.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 5.0),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
        ])
        updateStatusLabel()
        collectionView.reloadData()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(didTapRestart))
    }

    private func updateStatusLabel() {
        if boardController.wonPlayer != .none {
            statusLabel.text = "\(boardController.currentPlayer.wonText()) total: \(CoreDataManager.shared.fetchWinCount(forPlayer: boardController.wonPlayer.rawValue))"
        } else {
            statusLabel.text = boardController.currentPlayer.playText()
        }
    }

    @objc private func didTapRestart() {
        boardController.restart()
        collectionView.reloadData()
        updateStatusLabel()
    }
}

extension ChessBoardViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let totalCellWidth = cellDimension * CGFloat(boardController.colCount)
        let totalSpacingWidth = cellSpacing * CGFloat(boardController.colCount - 1)

        let leftInset = (collectionView.frame.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
        let rightInset = leftInset

        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row = indexPath.row / colCount, col = indexPath.row % colCount
        boardController.tapCellAt(row: row, col: col) { [weak self] (result) in
            switch(result) {
            case .success(let row, let col):
                self?.collectionView.reloadItems(at: [IndexPath(row: row * colCount + col, section: 0)])
                self?.updateStatusLabel()
            case .fail:
                break
            }
        }
    }
}

extension ChessBoardViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return boardController.rowCount * boardController.colCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? ChessBoardCellView {
            let row = indexPath.row / colCount, col = indexPath.row % colCount
            let model = boardController.cellModels[row][col]
            let viewModel = ChessBoardCellViewModel(model: model)
            cell.bind(to: viewModel)
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}

class ChessCollectionViewFlowLayout: UICollectionViewFlowLayout {
    var contentSize = CGSize.zero
}
