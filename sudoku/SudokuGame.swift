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

struct TryStack {
    fileprivate var testNumberArray: [SudokuCoordinate] = []
    
    mutating func push(_ element: SudokuCoordinate) {
        testNumberArray.append(element)
    }
    
    mutating func pop() -> SudokuCoordinate? {
        return testNumberArray.popLast()
    }
    
    func peek() -> SudokuCoordinate? {
        return testNumberArray.last
    }
}

class SudokuGame {
    
    //    var board: [Int?] = [nil,nil,nil,2,nil,4,8,1,nil,nil,4,nil,nil,nil,8,2,6,3,3,nil,nil,1,6,nil,nil,nil,4,1,nil,nil,nil,4,nil,5,8,nil,6,3,5,8,2,nil,nil,nil,7,2,nil,nil,5,9,nil,1,nil,nil,9,1,nil,7,nil,nil,nil,4,nil,nil,nil,nil,6,8,nil,7,nil,1,8,nil,nil,4,nil,3,nil,5,nil]
    
//    var board: [Int?] = [nil,nil,1,nil,3,nil,nil,9,nil,nil,nil,7,nil,9,5,1,2,nil,nil,nil,nil,nil,nil,8,nil,nil,4,8,nil,nil,4,nil,2,nil,7,nil,nil,nil,nil,nil,6,nil,nil,nil,nil,nil,9,nil,7,nil,3,nil,nil,6,6,nil,nil,9,nil,nil,nil,nil,nil,nil,5,4,3,2,nil,8,nil,nil,nil,1,nil,nil,4,nil,2,nil,nil]
    
        var board: [Int?] = [nil,2,4,nil,nil,7,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,8,nil,nil,nil,2,9,8,nil,nil,4,6,nil,5,nil,nil,nil,3,nil,nil,nil,nil,9,nil,1,nil,2,nil,nil,nil,nil,8,nil,nil,nil,7,nil,5,4,nil,nil,1,2,6,nil,nil,nil,9,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,5,nil,nil,8,6,nil]
    
    var originalBoard: [SudokuCoordinate] = []
    var updatedBoard: [SudokuCoordinate] = []
    
    var tryStack = TryStack()
    
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
    
    func weedOut() {
        var toWeedOrNotToWeed = false
        for i in 0 ... board.count - 1 {
            if let cell = board[i] {
                if !originalBoard.contains(i.sudokuCoordinate()) {
                    boardConstraints.addConstraints(of: cell, to: i)
                    boardConstraints.boredBoard[i].possibleNumbers.removeAll()
                    boardConstraints.boredBoard[i].possibleNumbers.append(board[i]!)
                    originalBoard.append(i.sudokuCoordinate())
                }
            }
        }
        if !checkIfSolveable() {
//            shitHittingTheFan()
            print("unable to solve or something")
            return
        }
        for i in 0 ... board.count - 1 {
            if boardConstraints.boredBoard[i].possibleNumbers.count == 1 && !updatedBoard.contains(i.sudokuCoordinate()) {
                board[i] = boardConstraints.boredBoard[i].possibleNumbers.first
                updatedBoard.append(i.sudokuCoordinate())
                toWeedOrNotToWeed = true
            }
        }
        if toWeedOrNotToWeed {
            weedOut()
        }
        unique()
        weedWithUnique()
//        var solved = true
//        for i in 0 ... board.count - 1 {
//            if board[i] == nil {
//                solved = false
//                break
//            }
//        }
//        if !solved {
//            board[findLeastPossibility().integer()] = boardConstraints.boredBoard[findLeastPossibility().integer()].possibleNumbers.popLast()
//            tryStack.push(findLeastPossibility())
//            weedOut()
//        }
    }
    
