//
//  AppDelegate.swift
//  FallingWords
//
//  Created by Alex Shubin on 25/01/2019.
//  Copyright © 2019 AlexShubin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    private let _fileName = "words.json"

    var window: UIWindow?
    var appStateStore: AppStateStore!

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Introducing all the dependencies to each other 🤗
        // Coordinator and scene factory
        let vcFactory = SceneFactory(gameViewStateConverter: GameViewStateConverter(),
                                     resultsViewStateConverter: ResultsViewStateConverter())
        let coordinator: SceneCoordinatorType = SceneCoordinator(window: window!, viewControllerFactory: vcFactory)
        // Service layer
        let translatedWordsLoader = TranslatedWordsLoader.makeDiskLoader(with: _fileName,
                                                                         parser: TranslatedWordsParser())
        let sideEffects = AppSideEffects(
            roundsDataProvider: RoundsDataProvider.makeShuffledProvider(with: translatedWordsLoader),
            sceneCoordinator: coordinator
        )
        // State store
        appStateStore = AppStateStore(sideEffects: sideEffects)
        vcFactory.setUp(appStateStore: appStateStore)
        coordinator.setRoot(scene: .game)
        // Run the game right away
        appStateStore.eventBus.accept(.startGame)
        return true
    }

}
