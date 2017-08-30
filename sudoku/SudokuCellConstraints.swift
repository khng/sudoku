//
//  SudokuCellConstraints.swift
//  sudoku
//
//  Created by Pivotal - Dev 53 on 2017-08-28.
//  Copyright © 2017 Pivotal - Dev 53. All rights reserved.
//

import UIKit

class SudokuCellConstraints {
    
    var possibleNumbers: [Int] = [1,2,3,4,5,6,7,8,9]

    func addConstraints(_ number: Int) {
        if let index = possibleNumbers.index(of: number) {
            possibleNumbers.remove(at: index)
        }
    }
    
    func removeConstraints(_ number: Int) {
        possibleNumbers.append(number)
        possibleNumbers.sort()
    }
    
 }
