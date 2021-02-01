//
//  ViewController.swift
//  AggieFeed
//
//  Created by Tom Abraham on 1/31/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    let names = [
        "John Smith",
        "Dan Smith",
        "Jason Smith",
        "Mary Smith"
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchPostData { (posts) in
            for post in posts {
                print(post.title!)
            }
        }
        
    }
    
    func fetchPostData(completionHandler: @escaping ([Post]) -> Void) {
        let url = URL(string: "https://aggiefeed.ucdavis.edu/api/v1/activity/public?s=0?l=25")!
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else { return }
            
            do {
                
                let postsData = try JSONDecoder().decode([Post].self, from: data)
                
                completionHandler(postsData)
            }
            catch {
                let error = error
                print(error.localizedDescription)
            }
            
        }.resume()
    }
    
    
    
  


}


// MARK: - WelcomeElement
//struct WelcomeElement: Codable {
//    var title: String!
//    public let actor: Actor
//    public let object: Object
//    public let published: String
//
//}

//// MARK: - Actor
//struct Actor: Codable {
//    public let displayName: String
//}
//
//// MARK: - Object
//struct Object: Codable {
//    public let objectType: ObjectObjectType
//
//}
//
//enum ObjectObjectType: String, Codable {
//    case event = "event"
//    case notification = "notification"
//}


extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("you tapped me!")
    }
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = names[indexPath.row]
        return cell
    }
}

