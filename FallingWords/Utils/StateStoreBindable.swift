//
// Copyright © 2018 LLC "Globus Media". All rights reserved.
//

protocol StateStoreBindable {
    func subscribe(to stateStore: AppStateStore)
}
