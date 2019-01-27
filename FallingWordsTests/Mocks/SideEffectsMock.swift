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
    var turnOnTimer: () -> Observable<AppEvent> {
        return {
            self.effects.onNext(#function)
            return .empty()
        }
    }

    var fireTimer: (TimeInterval) -> Observable<AppEvent> {
        return { _ in
            self.effects.onNext(#function)
            return .empty()
        }
    }

    var showResults: () -> Observable<AppEvent> {
        return {
            self.effects.onNext(#function)
            return .empty()
        }
    }

    var provideShuffledRoundsData: (Int) -> Observable<AppEvent> {
        return { _ in
            self.effects.onNext(#function)
            return .empty()
        }
    }

    var closeResults: () -> Observable<AppEvent> {
        return {
            self.effects.onNext(#function)
            return .empty()
        }
    }

    let effects = PublishSubject<String>()
}
