//
//  GameResults.swift
//  FallingWords
//
//  Created by Alex Shubin on 26/01/2019.
//  Copyright © 2019 AlexShubin. All rights reserved.
//

struct GameResults: Equatable {
    var rightAnswers: Int
    var wrongAnswers: Int
    var noAnswers: Int

    static let empty = GameResults(rightAnswers: 0, wrongAnswers: 0, noAnswers: 0)
}
