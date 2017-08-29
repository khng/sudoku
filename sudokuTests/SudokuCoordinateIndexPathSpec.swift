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
        it("IndexPath 13, 0 should return coordinate 4, 1") {
            expect(IndexPath(item: 13, section: 0).sudokuCoordinate()).to(equal(SudokuCoordinate(x:4, y:1)))
        }
        it("Sudoku coordinate 8,6 should return IndexPath 62, 0") {
            expect(SudokuCoordinate(x:8, y:6).indexPath()).to(equal(IndexPath(item: 62, section: 0)))
        }
    }
}
