//
//  LoginController.swift
//  HW8
//
//  Created by ZYY on 11/18/23.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var userNameText: UITextField!
    
    @IBOutlet weak var pwdText: UITextField!
    
    @IBAction func login(_ sender: Any) {
        print("---------------Login Successfully-----------------")
        if pwdText.text == "123" {
            popAlert("Error", "Nonono")
            return
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pwdText.isSecureTextEntry = true
        // Do any additional setup after loading the view.
    }
    
    func popAlert(_ title: String, _ msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
