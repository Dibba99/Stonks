//
//  RememberTabBarController.swift
//  stonks
//
//  Created by Cosmo on 5/13/21.
//

import UIKit

class RememberTabBarController: UITabBarController, UITabBarControllerDelegate {
    let selectedTabIndexKey = "selectedTabIndex"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self

                // Load the last selected tab if the key exists in the UserDefaults
                if UserDefaults.standard.object(forKey: self.selectedTabIndexKey) != nil {
                    self.selectedIndex = UserDefaults.standard.integer(forKey: self.selectedTabIndexKey)
                }
    }
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
            // Save the selected index to the UserDefaults
            UserDefaults.standard.set(self.selectedIndex, forKey: self.selectedTabIndexKey)
            UserDefaults.standard.synchronize()
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
