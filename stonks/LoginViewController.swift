//
//  LoginViewController.swift
//  stonks
//
//  Created by Cosmo on 4/18/21.
//

import UIKit
import Parse
import NotificationBannerSwift
import MaterialComponents.MaterialTextControls_OutlinedTextAreas
import MaterialComponents.MaterialTextControls_OutlinedTextFields
import Lottie

extension UIViewController{
    func HideKeyboard() {
        let Tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self , action: #selector(DismissKeyboard))
        view.addGestureRecognizer(Tap)
    }
    
    @objc func DismissKeyboard(){
        view.endEditing(true)
    }
}


class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    let usertextField = MDCOutlinedTextField(frame: CGRect(x: 80, y: 510, width: 275, height: 30))
    let passwordtextField = MDCOutlinedTextField(frame: CGRect(x: 80, y: 600, width: 275, height: 30))

    
    @IBAction func onLogin(_ sender: Any) {
        
        let username = usertextField.text!
        let password = passwordtextField.text!
        
        PFUser.logInWithUsername(inBackground: username, password: password) { (user, error) in
            if user != nil {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }else{
                let error = error?.localizedDescription as! String
                let banner = GrowingNotificationBanner(title: "Please try again!", subtitle: "\(error)", leftView: nil, rightView: nil, style: .danger, colors: nil)
                
                banner.show(queuePosition: .front, bannerPosition: .bottom, queue: .default, on: self)
            }
        }
        
    }
    @IBAction func onSignUp(_ sender: Any) {
        let user = PFUser()
        user.username = usertextField.text!
        user.password = passwordtextField.text!
        
        user.signUpInBackground { (success, error) in
            if(success){
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }else{
                let error = error?.localizedDescription as! String
                let banner = GrowingNotificationBanner(title: "OOPS!", subtitle: "\(error)", leftView: nil, rightView: nil, style: .danger, colors: nil)
                
                banner.show(queuePosition: .front, bannerPosition: .bottom, queue: .default, on: self)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        lottieAnimation()
        
        self.HideKeyboard()
        
        usertextField.label.text = "Username"
        usertextField.placeholder = "Username"
        //usertextField.leadingAssistiveLabel.text = "Please don't use spacing in username!"
        usertextField.sizeToFit()
        self.view.addSubview(usertextField)
        
        passwordtextField.adjustsFontSizeToFitWidth = true
        passwordtextField.label.text = "Password"
        passwordtextField.placeholder = "Password"
        passwordtextField.leadingAssistiveLabel.text = "Please choose a secure password!"
        passwordtextField.sizeToFit()
        self.view.addSubview(passwordtextField)

        // Do any additional setup after loading the view.
    }
    

    func lottieAnimation(){
        let animationview = AnimationView(name: "34115-rocket-lunch")
        animationview.frame = CGRect(x: 110, y: 100, width: 200, height: 350)
        //animationview.center = self.view.center
        animationview.contentMode = .scaleAspectFill
        view.addSubview(animationview)
        animationview.play()
        animationview.loopMode = .loop
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
