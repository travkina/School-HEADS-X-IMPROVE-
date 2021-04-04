//
//  LoginViewController.swift
//  imp_homework_on_swift
//
//  Created by Татьяна  Травкина on 02.04.2021.
//

import UIKit
import KeychainSwift

class LoginViewController: UIViewController {

    @IBOutlet weak var headLabel: UILabel!
    @IBOutlet weak var contentScrollView: UIScrollView!
    

    @IBOutlet weak var loginTextField: StyledTextField!
    @IBOutlet weak var passwordTextField: StyledTextField!
    
    let keychain = KeychainSwift()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewController = UIViewController()
        present(viewController, animated: true, completion: nil)
        
        loginTextField.delegate = self
        passwordTextField.delegate = self
        
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
        contentScrollView.setContentOffset(CGPoint(x: 0, y: Ypoint), animated: true)
    }
    
    @IBAction func signInButton(_ sender: Any) {
        view.endEditing(true)
        
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        guard let login = loginTextField.text,
        let password = passwordTextField.text
        else {
            self.alert(title: "Warning", message: "Надо заполнить все поля")
            return
        }
        
        let loginAnswer = AuthorizationMockSimulator().logIn(login: login, password: password)
        if loginAnswer.result == true,
           let authorizationToken = loginAnswer.token {
                keychain.set(authorizationToken, forKey: ApplicationConstans.keychainTokenKey)
                
                if let value = keychain.get(ApplicationConstans.keychainTokenKey) {
                    print("In Keychain: \(value)")
                    if let destinationViewController = mainStoryBoard.instantiateViewController(identifier: "ProfileTabBarController") as? UITabBarController {
                        navigationController?.pushViewController(destinationViewController, animated: true)
                    }
                } else {
                    self.alert(title: "Error", message: "no value in keychain")
                }
        }  else {
            if let mess = loginAnswer.error {
                self.alert(title: "Error", message: mess)
            }
        }
    }
    
    @IBAction func registrationButton(_ sender: Any) {
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let registrViewController = mainStoryBoard.instantiateViewController(identifier: "RegistrationVC") as? RegistrationViewController {
            navigationController?.pushViewController(registrViewController, animated: true)
        }
    }
    
    @objc func keyboardWillHide(_ sender: Notification){
        contentScrollView.contentInset = .zero
        contentScrollView.verticalScrollIndicatorInsets = .zero
        contentScrollView.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: true)
    }
    
    func alert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "ok", style: .default) {(action) in
            
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            view.endEditing(true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == loginTextField {
            passwordTextField.becomeFirstResponder()
            return true
        }
        textField.resignFirstResponder()
        return true
    }
}
