//  Copyright © 2017 Hootsuite. All rights reserved.

import Foundation
import RxSwift
import RxCocoa

class DemoViewModel {

    static let maximumHootsuiteCharacterCount = 10

    let message: Variable<String> = Variable("")
    let remainingCharacters: Observable<Int>
    let shouldEnableSendButton: Observable<Bool>
    init() {
        remainingCharacters = message
            .asObservable()
            .map { DemoViewModel.maximumHootsuiteCharacterCount - $0.characters.count }

        shouldEnableSendButton = Observable.combineLatest(message.asObservable(), remainingCharacters) { message, remaining -> Bool in
            return !message.isEmpty && remaining >= 0
        }
    }
    
}
