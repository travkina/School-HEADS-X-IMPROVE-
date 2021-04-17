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
                if let redColor = userInfo.prefferedColor?.red,
                   let blueColor = userInfo.prefferedColor?.blue,
                   let greenColor = userInfo.prefferedColor?.green
                {
                    print("profileColor OK")
                    colorProfile = UIColor(red: CGFloat(redColor),
                        green: CGFloat(greenColor),
                        blue: CGFloat(blueColor), alpha: 1)
                }
                UserLogin = userInfo.login
                UserAvatar = userInfo.photo ?? "avatar"
                UserRegistrationDate = userInfo.registrationDate
                /*
                 guard let profileInfo = Profile(login: userInfo.login, profilePhotoName: (userInfo.photo ?? "avatar"), dateRegistration: userInfo.registrationDate, profileColor: colorProfile)
                
                else {
                    print("login: \(userInfo.login)")
                    print("profilePhotoName \(userInfo.photo ?? "avatar")")
                    print("date reg \(userInfo.registrationDate)")
                    
                    fatalError("Unable to instantiate profileInfo")
                }
                
                profileInformation.append(profileInfo)
            */
                
            } else {
                if let mess = profile?.error {
                    self.alert(title: "Ошибка", message: mess)
                }
            }
        } else {
            self.alert(title: "Ошибка", message: "Ошибка авторизации")
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
        //keychain.clear()
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let loginViewController = mainStoryBoard.instantiateViewController(identifier: "LoginVC") as? LoginViewController {
            navigationController?.pushViewController(loginViewController, animated: true)
        }
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
        //let profile = profileInformation[1]
        
        if indexPath.section == 0,
           let cell = tableView.dequeueReusableCell(withIdentifier: TopTableViewCell.nibName(), for: indexPath) as? TopTableViewCell {
            
            cell.UserLoginLabel.text = UserLogin
            cell.TopImageView.image = UIImage(named: UserAvatar)
            cell.avatarImage.image = UIImage(named: UserAvatar)
            /*
            cell.UserLoginLabel.text = profile.login
            cell.TopImageView.image = UIImage(named: profile.profilePhotoName ?? "avatar")
            cell.avatarImage.image = UIImage(named: profile.profilePhotoName ?? "avatar")
             */
            return cell
        }
        if indexPath.section == 1,
           let cell = tableView.dequeueReusableCell(withIdentifier: UserInfoTableViewCell.nibName(), for: indexPath) as? UserInfoTableViewCell {
            cell.InfoValueLable.text = UserRegistrationDate.description
            //profile.dateRegistration.description
            return cell
        }
        if let cell = tableView.dequeueReusableCell(withIdentifier: ProfileColorTableViewCell.nibName(), for: indexPath) as? ProfileColorTableViewCell {
            cell.ColorProfileView.backgroundColor = colorProfile//profile.profileColor
            return cell
        }
        return UITableViewCell()
    }
}