    func unique() {
        var shouldWeed = false
        for i in 0 ... board.count - 1 {
            if board[i] == nil {
                var currentCell = Set(boardConstraints.boredBoard[i].possibleNumbers) // this is set for current cell
                let sectionCells = boardConstraints.affectedSectionCoordinates(i.sudokuCoordinate().x, i.sudokuCoordinate().y)
                
                //Build a set of options from all the other 8 cells
                var remainingPossibilities: Set<Int> = []
                for sectionCell in sectionCells {
                    remainingPossibilities.formUnion(boardConstraints.boredBoard[sectionCell.integer()].possibleNumbers)
                }
                
                currentCell.subtract(remainingPossibilities) //do a diff between the 2 sets
                
                if currentCell.count == 1 {
                    board[i] = currentCell.first //set the diff as the number
                    shouldWeed = true
                }
            }
        }
        if shouldWeed {
            weedOut()
        }
    }
    
    func weedWithUnique() {
        var shouldUpdate = false
        for i in 0 ... board.count - 1 {
            if board[i] == nil {
                let currentCell = Set(boardConstraints.boredBoard[i].possibleNumbers) // this is set for current cell
                let x = i.sudokuCoordinate().x
                let y = i.sudokuCoordinate().y
                var numberOfMatchesForX = 0
                var numberOfMatchesForY = 0
                var possibleCoordinateForRow: [SudokuCoordinate] = []
                var possibleCoordinateForColumn: [SudokuCoordinate] = []
                
                for j in 0 ... 8 {
                    if j != x && currentCell == Set(boardConstraints.boredBoard[SudokuCoordinate(x: UInt(j), y: y).integer()].possibleNumbers) {
                        possibleCoordinateForRow.append(SudokuCoordinate(x: UInt(j), y: y))
                        numberOfMatchesForX += 1
                    }
                    if j != y && currentCell == Set(boardConstraints.boredBoard[SudokuCoordinate(x: x, y: UInt(j)).integer()].possibleNumbers) {
                        possibleCoordinateForColumn.append(SudokuCoordinate(x: x, y: UInt(j)))
                        numberOfMatchesForY += 1
                    }
                }
                if currentCell.count == numberOfMatchesForX {
                    for k in 0 ... 8 {
                        let row = SudokuCoordinate(x: UInt(k), y: y)
                        if !possibleCoordinateForRow.contains(row) {
                            for number in 0 ... currentCell.count - 1 {
                                boardConstraints.boredBoard[row.integer()].addConstraints(Array(currentCell)[number])
                            }
                        }
                    }
                    shouldUpdate = true
                }
                if currentCell.count == numberOfMatchesForY {
                    for k in 0 ... 8 {
                        let column = SudokuCoordinate(x: x, y: UInt(k))
                        if !possibleCoordinateForRow.contains(column) {
                            for number in 0 ... currentCell.count - 1 {
                                boardConstraints.boredBoard[column.integer()].addConstraints(Array(currentCell)[number])
                            }
                        }
                    }
                    shouldUpdate = true
                }
            }
        }
        if shouldUpdate {
            weedOut()
        }
    }
    
    func checkIfSolveable() -> Bool {
        let solveable = true
        for i in 0 ... board.count - 1 {
            if boardConstraints.boredBoard[i].possibleNumbers.count == 0 {
                return false
            }
        }
        return solveable
    }
    
    func findLeastPossibility() -> SudokuCoordinate {
        var cell = 0.sudokuCoordinate()
        var counter = 9
        for i in 0 ... board.count - 1 {
            if board[i] == nil {
                if boardConstraints.boredBoard[i].possibleNumbers.count < counter {
                    cell = i.sudokuCoordinate()
                    counter = boardConstraints.boredBoard[i].possibleNumbers.count
                }
            }
        }
        return cell
    }
    
    func shitHittingTheFan() {
        let theNumber = board[(tryStack.peek()?.integer())!]
        
        board[(tryStack.peek()?.integer())!] = boardConstraints.boredBoard[findLeastPossibility().integer()].possibleNumbers.popLast()
        tryStack.push(findLeastPossibility())
    }
}
