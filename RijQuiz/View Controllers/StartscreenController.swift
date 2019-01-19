//
//  ViewController.swift
//  RijQuiz
//
//  Created by Karel Heyndrickx on 10/11/2018.
//  Copyright © 2018 Karel Heyndrickx. All rights reserved.
//

import UIKit

class StartscreenController: UIViewController {
    
    @IBOutlet weak var btnStart: ShadowButton!
    @IBOutlet weak var lblStatus: Paragraph!
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let propertyListDecoder = PropertyListDecoder()
    let propertyListEncoder = PropertyListEncoder()
    
    let settingsURL = "https://rijquiz-backend.herokuapp.com/api/settings"
    let questionsURL = "https://rijquiz-backend.herokuapp.com/api/questions"
    var currentQuestionList: QuestionList?
    
    //This dispatchgroup is used when fetching new questions from the internet. The app has to wait until the questions are loaded
    let dispatchGroup = DispatchGroup()
    
    var loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //As long as the questions are loading, the startscreen will be in a waiting state
        displayWaitingState()
        
        loadQuestionList()
        
        checkQuestionlistVersionAndUpdate()
        
        //Whenever the async task for fetching the questions is running the startscreen will not enter the ready state.
        dispatchGroup.notify(queue: .main){
            self.displayReadyState()
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    /* -----------------------------  INTERACTION FUNCTIONS  -------------------------------- */
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "startQuizSegue"){
            let questionscreenController = segue.destination as! QuestionscreenController
            questionscreenController.questionList = self.currentQuestionList
        }
        
    }
    
    @IBAction func btnStartTapped(_ sender: Any) {
        performSegue(withIdentifier: "startQuizSegue", sender: self)
    }
    
    @IBAction func unwindToStartscreen(_ sender: UIStoryboardSegue){}
    
    
    /* ------------------------------------------------------------------------------- */
    
    
    /* -----------------------------  GUI FUNCTIONS  -------------------------------- */
    
    func displayWaitingState(){
        
        btnStart.alpha = 0.6
        btnStart.isEnabled = false
        lblStatus.isHidden = false
    }
    func displayReadyState(){
        
        self.lblStatus.isHidden = true
        self.btnStart.alpha = 1.0
        btnStart.isEnabled=true
    }
    
    /* ------------------------------------------------------------------------------- */
    
    /* -----------------------------  LOADING FUNCTIONS  -------------------------------- */
    
    
    func loadQuestionList(){
        let archiveUrl = documentsDirectory.appendingPathComponent("questionList").appendingPathExtension("plist")
        
        
        if let retrievedQuestionList = try? Data(contentsOf: archiveUrl), let decodedQuestionList = try? propertyListDecoder.decode(QuestionList.self, from: retrievedQuestionList){
            
            self.currentQuestionList = decodedQuestionList
            
        }
        
    }
    
    func checkQuestionlistVersionAndUpdate(){
        
        dispatchGroup.enter()

        
        let url = URL(string: settingsURL)
        URLSession.shared.dataTask(with: url!){(data, reponse,err) in
            
            guard let data = data else {return}
            
            do {
                let jsonData : [String: Any]
                jsonData = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String : Any]
                
                let version = jsonData["version"] as? String ?? ""
                
                //If version was found but is different from the currently saved questionlist
                if self.currentQuestionList == nil || self.currentQuestionList?.version != version {
                    self.loadAndSaveQuestions(version: version)
                }
                
            } catch let jsonError {
                print (jsonError)
            }
            
            self.dispatchGroup.leave()
            
            }.resume()
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
    
    /* ------------------------------------------------------------------------------- */

    
}

