//
//  FinanceViewController.swift
//  stonks
//
//  Created by Cosmo on 4/18/21.
//

import UIKit
import Parse
import AlamofireImage
import NotificationBannerSwift

class FinanceViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!

    
    var articles = [[String:Any]]()
    let refreshController = UIRefreshControl()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = PFUser.current()!.username as! String
        let banner = GrowingNotificationBanner(title: "Welcome back!", subtitle: "Hey \(user)! - explore new business headlines to make your future financial decision!", leftView: nil, rightView: nil, style: .success, colors: nil)
        
        banner.show()
        
        refreshController.addTarget(self, action: #selector(FinanceViewController.handleRefresh), for: .valueChanged)
        tableView.refreshControl = refreshController
        
        tableView.dataSource = self
        tableView.delegate = self
    
        
        let url = URL(string: "https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=bb7b045c2afb4fa1ac4148821ff98bc5")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
             // This will run when the network request returns
             if let error = error {
                let alert = UIAlertController(title: "OOPS - trouble loading data", message: "\(error.localizedDescription)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                self.present(alert, animated: true)
                    print(error.localizedDescription)
             } else if let data = data {
                    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]

                self.articles = dataDictionary["articles"] as! [[String:Any]]
                
                self.tableView.reloadData()
                
                //print(dataDictionary)
             }
        }
        task.resume()
        tabbarConfig()
        // Do any additional setup after loading the view.
    }
    @objc func handleRefresh() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { (timer) in
            self.tableView.reloadData()
            self.refreshController.endRefreshing()
        }
    }
    
    
    func tabbarConfig(){
        guard let tabbar = self.tabBarController?.tabBar else { return }
        tabbar.layer.cornerRadius = 50
        tabbar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tabbar.layer.masksToBounds = true
        tabbar.layer.borderWidth = 0.2
        tabbar.layer.borderColor = UIColor.black.cgColor
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FinanceCell") as! FinanceCell
        
        let article = articles[indexPath.row]
        
        let title = article["title"] as! String
        cell.titleLabel.text = title
        
        let description = article["content"] as? String
        if description == nil {
            cell.contentLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 16.0)
            cell.contentLabel.textColor = UIColor.red
            cell.contentLabel.text = "OOPS! Content not found, please click on this cell to redirect to article link"
        }else{
            cell.contentLabel.font = UIFont(name:"System - System", size: 14.0)
            cell.contentLabel.textColor = UIColor.black
            cell.contentLabel.text = description
        }
        
        let publisher = article["author"] as? String
        if publisher == nil {
            cell.publishedLabel.text = "Publisher not found"
        }else{
            cell.publishedLabel.text = publisher
        }
        
        let date = article["publishedAt"] as? String
        cell.dateLabel.text = date
        
        let posterPath = article["urlToImage"] as? String
        let posterURL = URL(string: posterPath ?? "nil")
        
        cell.posterView.af_setImage(withURL: posterURL!)
        
        cell.backgroundView?.layer.cornerRadius = 5
        cell.backgroundView?.clipsToBounds = true
        
        return cell
    }
    @IBAction func onLogoutButton(_ sender: Any) {
        PFUser.logOut()
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = main.instantiateViewController(identifier: "LoginViewController")
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let delegate = windowScene.delegate as? SceneDelegate else { return }
        
        delegate.window?.rootViewController = loginViewController
    }
    
    
    @IBAction func onSearch(_ sender: Any) {
        //self.performSegue(withIdentifier: "searchFinance", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let cell = sender as! UITableViewCell
        let index = tableView.indexPath(for: cell)!
        let article = articles[index.row]
        let websiteView = segue.destination as! WebsiteViewController
        websiteView.article = article
        tableView.deselectRow(at: index, animated: true)
        
    }
}
