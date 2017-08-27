//
//  SudokuGameSpec.swift
//  sudokuTests
//
//  Created by Pivotal - Dev 53 on 2017-08-27.
//  Copyright © 2017 Pivotal - Dev 53. All rights reserved.
//

import Quick
import Nimble

@testable import sudoku

class SudokuGameSpec: QuickSpec {
    
    override func spec() {
        var subject: SudokuGame!
        
        beforeEach {
            subject = SudokuGame()
        }
        
        describe("SudokuGame") {
            context("Selection states") {
                it("At the start of the game, there should be no selected cell") {
                    expect(subject.selectedCoordinate).to(beNil())
                }
                context("User selected cell") {
                    beforeEach {
                        // class owns struct not instances...
                        subject.selectedCoordinate = SudokuCoordinate(x: 2, y: 2)
                    }
                    // be specific with what you're testing
                    it("If the user selected cell 2,2, coordinate 2,2 should be selected") {
                        expect(subject.selectedState(for: SudokuCoordinate(x:2, y:2))).to(beTruthy())
                    }
                    it("If the user selected cell 2,2, coordinate 0,0 should not be selected") {
                        expect(subject.selectedState(for: SudokuCoordinate(x:0, y:0))).to(beFalsy())
                    }
                }
            }
            context("Highlight states") {
                it("At the start of the game, there should be no highlighted cells") {
                    expect(subject.highlightedCoordinates.count).to(equal(0))
                }
                context("User selected cell is highlighted") {
                    beforeEach {
                        subject.selectedCoordinate = SudokuCoordinate(x:3, y: 5)
                    }
                    it("row, column, and section should be highlighted for coordinate 3,5") {
                        let expectedRowSet: Set<SudokuCoordinate> = [SudokuCoordinate(x:3, y:0), SudokuCoordinate(x:3, y:1), SudokuCoordinate(x:3, y:2), SudokuCoordinate(x:3, y:3), SudokuCoordinate(x:3, y:4), SudokuCoordinate(x:3, y:6), SudokuCoordinate(x:3, y:7), SudokuCoordinate(x:3, y:8)]
                        let expectedColumnSet: Set<SudokuCoordinate> = [SudokuCoordinate(x:0, y:5), SudokuCoordinate(x:1, y:5), SudokuCoordinate(x:2, y:5), SudokuCoordinate(x:4, y:5), SudokuCoordinate(x:5, y:5), SudokuCoordinate(x:6, y:5), SudokuCoordinate(x:7, y:5), SudokuCoordinate(x:8, y:5)]
                        let expectedSectionSet: Set<SudokuCoordinate> = [SudokuCoordinate(x:4, y:3), SudokuCoordinate(x:4, y:4), SudokuCoordinate(x:5, y:3), SudokuCoordinate(x:5, y:4)]
                        
                        var expectedSet: Set<SudokuCoordinate> = []
                        expectedSet.formUnion(expectedRowSet)
                        expectedSet.formUnion(expectedColumnSet)
                        expectedSet.formUnion(expectedSectionSet)
                        expect(subject.highlightedCoordinates).to(equal(expectedSet))
                    }
                    it("row, column, and section should be higlighted for coordinate 8,8") {
                        subject.selectedCoordinate = SudokuCoordinate(x:8, y:8)
                        let expectedRowSet: Set<SudokuCoordinate> = [SudokuCoordinate(x:8, y:0), SudokuCoordinate(x:8, y:1), SudokuCoordinate(x:8, y:2), SudokuCoordinate(x:8, y:3), SudokuCoordinate(x:8, y:4), SudokuCoordinate(x:8, y:5), SudokuCoordinate(x:8, y:6), SudokuCoordinate(x:8, y:7)]
                        let expectedColumnSet: Set<SudokuCoordinate> = [SudokuCoordinate(x:0, y:8), SudokuCoordinate(x:1, y:8), SudokuCoordinate(x:2, y:8), SudokuCoordinate(x:3, y:8), SudokuCoordinate(x:4, y:8), SudokuCoordinate(x:5, y:8), SudokuCoordinate(x:6, y:8), SudokuCoordinate(x:7, y:8)]
                        let expectedSectionSet: Set<SudokuCoordinate> = [SudokuCoordinate(x:6, y:6), SudokuCoordinate(x:6, y:7), SudokuCoordinate(x:7, y:6), SudokuCoordinate(x:7, y:7)]
                        
                        var expectedSet: Set<SudokuCoordinate> = []
                        expectedSet.formUnion(expectedRowSet)
                        expectedSet.formUnion(expectedColumnSet)
                        expectedSet.formUnion(expectedSectionSet)
                        expect(subject.highlightedCoordinates).to(equal(expectedSet))
                    }
                    it("coordinate 3,4 should be highlighted") {
                        expect(subject.highlightedState(for: SudokuCoordinate(x:3, y:4))).to(beTruthy())
                    }
                    it("coordinated 0,0 should not be highlighted") {
                        expect(subject.highlightedState(for: SudokuCoordinate(x:0, y:0))).to(beFalsy())
                    }
                }
            }
        }
    }
}
