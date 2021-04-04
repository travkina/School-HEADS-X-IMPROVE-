//
//  ErrorViewController.swift
//  imp_homework_on_swift
//
//  Created by Татьяна  Травкина on 04.04.2021.
//

import UIKit

class ErrorViewController: UIViewController {

    @IBOutlet weak var messageLabel: UILabel!
    var textMessage = "Не, не работает"
    override func viewDidLoad() {
        super.viewDidLoad()
        messageLabel.text = textMessage
        // Do any additional setup after loading the view.
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
