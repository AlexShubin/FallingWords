//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import RxSwift
import RxCocoa
import RxFeedback

struct AppStateStore {

    let eventBus: PublishRelay<AppEvent>
    let stateBus: Signal<AppState>

    init(sideEffects: SideEffects,
         scheduler: SchedulerType = MainScheduler.instance,
         initialState: AppState = .initial) {
        let events = PublishRelay<AppEvent>()
        eventBus = events
        let eventBusFeedback: FeedbackLoop = { _ -> Observable<AppEvent> in
            events.asObservable()
        }
        var feedBacks = sideEffects.feedbackLoops
        feedBacks.append(eventBusFeedback)
        stateBus = Observable.system(initialState: initialState,
                                     reduce: AppState.reduce,
                                     scheduler: scheduler,
                                     scheduledFeedback: feedBacks)
            .asSignal(onErrorSignalWith: .never())
    }
}
