//
//  QuestionscreenController.swift
//  RijQuiz
//
//  Created by Karel Heyndrickx on 20/11/2018.
//  Copyright © 2018 Karel Heyndrickx. All rights reserved.
//

import UIKit

class QuestionscreenController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var lblQuestion: Paragraph!
    @IBOutlet weak var lblHeader: Header!
    @IBOutlet weak var navigationTitle: UINavigationItem!
    @IBOutlet weak var tableAnswers: UITableView!
    
    var currentQuiz : Quiz?
    var answers: [String] = []
    var fakeQuestions : [Question] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fakeQuestions = initializeFakeQuestions()
        loadQuiz()
        
       
        setGui()
        
       
    }
    
    @IBAction func btnNextTapped(_ sender: Any) {
        
        
    }
    
    func setGui(){
        lblHeader.text = "Vraag " + String(currentQuiz!.currentQuestion + 1)
        lblQuestion.text = currentQuiz!.questions[currentQuiz!.currentQuestion].text
        answers = currentQuiz!.questions[currentQuiz!.currentQuestion].answers
    }
    
    func initializeFakeQuestions() -> [Question]{
        let answer1 = "Ja de auto mag dat."
        let answer2 = "Nee de auto mag dat niet"
        let answer3 = "Ja, elke auto mag dat."
        
        var tempAnswers : [String] = []
        tempAnswers.append(answer1)
        tempAnswers.append(answer2)
        tempAnswers.append(answer3)
        
        let question1 = Question(text: "Mag die roze auto dat?", answers: tempAnswers, rightAnswer: answer1)
        
        let answer4 = "Ja de fiets mag dat."
        let answer5 = "Nee de auto rijdt te snel"
        let answer6 = "Ja, zelfs skateboarders mogen dat."
        
        var tempAnswers2 : [String] = []
        tempAnswers2.append(answer4)
        tempAnswers2.append(answer5)
        tempAnswers2.append(answer6)
        
        let question2 = Question(text: "Mag de fiets de auto inhalen?", answers: tempAnswers2, rightAnswer: answer4)
        
        let questions : [Question] = [question1, question2]
        return questions
        
    }
    func loadSettings() -> Settings{
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveUrl = documentsDirectory.appendingPathComponent("settings").appendingPathExtension("plist")
        
        //Set standard settings in case loading the saved settings fails
        var currentSettings = Settings(secondsPerQuestion: 15, amountOfQuestions: 50, showAnswer: false, redo: false, saveQuiz: false)
        
        let propertyListDecoder = PropertyListDecoder()
        if let retrievedPersonalSettings = try? Data(contentsOf: archiveUrl), let decodedPersonalSettings = try? propertyListDecoder.decode(Settings.self, from: retrievedPersonalSettings){
            
            currentSettings = decodedPersonalSettings
            
        }
        
        return currentSettings
    }
    
    func loadQuiz(){
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveUrl = documentsDirectory.appendingPathComponent("current_quiz").appendingPathExtension("plist")
        
        var quizExists : Bool = false
        
        let propertyListDecoder = PropertyListDecoder()
        if let retrievedCurrentQuiz = try? Data(contentsOf: archiveUrl), let decodedCurrentQuiz = try? propertyListDecoder.decode(Quiz.self, from: retrievedCurrentQuiz){
            currentQuiz = decodedCurrentQuiz
            quizExists = true
        }
        
        if !quizExists {
            let currentSettings : Settings = loadSettings()
            currentQuiz = Quiz(questions: fakeQuestions, currentSettings: currentSettings)

        }
    }

    func createAnswers() -> [String]{
        let answer1 = "Ja de auto mag dat."
        let answer2 = "Nee de auto mag dat niet"
        let answer3 = "Ja, elke auto mag dat."
        
        var tempAnswers : [String] = []
        tempAnswers.append(answer1)
        tempAnswers.append(answer2)
        tempAnswers.append(answer3)
        
        return tempAnswers
    }

}
extension QuestionscreenController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answers.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let answer = answers[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerCell") as! AnswerCell
            
        cell.setAnswer(answer: answer)
        
        return cell
    }
    
    
}
