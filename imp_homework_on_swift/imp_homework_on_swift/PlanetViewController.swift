//
//  PlanetViewController.swift
//  imp_homework_on_swift
//
//  Created by Студент 1 on 05.04.2021.
//

import UIKit
import PKHUD

class PlanetViewController: UIViewController {
    
    let networkService: PlanetListNetworkService = NetworkService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        HUD.registerForKeyboardNotifications()
        HUD.allowsInteraction = false
        HUD.dimsBackground = true
        loadPlanets()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // приоритетее глобал
        DispatchQueue.main.async{
            // отправить в главный поток сто-то
        }
        DispatchQueue.global(/*qos: .*/).async {
            
        }
    }
    
    func loadPlanets() {
        HUD.show(.progress)
        networkService.getPlanetLits(page: 1) { [weak self] (response, error) in
            HUD.hide()
            guard self == self else { return }
            self.textField.text = response?.info.next
            print("------RESPONSE-------")
            print(response as Any)
            print("------ERROR-------")
            print(error as Any)
            print("------end-------")
        }
    }
    
    deinit {
        HUD.deregisterFromKeyboardNotifications()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
