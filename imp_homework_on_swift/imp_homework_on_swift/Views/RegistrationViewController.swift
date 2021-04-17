//
//  RegistrationViewController.swift
//  imp_homework_on_swift
//
//  Created by Татьяна  Травкина on 02.04.2021.
//

import UIKit
import KeychainSwift

class RegistrationViewController: UIViewController {
    @IBOutlet weak var contentScrollView: UIScrollView!
    @IBOutlet weak var loginTextField: StyledTextField!
    @IBOutlet weak var passwordTextField: StyledTextField!
    @IBOutlet weak var confirmPasswordTextField: StyledTextField!
    
    let keychain = KeychainSwift()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        guard let keyboardSize = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                return
        }
        let bottomInset = keyboardSize.height
        contentScrollView.contentInset.bottom = bottomInset
        contentScrollView.verticalScrollIndicatorInsets.bottom = bottomInset - view.safeAreaInsets.bottom
        let Ypoint = bottomInset / 2.0 - view.safeAreaInsets.bottom
        contentScrollView.setContentOffset(CGPoint(x: 0.0, y: Ypoint), animated: true)
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        contentScrollView.contentInset = .zero
        contentScrollView.verticalScrollIndicatorInsets = .zero
        contentScrollView.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: true)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            view.endEditing(true)
    }
    
    private func registration () {
        view.endEditing(true)
        
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let login = loginTextField.text,
           let password = passwordTextField.text,
           let textconfirmPassword = confirmPasswordTextField.text, login.count > 0, password.count > 0, textconfirmPassword.count > 0
        else {
            self.alert(title: "Предупреждение", message: "Надо заполнить все поля")
            return
        }
        let registrationAnswer = AuthorizationMockSimulator().registerUser(login: login, password: password)
        if registrationAnswer.result == true,
           let registrationToken = registrationAnswer.token {
           keychain.set(registrationToken, forKey: ApplicationConstans.keychainTokenKey)
            if let value = keychain.get(ApplicationConstans.keychainTokenKey) {
                print("In Keychain: \(value)")
                if let destinationViewController = mainStoryBoard.instantiateViewController(identifier: "ProfileTabBarController") as? UITabBarController {
                    navigationController?.pushViewController(destinationViewController, animated: true)
                }
            } else {
                self.alert(title: "Ошибка", message: "Проблемы при регистрации")
            }
        }  else {
            if let mess = registrationAnswer.error {
                self.alert(title: "Ошибка", message: mess)
            }
        }
    }
    
    @IBAction func RegistrationButton(_ sender: Any) {
        registration()
    }
    
    func alert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "ok", style: .default) {(action) in
            
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
extension RegistrationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
            case loginTextField:
                passwordTextField.becomeFirstResponder()
            case passwordTextField:
                confirmPasswordTextField.becomeFirstResponder()
            case confirmPasswordTextField:
                registration()
            default:
                return false
        }
        return true
    }
}
