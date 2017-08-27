//
//  SudokuCoordinateIndexPathSpec.swift
//  sudokuTests
//
//  Created by Pivotal - Dev 53 on 2017-08-27.
//  Copyright © 2017 Pivotal - Dev 53. All rights reserved.
//

import Quick
import Nimble

@testable import sudoku

class SudokuCoordinateIndexPath: QuickSpec {
    
    override func spec() {
        it("IndexPath 13, 0 should return coordinate 1, 4") {
            expect(IndexPath(item: 13, section: 0).sudokuCoordinate()).to(equal(SudokuCoordinate(x:1, y:4)))
        }
        it("Sudoku coordinate 6,8 should return IndexPath 62, 0") {
            expect(SudokuCoordinate(x:6, y:8).indexPath()).to(equal(IndexPath(item: 62, section: 0)))
        }
    }
}
