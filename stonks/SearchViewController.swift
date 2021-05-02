//
//  SearchViewController.swift
//  stonks
//
//  Created by Cosmo on 5/1/21.
//

import UIKit

extension String {

    func trimAllSpace() -> String {
         return components(separatedBy: .whitespacesAndNewlines).joined()
    }
    
    func trimSpace() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var articles = [[String:Any]]()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewAnimator: ViewAnimator!
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBAction func searchButton(_ sender: Any) {
        let txt = searchTextField.text!
        let input = txt.trimAllSpace()
        print(input)
        if input == "" || input.hasPrefix(" ") || input.hasSuffix(" "){
            let alert = UIAlertController(title: "Whoops!", message: "Please don't leave search field blank!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }else{
        
            let url = URL(string: "https://newsapi.org/v2/everything?q=\(input)&from=2021-04-30&to=2021-04-30&sortBy=popularity&apiKey=c6dd39d340374529a4cd7ebb2e4d2b52")!
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
        // Do any additional setup after loading the view.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
