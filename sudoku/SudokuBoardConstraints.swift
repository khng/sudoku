//
//  SudokuBoardConstraints.swift
//  sudoku
//
//  Created by Pivotal - Dev 53 on 2017-08-29.
//  Copyright © 2017 Pivotal - Dev 53. All rights reserved.
//

import UIKit

extension Array {
    public init(count: Int, elementCreator: @autoclosure () -> Element) {
        self = (0 ..< count).map { _ in elementCreator() }
    }
}

class SudokuBoardConstraints {
    
    var boredBoard: [SudokuCellConstraints] = Array(count: 81, elementCreator: SudokuCellConstraints())
    
    func addConstraints(of number: Int, to cell: Int) {
        for affectedIndex in affectedCoordinates(cell.sudokuCoordinate().x, cell.sudokuCoordinate().y) {
            boredBoard[affectedIndex.integer()].addConstraints(number)
        }
    }
    
    func removeConstraints(of number: Int, to cell: Int) {
        for affectedIndex in affectedCoordinates(cell.sudokuCoordinate().x, cell.sudokuCoordinate().y) {
            boredBoard[affectedIndex.integer()].removeConstraints(number)
        }
    }
    
    func affectedRowAndColumnsCoordinates(_ x: UInt, _ y: UInt) -> [SudokuCoordinate] {
        var arrayToReturn: [SudokuCoordinate] = []
        
        for i in 0...8 {
            if i != y {
                arrayToReturn.append(SudokuCoordinate(x: x, y: UInt(i)))
            }
            if i != x {
                arrayToReturn.append(SudokuCoordinate(x: UInt(i), y: y))
            }
        }
        
        return arrayToReturn
    }
    
    func affectedSectionCoordinates(_ x: UInt, _ y: UInt) -> [SudokuCoordinate] {
        var arrayToReturn: [SudokuCoordinate] = []
        
        let topLeftx = x / 3 * 3
        let topLefty = y / 3 * 3
        
        for i in topLeftx...topLeftx+2 {
            for j in topLefty...topLefty+2 {
//                if i != x && j != y {
                if !(i == x && j == y) {
                    arrayToReturn.append(SudokuCoordinate(x: UInt(i), y: UInt(j)))
                }
//                }
            }
        }
        
        return arrayToReturn
    }
    
    func affectedCoordinates(_ x: UInt, _ y: UInt) -> [SudokuCoordinate] {
        var affectedSections = affectedRowAndColumnsCoordinates(x, y)
        affectedSections.append(contentsOf: affectedSectionCoordinates(x, y))
        
        return Array(Set(affectedSections))
    }
    
}
