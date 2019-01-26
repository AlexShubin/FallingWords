//
//  Copyright © 2017 Alex Shubin. All rights reserved.
//

import UIKit

enum Scene {
    case game
}

class SceneFactory {
    private let _gameViewStateConverter: GameViewStateConverter
    private var _appStateStore: AppStateStore!

    init(gameViewStateConverter: GameViewStateConverter) {
        _gameViewStateConverter = gameViewStateConverter
    }

    func setUp(appStateStore: AppStateStore) {
        _appStateStore = appStateStore
    }

    func make(_ scene: Scene) -> UIViewController {
        switch scene {
        case .game:
            let vc = GameViewController(converter: _gameViewStateConverter)
            vc.subscribe(to: _appStateStore)
            return vc
        }
    }
}
