//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import RxSwift
import RxFeedback

typealias FeedbackLoop = (ObservableSchedulerContext<AppState>) -> Observable<AppEvent>

protocol FeedbackLoopsHolder {
    var feedbackLoops: [FeedbackLoop] { get }
}

protocol SideEffects: FeedbackLoopsHolder {
//    var show: () -> Observable<AppEvent> { get }
//    var close: () -> Observable<AppEvent> { get }
}

extension SideEffects {
    var feedbackLoops: [FeedbackLoop] {
        return [
            //react(query: { $0.queryShow }, effects: show),
            //react(query: { $0.queryClose }, effects: close)
        ]
    }
}

struct AppSideEffects: SideEffects {

}
