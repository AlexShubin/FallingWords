//
//  Copyright © 2017 Alex Shubin. All rights reserved.
//

import UIKit

/// All app scenes.
enum Scene {
    case game
    case results
}

/// Scene factory makes view controller from `Scene`.
class SceneFactory {
    private let _gameViewStateConverter: GameViewStateConverter
    private let _resultsViewStateConverter: ResultsViewStateConverter
    private var _appStateStore: AppStateStore!

    init(gameViewStateConverter: GameViewStateConverter,
         resultsViewStateConverter: ResultsViewStateConverter) {
        _gameViewStateConverter = gameViewStateConverter
        _resultsViewStateConverter = resultsViewStateConverter
    }

    func setUp(appStateStore: AppStateStore) {
        _appStateStore = appStateStore
    }

    func make(_ scene: Scene) -> UIViewController {
        let vc: UIViewController & StateStoreBindable
        switch scene {
        case .game:
            vc = GameViewController(converter: _gameViewStateConverter)
        case .results:
            vc = ResultsViewController(converter: _resultsViewStateConverter)
        }
        vc.subscribe(to: _appStateStore)
        return vc
    }
}
