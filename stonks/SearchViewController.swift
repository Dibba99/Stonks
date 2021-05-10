//
//  SearchViewController.swift
//  stonks
//
//  Created by Cosmo on 5/1/21.
//

import UIKit
import NotificationBannerSwift

extension String {

    func trimAllSpace() -> String {
         return components(separatedBy: .whitespacesAndNewlines).joined()
    }
    
    func trimSpace() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension UITableView {

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .lightGray
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 25)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var articles = [[String:Any]]()
    
    
    @IBAction func clearButton(_ sender: Any) {
        articles.removeAll()
        tableView.reloadData()
        searchTextField.text?.removeAll()
        articleResults.text = "\(articles.count)"
    }
    
    @IBOutlet weak var articleResults: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewAnimator: ViewAnimator!
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBAction func searchButton(_ sender: Any) {
        let txt = searchTextField.text!
        let input = txt.trimAllSpace()
        if input == "" || input.hasPrefix(" ") || input.hasSuffix(" "){
            let alert = UIAlertController(title: "Woah There!", message: "Please don't leave search field blank!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }else{
            let date = Date()
            let calendar_date = Calendar.current
            let date2 = Calendar.current.date(byAdding: .day, value: -5, to: date)!
            let calendar_date2 = Calendar.current
            let date_year = calendar_date.component(.year, from: date)
            let date_month = calendar_date.component(.month, from: date)
            let date_day = calendar_date.component(.day, from: date)
            let date2_year = calendar_date2.component(.year, from: date2)
            let date2_month = calendar_date2.component(.month, from: date2)
            let date2_day = calendar_date2.component(.day, from: date2)
            let official_date = "\(date_year)-\(date_month)-\(date_day)"
            let official_date2 = "\(date2_year)-\(date2_month)-\(date2_day)"
            let url = URL(string: "https://newsapi.org/v2/everything?q=\(input)&from=\(official_date2)&to=\(official_date)&sortBy=popularity&apiKey=bb7b045c2afb4fa1ac4148821ff98bc5")!
            let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
            let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
            let task = session.dataTask(with: request) { [self] (data, response, error) in
                 // This will run when the network request returns
                 if let error = error {
                    let alert = UIAlertController(title: "OOPS - trouble loading data", message: "\(error.localizedDescription)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                        print(error.localizedDescription)
                 } else if let data = data {
                        let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]

                    self.articles = dataDictionary["articles"] as! [[String:Any]]
                    self.articleResults.text = "\(articles.count)"
                    if articles.count != 0 {
                        articleResults.textColor = UIColor.blue
                    }else{
                        articleResults.textColor = UIColor.red
                    }
                    self.tableView.reloadData()
                 }
            }
            task.resume()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        viewAnimator.layer.cornerRadius = 20
        viewAnimator.layer.shadowColor = UIColor.black.cgColor
        viewAnimator.layer.shadowOpacity = 20
        viewAnimator.layer.shadowOffset = .zero
        viewAnimator.layer.shadowRadius = 20
        searchTextField.layer.cornerRadius = 10.0
        searchTextField.layer.borderWidth = 1.0
        searchTextField.layer.borderColor = UIColor.black.cgColor
        searchTextField.layer.masksToBounds = true
        
        view.bringSubviewToFront(viewAnimator)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if articles.count == 0 {
                self.tableView.setEmptyMessage("Search any news article on the web \nfrom the last 5 days!")
            } else {
                self.tableView.restore()
            }

            return articles.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell") as! SearchCell
        
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        let index = tableView.indexPath(for: cell)!
        let article = articles[index.row]
        let websiteView = segue.destination as! ThirdWebsiteViewController
        websiteView.article = article
        tableView.deselectRow(at: index, animated: true)
    }
    

}
