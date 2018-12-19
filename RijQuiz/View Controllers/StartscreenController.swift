//
//  ViewController.swift
//  RijQuiz
//
//  Created by Karel Heyndrickx on 10/11/2018.
//  Copyright © 2018 Karel Heyndrickx. All rights reserved.
//

import UIKit

class StartscreenController: UIViewController {
    
    @IBOutlet weak var lblStatus: Paragraph!
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let propertyListDecoder = PropertyListDecoder()
    let propertyListEncoder = PropertyListEncoder()
    
    let settingsURL = "https://rijquiz-backend.herokuapp.com/api/settings"
    let questionsURL = "https://rijquiz-backend.herokuapp.com/api/questions"
    var currentQuestionList: QuestionList?
    
    var loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadQuestionList()
        
        //Display indiciator in case loading the questions from the web takes a while
        startLoadingIndicator()

        //If questionList doesn't yet exist
        if self.currentQuestionList == nil {
            loadAndSaveQuestions(version: "1.0.0")
        } else {
            //Load version of list
            loadQuestionListVersion()
           
        }
        //Remove the indicator
        stopLoadingIndicator()


    }

    
    func loadQuestionListVersion() {
        
        let url = URL(string: settingsURL)
        URLSession.shared.dataTask(with: url!){(data, reponse,err) in

            guard let data = data else {return}
            
            do {
                let jsonData : [String: Any]
                jsonData = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String : Any]
                print (jsonData)
                
                let version = jsonData["version"] as? String ?? ""
                
                //If version was found but is different from the currently saved questionlist
                if self.currentQuestionList?.version != version {
                    print("list got updated")
                    self.loadAndSaveQuestions(version: version)
                }
                if self.currentQuestionList?.version == version {
                    print("version is still the same")
                }
                
            } catch let jsonError {
                print (jsonError)
            }
            
        }.resume()
        
       
    }
    
    
    func loadQuestionList(){
        let archiveUrl = documentsDirectory.appendingPathComponent("questionList").appendingPathExtension("plist")
        
        
        if let retrievedQuestionList = try? Data(contentsOf: archiveUrl), let decodedQuestionList = try? propertyListDecoder.decode(QuestionList.self, from: retrievedQuestionList){
            
            self.currentQuestionList = decodedQuestionList
            
        }
        
    }
    
    func loadAndSaveQuestions(version : String){
        let url = URL(string: questionsURL)
        URLSession.shared.dataTask(with: url!){(data, reponse,err) in
            
            guard let data = data else {return}
            
            do {

                let questions = try JSONDecoder().decode([Question].self, from: data)
                print(questions)
                
                self.currentQuestionList = QuestionList(version: version, questions: questions)
                
                let archiveUrl = self.documentsDirectory.appendingPathComponent("questionList").appendingPathExtension("plist")
                
                let encodedQuestionList = try? self.propertyListEncoder.encode(self.currentQuestionList)
                try? encodedQuestionList?.write(to: archiveUrl, options: .noFileProtection)
                
            } catch let jsonError {
                print (jsonError)
            }
            
            }.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "startQuizSegue"){
            let questionscreenController = segue.destination as! QuestionscreenController
            questionscreenController.questionList = self.currentQuestionList
        }
                
        
    }
    
    @IBAction func btnStartTapped(_ sender: Any) {
         performSegue(withIdentifier: "startQuizSegue", sender: self)
    }
    func startLoadingIndicator(){
        
        lblStatus.isHidden = false
        
        loadingIndicator.center = self.view.center
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        view.addSubview(loadingIndicator)
        
        loadingIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    func stopLoadingIndicator(){
        lblStatus.isHidden = true

        loadingIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
}

