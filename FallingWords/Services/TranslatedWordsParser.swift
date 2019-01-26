//
//  TranslatedWordsParser.swift
//  FallingWords
//
//  Created by Alex Shubin on 26/01/2019.
//  Copyright © 2019 AlexShubin. All rights reserved.
//

import Foundation

struct TranslatedWordsParser {
    private let _decoder = JSONDecoder()

    func parse(data: Data) throws -> [TranslatedWord] {
        return try _decoder.decode([TranslatedWord].self, from: data)
    }
}
