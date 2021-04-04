//
//  ProfileViewController.swift
//  imp_homework_on_swift
//
//  Created by Татьяна  Травкина on 04.04.2021.
//

import UIKit
import KeychainSwift

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var colorProfile: UIColor = .blue
    var UserLogin: String = "Логин пользователя"
    var UserAvatar: String = "avatar"
    var UserRegistrationDate: Date = Date()
    let keychain = KeychainSwift()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let value = keychain.get(ApplicationConstans.keychainTokenKey) {
            let profile = AuthorizationMockSimulator().getProfile(token: value)
            if profile?.result == true,
               let userInfo = profile?.user {
                UserLogin = userInfo.login
                UserAvatar = userInfo.photo ?? "avatar"
                UserRegistrationDate = userInfo.registrationDate
                //colorProfile = UIColor(red: userInfo.prefferedColor?.red, green: userInfo.prefferedColor?.green, blue: userInfo.prefferedColor?.blue, alpha: 1)
            } else {
                if let mess = profile?.error {
                    self.alert(title: "Error", message: mess)
                }
            }
        } else {
            self.alert(title: "Error", message: "errore")
        }
        
        tableView.dataSource = self
        let topNib = UINib(nibName: TopTableViewCell.nibName(), bundle: nil)
        tableView.register(topNib, forCellReuseIdentifier: TopTableViewCell.nibName())
        
        let userInfoNib = UINib(nibName: UserInfoTableViewCell.nibName(), bundle: nil)
        tableView.register(userInfoNib, forCellReuseIdentifier: UserInfoTableViewCell.nibName())
        
        let colorProfileNib = UINib(nibName: ProfileColorTableViewCell.nibName(), bundle: nil)
        tableView.register(colorProfileNib, forCellReuseIdentifier: ProfileColorTableViewCell.nibName())
    }
    @IBAction func ExitButton(_ sender: Any) {
    }
    func alert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "ok", style: .default) {(action) in
            
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
}
extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        default:
            return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0,
           let cell = tableView.dequeueReusableCell(withIdentifier: TopTableViewCell.nibName(), for: indexPath) as? TopTableViewCell {
            cell.UserLoginLabel.text = UserLogin
            cell.TopImageView.image = UIImage(named: UserAvatar)
            cell.avatarImage.image = UIImage(named: UserAvatar)
            return cell
        }
        if indexPath.section == 1,
           let cell = tableView.dequeueReusableCell(withIdentifier: UserInfoTableViewCell.nibName(), for: indexPath) as? UserInfoTableViewCell {
            cell.InfoValueLable.text = UserRegistrationDate.description
            return cell
        }
        if let cell = tableView.dequeueReusableCell(withIdentifier: ProfileColorTableViewCell.nibName(), for: indexPath) as? ProfileColorTableViewCell {
            cell.ColorProfileView.backgroundColor = colorProfile
            return cell
        }
        return UITableViewCell()
    }
}
