//
//  LoginViewController.swift
//  stonks
//
//  Created by  on 4/18/21.
//

import UIKit
import Parse
import NotificationBannerSwift
import Lottie
import AVFoundation

extension UIViewController{
    func HideKeyboard() {
        let Tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self , action: #selector(DismissKeyboard))
        view.addGestureRecognizer(Tap)
    }
    
    @objc func DismissKeyboard(){
        view.endEditing(true)
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

public extension UIView {

    func shake(count : Float = 7,for duration : TimeInterval = 0.3,withTranslation translation : Float = 5) {

        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.repeatCount = count
        animation.duration = duration/TimeInterval(animation.repeatCount)
        animation.autoreverses = true
        animation.values = [translation, -translation]
        layer.add(animation, forKey: "shake")
    }
}

class LoginViewController: UIViewController {
    
    var player: AVAudioPlayer?
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func onLogin(_ sender: Any) {
        
        let username = usernameField.text!
        let password = passwordField.text!
        
        PFUser.logInWithUsername(inBackground: username, password: password) { (user, error) in
            if user != nil {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
                if let player = self.player, player.isPlaying {
                    player.stop()
                }else{
                    let urlString = Bundle.main.path(forResource: "success", ofType: "mp3")
                    do {
                        try AVAudioSession.sharedInstance().setMode(.default)
                        try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
                        
                        guard let urlString = urlString else {
                            return
                        }
                        
                        self.player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: urlString))
                        guard let player = self.player else {
                            return
                        }
                        player.play()
                    }
                    catch {
                        print("oops something went wrong")
                    }
                }
            }else{
                self.usernameField.shake()
                self.passwordField.shake()
                self.usernameField.layer.borderWidth = 1.0
                self.usernameField.layer.borderColor = UIColor.red.cgColor
                self.passwordField.layer.borderWidth = 1.0
                self.passwordField.layer.borderColor = UIColor.red.cgColor
                
                let error = error?.localizedDescription as! String
                let banner = GrowingNotificationBanner(title: "Please try again!", subtitle: "\(error)", leftView: nil, rightView: nil, style: .danger, colors: nil)
                
                banner.show(queuePosition: .front, bannerPosition: .bottom, queue: .default, on: self)
                
                if let player = self.player, player.isPlaying {
                    player.stop()
                }else{
                    let urlString = Bundle.main.path(forResource: "Error", ofType: "mp3")
                    do {
                        try AVAudioSession.sharedInstance().setMode(.default)
                        try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
                        
                        guard let urlString = urlString else {
                            return
                        }
                        
                        self.player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: urlString))
                        guard let player = self.player else {
                            return
                        }
                        player.play()
                    }
                    catch {
                        print("oops something went wrong")
                    }
                }
            }
        }
    }
    @IBAction func onSignUp(_ sender: Any) {
        let user = PFUser()
        user.username = usernameField.text!
        user.password = passwordField.text!
        
        user.signUpInBackground { (success, error) in
            if(success){
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
                if let player = self.player, player.isPlaying {
                    player.stop()
                }else{
                    let urlString = Bundle.main.path(forResource: "success", ofType: "mp3")
                    do {
                        try AVAudioSession.sharedInstance().setMode(.default)
                        try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
                        
                        guard let urlString = urlString else {
                            return
                        }
                        
                        self.player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: urlString))
                        guard let player = self.player else {
                            return
                        }
                        player.play()
                    }
                    catch {
                        print("oops something went wrong")
                    }
                }
            }else{
                self.usernameField.shake()
                self.passwordField.shake()
                self.usernameField.layer.borderWidth = 1.0
                self.usernameField.layer.borderColor = UIColor.red.cgColor
                self.passwordField.layer.borderWidth = 1.0
                self.passwordField.layer.borderColor = UIColor.red.cgColor
                let error = error?.localizedDescription as! String
                let banner = GrowingNotificationBanner(title: "OOPS!", subtitle: "\(error)", leftView: nil, rightView: nil, style: .danger, colors: nil)
                
                banner.show(queuePosition: .front, bannerPosition: .bottom, queue: .default, on: self)
                if let player = self.player, player.isPlaying {
                    player.stop()
                }else{
                    let urlString = Bundle.main.path(forResource: "Error", ofType: "mp3")
                    do {
                        try AVAudioSession.sharedInstance().setMode(.default)
                        try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
                        
                        guard let urlString = urlString else {
                            return
                        }
                        
                        self.player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: urlString))
                        guard let player = self.player else {
                            return
                        }
                        player.play()
                    }
                    catch {
                        print("oops something went wrong")
                    }
                }
                
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        lottieAnimation()
        
        usernameField.setLeftPaddingPoints(20)
        usernameField.layer.cornerRadius = 10.0
        usernameField.layer.borderWidth = 0.8
        usernameField.layer.borderColor = UIColor.black.cgColor
        usernameField.layer.masksToBounds = true
        usernameField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        
        passwordField.setLeftPaddingPoints(20)
        passwordField.layer.cornerRadius = 10.0
        passwordField.layer.borderWidth = 0.8
        passwordField.layer.borderColor = UIColor.black.cgColor
        passwordField.layer.masksToBounds = true
        passwordField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        
        self.HideKeyboard()
        // Do any additional setup after loading the view.
    }
    

    func lottieAnimation(){
        let animationview = AnimationView(name: "34115-rocket-lunch")
        //animationview.frame = CGRect(x: 110, y: 100, width: 200, height: 350)
        //animationview.center = self.view.center
        animationview.contentMode = .scaleAspectFill
        view.addSubview(animationview)
        animationview.play()
        animationview.loopMode = .loop
        animationview.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    animationview.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 110),
                    animationview.rightAnchor.constraint(equalTo: self.view.rightAnchor),
                    animationview.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 120),
                    animationview.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                    animationview.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1/2),
                    animationview.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 2/6)
                ])
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
