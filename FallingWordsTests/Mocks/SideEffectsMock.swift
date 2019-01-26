//
//  SideEffectsMock.swift
//  FallingWordsTests
//
//  Created by Alex Shubin on 26/01/2019.
//  Copyright © 2019 AlexShubin. All rights reserved.
//

@testable import FallingWords
import RxSwift

struct SideEffectsMock: SideEffects {
    var provideShuffledRoundsData: (Int) -> Observable<AppEvent> {
        return { _ in
            self.effects.onNext(#function)
            return .empty()
        }
    }

    let effects = PublishSubject<String>()
}
