//
//  SudokuGame.swift
//  sudoku
//
//  Created by Pivotal - Dev 53 on 2017-08-27.
//  Copyright © 2017 Pivotal - Dev 53. All rights reserved.
//

import UIKit
// use as a shortcut 
//typealias SudokuCoordinate = SudokuGame.SudokuCoordinate

struct SudokuCoordinate: Equatable, Hashable {
    let x: UInt
    let y: UInt
    
    // implement equatable for struct
    static func ==(lhs: SudokuCoordinate, rhs: SudokuCoordinate) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
    
    var hashValue: Int {
        // this comes from apple docs... don't question
        return x.hashValue ^ y.hashValue &* 16777619
    }
}

extension SudokuCoordinate {
    func integer() -> Int {
        return Int(y) * 9 + Int(x)
    }
}

extension Int {
    func sudokuCoordinate() -> SudokuCoordinate {
        let x = self % 9
        let y = self / 9
        return SudokuCoordinate(x:UInt(x), y:UInt(y))
    }
}

class SudokuGame {
    
    let board: [Int?] = [nil,nil,nil,2,nil,4,8,1,nil,nil,4,nil,nil,nil,8,2,6,3,3,nil,nil,1,6,nil,nil,nil,4,1,nil,nil,nil,4,nil,5,8,nil,6,3,5,8,2,nil,nil,nil,7,2,nil,nil,5,9,nil,1,nil,nil,9,1,nil,7,nil,nil,nil,4,nil,nil,nil,nil,6,8,nil,7,nil,1,8,nil,nil,4,nil,3,nil,5,nil]
    
    let boardConstraints = SudokuBoardConstraints()
    
    var selectedCoordinate: SudokuCoordinate? {
        didSet {
            updateGame()
        }
    }
    
    var highlightedCoordinates: Set<SudokuCoordinate> = []
    
    func selectedState(for coordinate: SudokuCoordinate) -> Bool {
        return selectedCoordinate == coordinate
    }
    
    func highlightedState(for coordinate: SudokuCoordinate) -> Bool {
        return highlightedCoordinates.contains(coordinate)
    }
    
    func updateGame() {
        highlightedCoordinates.removeAll(keepingCapacity: true)
        if let selectedCoordinate = selectedCoordinate {
            let x = selectedCoordinate.x
            let y = selectedCoordinate.y
            
            highlightedCoordinates = Set(boardConstraints.affectedCoordinates(x, y))
        }
    }
    
}
