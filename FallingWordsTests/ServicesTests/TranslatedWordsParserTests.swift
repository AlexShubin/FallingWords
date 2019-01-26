//
//  TranslatedWordsParser.swift
//  FallingWordsTests
//
//  Created by Alex Shubin on 26/01/2019.
//  Copyright © 2019 AlexShubin. All rights reserved.
//

import XCTest
@testable import FallingWords

class TranslatedWordsParserTests: XCTestCase {

    func testTranslatedWordsParser_jsonProperlyParsed() {
        // Given
        let testJson = """
            [{
                "text_eng":"primary school",
                "text_spa":"escuela primaria"
            },
            {
                "text_eng":"teacher",
                "text_spa":"profesor / profesora"
            }]
        """.data(using: .utf8)!
        // When
        let decoded = try? TranslatedWordsParser().parse(data: testJson)
        // Then
        XCTAssertEqual(decoded, [
            TranslatedWord(eng: "primary school",
                           spa: "escuela primaria"),
            TranslatedWord(eng: "teacher",
                           spa: "profesor / profesora")
            ])
    }
}
