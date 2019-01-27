//
//  GameViewState.swift
//  FallingWords
//
//  Created by Alex Shubin on 26/01/2019.
//  Copyright © 2019 AlexShubin. All rights reserved.
//

import Foundation

struct GameViewState: Equatable {
    let questionWord: String
    let answerWord: String
    let animationDuration: TimeInterval

    static let empty = GameViewState(questionWord: "",
                                     answerWord: "",
                                     animationDuration: 0)
}
