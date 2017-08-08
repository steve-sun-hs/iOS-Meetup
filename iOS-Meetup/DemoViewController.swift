//  Copyright © 2017 Hootsuite. All rights reserved.

import UIKit
import RxSwift
import RxCocoa

class DemoViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var characterCountLabel: UILabel! {
        didSet {
            characterCountLabel.text = String(DemoViewModel.maximumFacebookCharacterCount)
        }
    }
    @IBOutlet weak var sendButton: UIBarButtonItem!

    private let viewModel = DemoViewModel()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupRx()
    }

    private func setupRx() {
        textField.rx.text
            .asObservable()
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: { [weak self] text in
                if let text = text {
                    self?.viewModel.textDidUpdate(text: text)
                }

            }).addDisposableTo(disposeBag)

        viewModel.remainingCharacters
            .asObservable()
            .asDriver(onErrorJustReturn: 0)
            .drive(onNext: { [weak self] remainingCharacters in
                self?.characterCountLabel.text = String(remainingCharacters)
            })
            .addDisposableTo(disposeBag)

        viewModel.shouldEnableSendButton
            .asObservable()
            .asDriver(onErrorJustReturn: false)
            .drive(sendButton.rx.isEnabled)
            .addDisposableTo(disposeBag)
    }

    private func displayMessageSentAlert() {
        let alertController = UIAlertController(title: "Message Sent", message: "Your have successfully sent your messages :D", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "YAY!", style: .cancel, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }

    @IBAction func sendButtonTapped(_ sender: UIBarButtonItem) {
        displayMessageSentAlert()
    }
}

