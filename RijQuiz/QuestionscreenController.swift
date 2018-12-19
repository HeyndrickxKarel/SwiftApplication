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
    
    @IBOutlet weak var btnAnswer1: UIButton!
    @IBOutlet weak var btnAnswer2: UIButton!
    @IBOutlet weak var btnAnswer3: UIButton!
    
    @IBOutlet weak var btnNext: ShadowButton!
    @IBOutlet weak var lblTimer: UILabel!
    
    var currentQuiz : Quiz?
    var answers: [String] = []
    var fakeQuestions : [Question] = []
    var answerCorrect : Bool = false
    var currentAnswer : String = ""
    var lastTappedButton : UIButton!
    
    var seconds : Int = 0
    var timer = Timer()
    var isTimerRunning = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fakeQuestions = initializeFakeQuestions()
        loadQuiz()
        
        setGui()
        
        startTimer()
        
    }
    
    @IBAction func btnStopEarlyTapped(_ sender: Any) {
        pauseTimer()
        performSegue(withIdentifier: "passQuizSegue", sender: self)
    }
    @IBAction func btnNextTapped(_ sender: Any) {
        
        gaNaarVolgendeVraag()
        
    }
    
    func startTimer(){
        seconds = currentQuiz!.currentSettings.secondsPerQuestion
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(QuestionscreenController.updateTimer)), userInfo: nil, repeats: true)
    }
    func pauseTimer(){
        timer.invalidate()
    }
    @objc func updateTimer(){
        if seconds == 0 {
            gaNaarVolgendeVraag()
        } else {
            seconds -= 1
            lblTimer.text = String(seconds)
        }
    }
    func resetTimer(){
        seconds = currentQuiz!.currentSettings.secondsPerQuestion
    }
    
    func gaNaarVolgendeVraag(){
        
        currentQuiz!.answerQuestion(answer: currentAnswer)
        
        // check if answer correct
        if (currentQuiz!.isAnswerCorrect() == true){
            
            if currentQuiz!.isThereAnotherQuestion() {
                currentQuiz!.nextQuestion()
                setGui()
            } else {
                pauseTimer()
                performSegue(withIdentifier: "passQuizSegue", sender: self)
            }
           
        } else {
            // check if redo and answer wrong()
            if (currentQuiz!.currentSettings.redo == true  && currentQuiz!.isAnswerCorrect() != true){
                
                //check how many attempts in order to go to next question and or show the answer
                if currentQuiz!.attempts == 1 {
                    if (currentQuiz!.currentSettings.showAnswer == true){
                        //createAlert(title: "Jammer!", message: "Je vond het maar niet! Het juiste antwoord was: '" + currentQuiz!.questions[currentQuiz!.currentQuestion].rightAnswer + "'", showAnswer: true)
                        performSegue(withIdentifier: "showCorrectAnswerSegue", sender: self)
                    }
                    
                } else if currentQuiz!.attempts == 2 {
                    
                    if currentAnswer != ""{
                        lastTappedButton.setTitleColor(UIColor.red, for: .normal)
                    }
                    
                    createAlert(title: "Oops", message: "Je antwoord was fout maar je hebt nog een herkansing!", showAnswer: false)
                }
      
            }
 
        }

        currentAnswer = ""
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "passQuizSegue"){
            let resultsController = segue.destination as! ResultsViewController
            resultsController.currentQuiz = currentQuiz
        }
        if(segue.identifier == "showCorrectAnswerSegue"){
            let popupController = segue.destination as! PopUpViewController
            popupController.titel = "Oei, dat was fout!"
            popupController.question = currentQuiz!.questions[currentQuiz!.currentQuestion].text
            popupController.answers = "Jouw antwoord: \n " + currentQuiz!.questions[currentQuiz!.currentQuestion].userAnswer! + "\nJuist antwoord: \n " + currentQuiz!.questions[currentQuiz!.currentQuestion].rightAnswer
        }
        
       
    }
    
    
    func setGui(){
        
        navigationTitle.title = "Vraag " + String(currentQuiz!.currentQuestion + 1) + "/" + String(currentQuiz!.questions.count)

        lblHeader.text = "Vraag " + String(currentQuiz!.currentQuestion + 1)
        lblQuestion.text = currentQuiz!.questions[currentQuiz!.currentQuestion].text
        lblTimer.text = String(currentQuiz!.currentSettings.secondsPerQuestion)

        answers = currentQuiz!.questions[currentQuiz!.currentQuestion].answers
        
        btnAnswer1.setTitle(answers[0], for:.normal)
        btnAnswer2.setTitle(answers[1], for:.normal)
        btnAnswer3.setTitle(answers[2], for:.normal)
        
        resetButtonColors()
        
        resetTimer()

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
        
        let answer7 = "Ja duuuh"
        let answer8 = "Nee joh, tuurlijk niet."
        let answer9 = "Als je dood wilt, wel ja"
        
        var tempAnswers3 : [String] = []
        tempAnswers3.append(answer7)
        tempAnswers3.append(answer8)
        tempAnswers3.append(answer9)
        
        let question3 = Question(text: "Mag je hier over steken?", answers: tempAnswers3, rightAnswer: answer9)
        
        
        let questions : [Question] = [question1, question2, question3, question1, question2, question3, question1, question2, question3, question1]
        return questions
        
    }
    
    func createAlert(title: String, message: String, showAnswer: Bool){
        
        pauseTimer()
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Oké", style: UIAlertAction.Style.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
            
            if showAnswer {
                if self.currentQuiz!.isThereAnotherQuestion() {
                    self.currentQuiz!.nextQuestion()
                    self.setGui()
                } else {
                    self.pauseTimer()
                    self.performSegue(withIdentifier: "passQuizSegue", sender: self)
                }
            } else {
                self.currentQuiz!.nextAttempt()
            }
            self.startTimer()
            
        }))
        
        self.present(alert, animated: true,completion: nil)
    }
   
    func resetButtonColors(){
        btnAnswer1.setTitleColor(UIColor.darkGray, for: .normal)
        btnAnswer2.setTitleColor(UIColor.darkGray, for: .normal)
        btnAnswer3.setTitleColor(UIColor.darkGray, for: .normal)
    }
    @IBAction func btnAnswerTapped(_ sender: UIButton) {
        
        resetButtonColors()
        
        if let buttonTitle = sender.title(for: .normal) {
            currentAnswer = buttonTitle
            sender.setTitleColor(UIColor.blue, for: .normal)
            lastTappedButton  = sender
        }
        
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
    
    
    
}

