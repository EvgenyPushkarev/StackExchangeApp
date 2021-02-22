//
//  UsersViewController.swift
//  AlTab
//
//  Created by MAC on 18.05.2020.
//  Copyright © 2020 MAC. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class UsersViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var usersData: [UserModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 50
        self.tableView.register(UINib(nibName: "UsersTableViewCell", bundle: nil), forCellReuseIdentifier: "UsersTableViewCell")
        
        fetchUsersData()
        
    }
    
    func fetchUsersData() {
        DispatchQueue.main.async {
            AF.request("http://api.stackexchange.com/2.2/questions?order=desc&sort=activity&tagged=ios&site=stackoverflow").responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print(json)
                    let data = json[]
                    data["items"].array?.forEach({ (user) in
                        let user = UserModel(
                            name: user["owner"]["display_name"].stringValue,
                            title: user["title"].stringValue,
                            date: user["last_edit_date"].stringValue,
                            answercount: user["answer_count"].stringValue,
                            image: user["owner"]["profile_image"].stringValue,
                            link: user["link"].stringValue,
                            questionscore: user["score"].intValue
                        )
                        self.usersData.append(user)
                    })
                    self.tableView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
        }
    }

}

extension UsersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.usersData.count > 20 {
            return 20
        }
        
        return self.usersData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UsersTableViewCell", for: indexPath) as! UsersTableViewCell
        let user = usersData[indexPath.row]
        cell.nameLabel.text = user.name
        cell.titleLabel.text = user.title
        
        var date: Date = Date()
        let timeInterval = Double(user.date)
        if let interval = timeInterval {
            date = Date(timeIntervalSince1970: interval)
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        cell.dateLabel.text = dateFormatter.string(from: date)
        
        
        cell.answerscountLabel.text = user.answercount
        if let imageURL = URL(string: user.image) {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageURL)
                if let data = data {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        cell.imageLabel.image = image
                    }
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "NewViewController") as? NewViewController
        vc?.questionLink = usersData[indexPath.row].link
        vc?.askerName = usersData[indexPath.row].name
        vc?.questionScore = usersData[indexPath.row].questionscore
        
        let user = usersData[indexPath.row]
        var date: Date = Date()
        let timeInterval = Double(user.date)
        if let interval = timeInterval {
            date = Date(timeIntervalSince1970: interval)
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        vc?.askerDate = dateFormatter.string(from: date)
        
        self.navigationController?.pushViewController(vc!, animated: true)
    } 
}
