//
//  ReducerTests.swift
//  FallingWordsTests
//
//  Created by Alex Shubin on 26/01/2019.
//  Copyright © 2019 AlexShubin. All rights reserved.
//

import Foundation

import XCTest
@testable import FallingWords

class ReducerTests: XCTestCase {

    func testRoundsDataLoadedPutsDataIntoTheState() {
        // When
        let state = AppState.reduce(state: .initial, event: .roundsDataLoaded(TestData.roundsData))
        // Then
        XCTAssertEqual(state.roundsData, TestData.roundsData)
    }
}
