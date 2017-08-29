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

class SudokuGame {

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
            
            checkRowAndColumnsFor(x, y)
            
            checkSectionFor(x, y)
        }
    }
    
    func checkRowAndColumnsFor(_ x: UInt, _ y: UInt) {
        for i in 0...8 {
            if i != y {
                highlightedCoordinates.insert(SudokuCoordinate(x: x, y: UInt(i)))
            }
            if i != x {
                highlightedCoordinates.insert(SudokuCoordinate(x: UInt(i), y: y))
            }
        }
    }
    
    func checkSectionFor(_ x: UInt, _ y: UInt) {
        let topLeftx = x / 3 * 3
        let topLefty = y / 3 * 3
        
        for i in topLeftx...topLeftx+2 {
            for j in topLefty...topLefty+2 {
                if i != x && j != y {
                    highlightedCoordinates.insert(SudokuCoordinate(x: UInt(i), y: UInt(j)))
                }
            }
        }
    }
}
