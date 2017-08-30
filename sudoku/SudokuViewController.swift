//
//  SudokuViewController.swift
//  sudoku
//
//  Created by Pivotal - Dev 53 on 2017-08-21.
//  Copyright © 2017 Pivotal - Dev 53. All rights reserved.
//

import UIKit

extension SudokuCoordinate {
    func indexPath() -> IndexPath {
        let item = y * 9 + x
        return IndexPath(item: Int(item), section: 0)
    }
}

extension IndexPath {
    func sudokuCoordinate() -> SudokuCoordinate {
        let x = item % 9
        let y = item / 9
        return SudokuCoordinate(x:UInt(x), y:UInt(y))
    }
}

class SudokuViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    var highlighted = IndexPath()
    var counter = 0
    let sudokuGame = SudokuGame()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        let nib: UINib = UINib.init(nibName: "SudokuCollectionViewCell", bundle: Bundle.main)
        self.collectionView.register(nib, forCellWithReuseIdentifier: "cell")
        
        let dimension = UIScreen.main.bounds.width / 9

        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.itemSize = CGSize(width: dimension, height: dimension)
        layout.minimumInteritemSpacing = CGFloat(0)
        layout.minimumLineSpacing = CGFloat(0)
        
        collectionView.collectionViewLayout = layout
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 81
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SudokuCollectionViewCell
        
        if sudokuGame.selectedState(for: indexPath.sudokuCoordinate()) {
            cell.cellView.backgroundColor = .darkGray
        } else if sudokuGame.highlightedState(for: indexPath.sudokuCoordinate()) {
            cell.cellView.backgroundColor = .lightGray
        } else {
            cell.cellView.backgroundColor = .white
        }
        
        if let setNumbers = sudokuGame.board[indexPath.row] {
            cell.cellLabel.text = String(setNumbers)
            cell.cellLabel.textColor = .white
            cell.cellLabel.font = UIFont.boldSystemFont(ofSize: 23)
            cell.cellView.backgroundColor = UIColor(red: 65/255, green: 126/255, blue: 224/255, alpha: 1)
            cell.isUserInteractionEnabled = false
        } else {
            cell.cellLabel.text = ""
            cell.isUserInteractionEnabled = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var previouslySelectedAndHighlightedIndexPaths: [IndexPath] = sudokuGame.highlightedCoordinates.map { (coordinate) -> IndexPath in
            return coordinate.indexPath()
        }
        if let selectedCoordinate = sudokuGame.selectedCoordinate {
            previouslySelectedAndHighlightedIndexPaths.append(selectedCoordinate.indexPath())
        }
        
        sudokuGame.selectedCoordinate = indexPath.sudokuCoordinate()
        
        var indexPathsToReload = sudokuGame.highlightedCoordinates.map { (coordinate) -> IndexPath in
            return coordinate.indexPath()
        }
        
        indexPathsToReload.append(indexPath)
        indexPathsToReload.append(contentsOf: previouslySelectedAndHighlightedIndexPaths)
        
        collectionView.reloadItems(at: Array(Set(indexPathsToReload)))
    }
}
