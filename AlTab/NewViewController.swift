//
//  NewViewController.swift
//  AlTab
//
//  Created by MAC on 18.12.2020.
//  Copyright © 2020 MAC. All rights reserved.
//

import UIKit
import SwiftSoup

class NewViewController: UIViewController {
    @IBOutlet weak var answersLabel: UILabel!
    
    @IBOutlet weak var detailsView: UIScrollView!
    
    @IBOutlet weak var questionUpDated: UILabel!
    
    @IBOutlet weak var askerNameLabel: UILabel!
    
    @IBOutlet weak var questionscoreLabel: UILabel!
    
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var answerdateLabel: UILabel!
    
    @IBOutlet weak var answervotesLabel: UILabel!
    
    @IBOutlet weak var answernameLabel: UILabel!
    
    
    
    var questionLink: String = ""
    var askerDate: String = ""
    var askerName: String = ""
    var questionScore: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionUpDated.text = askerDate
        askerNameLabel.text = askerName
        questionscoreLabel.text = "\(questionScore)"
        
        let myURLString = questionLink
        guard let myURL = URL(string: myURLString) else { return }
        do {
            let myHTMLString = try String(contentsOf: myURL, encoding: .utf8)
            let htmlContent = myHTMLString
            
            do {
                let doc = try SwiftSoup.parse(htmlContent)
                do {
                    
                    
                    let answersElement = try doc.getElementById("answers")
                    let answersParagraphs: [Element] = try answersElement!.select("p").array()
                    do {
                        var text = ""
                        for answers in answersParagraphs {
                            if text.count > 0 {
                                text += "\n"
                            }
                            text += try answers.text()
                        }
                        answersLabel.text = text
                        }
                    
                    
                    let questionElement = try doc.getElementsByClass("postcell")
                    let questionParagraphs: [Element] = try questionElement.select("p").array()
                    do {
                        var qtext = ""
                        for questions in questionParagraphs {
                            if qtext.count > 0 {
                                qtext += "\n"
                            }
                            qtext += try questions.text()
                        }
                        questionLabel.text = qtext
                        }
                    
                    
                    let answervotesElement = try doc.getElementsByClass("js-vote-count").array()
                    if answervotesElement.count > 0 {
                        let answervotesData = try answervotesElement[0].attr("data-value")//.text()
                        do {
                            answervotesLabel.text = answervotesData
                        }
                    }
                    
                    let answerdateElement = try doc.getElementsByClass("user-action-time").array()
                    if answerdateElement.count > 2 {
                         let answerdateData = try answerdateElement[2].text()
                        do {
                            answerdateLabel.text = answerdateData
                        }
                    }
                    
                    let answernameElement = try doc.getElementsByClass("user-details").array()
                    if answernameElement.count > 4 {
                        let answernameData = try answernameElement[4].text()
                        do {
                            answernameLabel.text = answernameData
                        }
                    }
                    
                    do {
                        
                    }
                    
                } catch {
                    
                }
               
            }
            
        } catch let error {
            print("Error: \(error)")
        }
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
