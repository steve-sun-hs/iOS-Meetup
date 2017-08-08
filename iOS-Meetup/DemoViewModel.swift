//  Copyright © 2017 Hootsuite. All rights reserved.

import Foundation
import RxSwift
import RxCocoa

class DemoViewModel {

    static let maximumFacebookCharacterCount = 10

    var message: Variable<String> = Variable("")
    var remainingCharacters: Variable<Int> = Variable(DemoViewModel.maximumFacebookCharacterCount)
    var shouldEnableSendButton: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    private let disposeBag = DisposeBag()

    init() {
        setupRx()
    }

    private func setupRx() {
        Observable.combineLatest(message.asObservable(), remainingCharacters.asObservable()) { message, remaining -> Bool in
            return message != "" && remaining >= 0
        }
        .bindTo(shouldEnableSendButton)
        .addDisposableTo(disposeBag)
    }

    func calculateRemainingCharacters(text: String) -> Int {
        return DemoViewModel.maximumFacebookCharacterCount - text.characters.count
    }

    func textDidUpdate(text: String) {
        message.value = text
        remainingCharacters.value = calculateRemainingCharacters(text: text)
    }

}
