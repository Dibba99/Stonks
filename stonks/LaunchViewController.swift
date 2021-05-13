//
//  LaunchViewController.swift
//  stonks
//
//  Created by  on 4/25/21.
//

import UIKit

class LaunchViewController: UIViewController {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 54, y: 299, width: 306, height: 299))
        imageView.image = UIImage(named: "pngegg")
        return imageView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            self.animate()
        }
        //imageView.center = view.center
    }
    private func animate(){
        UIView.animate(withDuration: 1) {
            let size = self.view.frame.size.width * 3
            let diffX = size - self.view.frame.size.width
            let diffY = self.view.frame.size.height - size
            self.imageView.frame = CGRect(x: -(diffX/2),
                                          y: diffY/2,
                                          width: size,
                                          height: size)
        }
        UIView.animate(withDuration: 1.5, animations: {
            self.imageView.alpha = 0
        }) { done in
            if done {
                self.performSegue(withIdentifier: "launchSegue", sender: self)
            }
        }
    }
}
