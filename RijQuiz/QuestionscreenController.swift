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
    
    var questionList : QuestionList! = nil
    var fakeQuestions : [Question] = []
    var answerCorrect : Bool = false
    var currentAnswer : String = ""
    var lastTappedButton : UIButton!
    
    var timer = Timer()
    var isTimerRunning = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadQuiz()
        
        setGui()
        
        startTimer()
        
    }

    
    @IBAction func btnStopEarlyTapped(_ sender: Any) {
        pauseTimer()
        performSegue(withIdentifier: "passQuizSegue", sender: self)
    }
    @IBAction func btnNextTapped(_ sender: Any) {
        
        goToNextQuestion()
        
    }
    
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(QuestionscreenController.updateTimer)), userInfo: nil, repeats: true)
    }
    func pauseTimer(){
        timer.invalidate()
    }
    @objc func updateTimer(){
        if currentQuiz!.noTimeLeft() {
            goToNextQuestion()
        } else {
            currentQuiz!.timerTik()
            lblTimer.text = String(currentQuiz!.timeLeftThisTurn)
        }
    }
    func resetTimer(){
        currentQuiz!.resetTimer()
        lblTimer.text = String(currentQuiz!.timeLeftThisTurn)

    }
    
    func goToNextQuestion(){
        
        currentQuiz!.answerQuestion(answer: currentAnswer)
        
        // check if answer correct
        if (currentQuiz!.isAnswerCorrect() == true){
            
            if currentQuiz!.isThereAnotherQuestion() {
                currentQuiz!.nextQuestion()
                setGui()
            } else {
                pauseTimer()
                currentQuiz!.lastQuestionWasAnswered()
                performSegue(withIdentifier: "passQuizSegue", sender: self)
            }
           
        } else {
            // check if redo and answer wrong()
            if (currentQuiz!.currentSettings.redo == true ){
                
                //check how many attempts in order to go to next question and or show the answer
                if currentQuiz!.attempts == 1 {
                    
                    showCorrectView()
                    
                    
                } else if currentQuiz!.attempts == 2 {
                    
                    if currentAnswer != ""{
                        lastTappedButton.setTitleColor(UIColor.red, for: .normal)
                    }
                    
                    createAlert(title: "Oops", message: "Je antwoord was fout maar je hebt nog een herkansing!")
                    currentQuiz!.nextAttempt()

                }
      
            } else {
                showCorrectView()
                
            }
        }

        currentAnswer = ""
    }
    
    func showCorrectView(){
        if currentQuiz!.currentSettings.showAnswer == true{
            
            pauseTimer()
            if currentQuiz!.isThereAnotherQuestion() {
                performSegue(withIdentifier: "showCorrectAnswerSegue", sender: self)
                currentQuiz!.nextQuestion()
                setGui()
            } else {
                currentQuiz!.lastQuestionWasAnswered()
                performSegue(withIdentifier: "passQuizSegue", sender: self)
            }
        } else {
            if currentQuiz!.isThereAnotherQuestion() {
                currentQuiz!.nextQuestion()
                setGui()
            } else {
                currentQuiz!.lastQuestionWasAnswered()
                performSegue(withIdentifier: "passQuizSegue", sender: self)
            }
        }
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "passQuizSegue"){
            let resultsController = segue.destination as! ResultsViewController
            resultsController.currentQuiz = currentQuiz
        }
        if(segue.identifier == "showCorrectAnswerSegue"){
            let popupController = segue.destination as! PopUpViewController
            popupController.questionscreenController = self
            popupController.titel = "Oei, dat was fout!"
            popupController.question = currentQuiz!.questions[currentQuiz!.currentQuestion].text
            popupController.answers = "Jouw antwoord: \n " + currentQuiz!.questions[currentQuiz!.currentQuestion].userAnswer! + "\nJuist antwoord: \n " + currentQuiz!.questions[currentQuiz!.currentQuestion].rightAnswer
        }
        
    }
    

    
    func setGui(){
        
        navigationTitle.title = "Vraag " + String(currentQuiz!.currentQuestion + 1) + "/" + String(currentQuiz!.questions.count)

        lblHeader.text = "Vraag " + String(currentQuiz!.currentQuestion + 1)
        lblQuestion.text = currentQuiz!.questions[currentQuiz!.currentQuestion].text

        resetTimer()
        
        let answers = currentQuiz!.questions[currentQuiz!.currentQuestion].answers
        
        btnAnswer1.setTitle(answers[0], for:.normal)
        btnAnswer2.setTitle(answers[1], for:.normal)
        btnAnswer3.setTitle(answers[2], for:.normal)
        
        resetButtonColors()
        
        resetTimer()

    }
    
    func createAlert(title: String, message: String){
        
        pauseTimer()
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Oké", style: UIAlertAction.Style.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
            
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
            
        
            //If the amount of existing questions is larger than the amount of prefered questions then just take all the questions
            if currentSettings.amountOfQuestions >= questionList.questions.count{
                currentQuiz = Quiz(questions: questionList.questions, currentSettings: currentSettings)

            }
            
            //If the amount of existing questions is not larger then shuffle the questions and take n amount
            else {
                let pickedQuestions = questionList.questions.shuffled()
                let pickedNQuestions = pickedQuestions.choose(currentSettings.amountOfQuestions)
                currentQuiz = Quiz(questions: pickedNQuestions, currentSettings: currentSettings)

            }
            
            
        }
    }
    
    
    
}

