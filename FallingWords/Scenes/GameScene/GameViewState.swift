//
//  GameViewState.swift
//  FallingWords
//
//  Created by Alex Shubin on 26/01/2019.
//  Copyright © 2019 AlexShubin. All rights reserved.
//

struct GameViewState: Equatable {
    let questionWord: String
    let answerWord: String

    static let empty = GameViewState(questionWord: "",
                                     answerWord: "")
}
