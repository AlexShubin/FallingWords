# FallingWords

There're 2 scenes in this game:
 - Game (where the game happens)
 - Results (provides feedback to a user about the results)
 
 Because both screens share the same state (GameScene should count results, and ResultsScene should show that results) I decided that unidirectional architecture with shared app state should fit nicely, I've picked RxFeedback and described the game state which consists of few vars and could be rendered at any time ([AppState](https://github.com/AlexShubin/FallingWords/blob/3123a5017fb103b43c78a285182d0782fe95c1ac/FallingWords/AppState/AppState.swift#L8)).
 
#### * how much time was invested
About 7 hours, maybe a little bit less, also I could have saved more time if I had done layout in storyboards.
But I don't like storyboards (harder to maintain, codereview, merge, etc.)
#### * how was the time distributed (concept, model layer, view(s), game mechanics)
I've started from the bottom (services -> views):
- about 1,5 hour was spent on services + models
- about 0,5 hour was spent on some mvp game logic (like start game, show next word etc.)
- about 2 hours were spent on UI layer: layout, localized strings, some boilerplate like coordinator, etc.
- about 1 hour on results tracking + view controller
- about 1 hour  - timer + label animation
- 0,5 hour - get back from results screen
- 0,5 pods, project setup etc...
#### * decisions made to solve certain aspects of the game
The concept seemed quite easy to me - basically we need two things:

1st - dependency to provide data for a game session with a reasonable probability of right translations and some shuffling ([RoundsProvider](https://github.com/AlexShubin/FallingWords/blob/3123a5017fb103b43c78a285182d0782fe95c1ac/FallingWords/Services/RoundsDataProvider.swift) Rounds - I mean 1 word = 1 one round)

2d - something to manage the game logic and easy to test - [Reducer](https://github.com/AlexShubin/FallingWords/blob/3123a5017fb103b43c78a285182d0782fe95c1ac/FallingWords/AppState/AppState.swift#L65) is a pure function(easy to test), it mutates the state, which could be rendered any time by anyone who is subscribed (e.g. UIViewController). The system works like that:

- User emits events into reducer by [tapping buttons](https://github.com/AlexShubin/FallingWords/blob/3123a5017fb103b43c78a285182d0782fe95c1ac/FallingWords/Scenes/GameScene/GameViewController.swift#L147)
- Also side effects emit events into reducer (e.g. [timer](https://github.com/AlexShubin/FallingWords/blob/3123a5017fb103b43c78a285182d0782fe95c1ac/FallingWords/AppState/SideEffects.swift#L59))
- [StateConverter](https://github.com/AlexShubin/FallingWords/blob/3123a5017fb103b43c78a285182d0782fe95c1ac/FallingWords/Scenes/ResultsScene/ResultsViewStateConverter.swift) translates app state into primitive types(`String`) which can be rendered by UIKit.

So every step up to UIKit is fully tested.

Another interesting things:

- [RoundsProvider](https://github.com/AlexShubin/FallingWords/blob/3123a5017fb103b43c78a285182d0782fe95c1ac/FallingWords/Services/RoundsDataProvider.swift) always provides 50% of the right answers and the the other part is random - right/wrong.
- [Animation rendering](https://github.com/AlexShubin/FallingWords/blob/3123a5017fb103b43c78a285182d0782fe95c1ac/FallingWords/Scenes/GameScene/GameViewController.swift#L104) clears previous animations and fires new one on every render invocation with duration provided by the state.
#### * decisions made because of restricted time
- [WordsLoader](https://github.com/AlexShubin/FallingWords/blob/3123a5017fb103b43c78a285182d0782fe95c1ac/FallingWords/Services/TranslatedWordsLoader.swift) should be asynchronous, so `DiskLoader` implemetation may be easily replaced with for example 'ApiLoader' implemetation. But it would take some additional work on UI (activity indicators, failures, etc...).
- [There](https://github.com/AlexShubin/FallingWords/blob/3123a5017fb103b43c78a285182d0782fe95c1ac/FallingWords/AppState/SideEffects.swift#L61) shouldn't be a singleton. The timer should be a separate dependency, which should be tested with TestScheduler.
- Some edge cases could be handled somehow (like words provider provided not enough words to compose a session, etc...)
#### * what would be the first thing to improve or add if there had been more time
- UI and design :), add menu
- fix decisions made because of restricted time
- load words from API
- add some multilingual support (there's a lot: swap languages, improve backend to send different languages on demand, etc...)
- maybe results saving


#### Don't forget to `pod install` 😉
