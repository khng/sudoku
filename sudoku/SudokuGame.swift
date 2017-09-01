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
    
    var board: [Int?] = [nil,nil,1,nil,3,nil,nil,9,nil,nil,nil,7,nil,9,5,1,2,nil,nil,nil,nil,nil,nil,8,nil,nil,4,8,nil,nil,4,nil,2,nil,7,nil,nil,nil,nil,nil,6,nil,nil,nil,nil,nil,9,nil,7,nil,3,nil,nil,6,6,nil,nil,9,nil,nil,nil,nil,nil,nil,5,4,3,2,nil,8,nil,nil,nil,1,nil,nil,4,nil,2,nil,nil]
    
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
        for i in 0...board.count - 1 {
            if let number = board[i] {
                if !originalBoard.contains(i.sudokuCoordinate()) {
                    boardConstraints.addConstraints(of: number, to: i)
                    originalBoard.append(i.sudokuCoordinate())
                }
            }
        }
        for i in 0...board.count - 1 {
            
            if boardConstraints.boredBoard[i].possibleNumbers.count ==  1 && !updatedBoard.contains(i.sudokuCoordinate()) {
                updatedBoard.append(i.sudokuCoordinate())
                board[i] = boardConstraints.boredBoard[i].possibleNumbers.first
                weedOut()
            }
            
        }
        if checkForZero() {
            backTrack()
        } else {
            tryOut()
        }
    }
    
    func checkForZero() -> Bool {
        for i in 0...board.count - 1 {
            if boardConstraints.boredBoard[i].possibleNumbers.count == 0 {
                return true
            }
        }
        return false
    }
    
    func backTrack() {
        let coordinate = tryStack.peek()
        let number = boardConstraints.boredBoard[(coordinate?.integer())!].possibleNumbers.last
        boardConstraints.removeConstraints(of: number!, to: (coordinate?.integer())!)
        boardConstraints.boredBoard[(coordinate?.integer())!].possibleNumbers.removeLast()
        updatedBoard.remove(at: updatedBoard.index(of: coordinate!)!)
        let _ = tryStack.pop()
        weedOut()
    }
    
    func tryOut() {
        let number = boardConstraints.boredBoard[findLowestNumberPossiblities().integer()].possibleNumbers.last
        tryStack.testNumberArray.append(findLowestNumberPossiblities())
        board[findLowestNumberPossiblities().integer()] = number
        updatedBoard.append(findLowestNumberPossiblities())
        weedOut()
    }
    
    func findLowestNumberPossiblities() -> SudokuCoordinate {
        var count = 0
        var numberOfInterest = 1
        var coordinateToReturn: SudokuCoordinate!
        
        while coordinateToReturn == nil {
            if boardConstraints.boredBoard[count].possibleNumbers.count == numberOfInterest {
                coordinateToReturn = count.sudokuCoordinate()
            }
            count += 1
        
            if count == 81 {
                count = 0
                numberOfInterest += 1
            }
        }
        
        return coordinateToReturn
    }
    
}
