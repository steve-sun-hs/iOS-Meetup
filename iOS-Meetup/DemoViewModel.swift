//  Copyright © 2017 Hootsuite. All rights reserved.

import Foundation
import RxSwift
import RxCocoa

class DemoViewModel {

    static let maximumFacebookCharacterCount = 10

    let remainingCharacters: BehaviorSubject<Int> = BehaviorSubject(value: DemoViewModel.maximumFacebookCharacterCount)
    let shouldEnableSendButton: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    let message: Variable<String> = Variable("")

    private let disposeBag = DisposeBag()

    init() {
        setupRx()
    }

    private func setupRx() {
        Observable.combineLatest(message.asObservable(), remainingCharacters.asObservable()) { message, remaining -> Bool in
            return !message.isEmpty && remaining >= 0
            }
            .bindTo(shouldEnableSendButton)
            .addDisposableTo(disposeBag)

        message
            .asObservable()
            .map { DemoViewModel.maximumFacebookCharacterCount - $0.characters.count }
            .bindTo(remainingCharacters)
            .addDisposableTo(disposeBag)
    }
    
}
