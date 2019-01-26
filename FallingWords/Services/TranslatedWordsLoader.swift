//
//  TranslatedWordsLoader.swift
//  FallingWords
//
//  Created by Alex Shubin on 26/01/2019.
//  Copyright © 2019 AlexShubin. All rights reserved.
//

import Foundation

struct TranslatedWordsLoader {
    let load: () -> [TranslatedWord]

    static func makeDiskLoader(with fileName: String, parser: TranslatedWordsParser) -> TranslatedWordsLoader {
        return TranslatedWordsLoader(load: {
            guard let url = Bundle.main.url(forResource: fileName, withExtension: nil),
                let data = try? Data(contentsOf: url),
                let translatedWords = try? parser.parse(data: data) else {
                    fatalError("Couldn't read translated words data from file!")
            }
            return translatedWords
        })
    }
}
