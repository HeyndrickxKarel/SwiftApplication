//
//  ResultsViewController.swift
//  RijQuiz
//
//  Created by Karel Heyndrickx on 03/12/2018.
//  Copyright © 2018 Karel Heyndrickx. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController, UICollectionViewDataSource,UICollectionViewDelegate {

    @IBOutlet weak var lblScore: Header!
    @IBOutlet weak var lblSucceeded: Paragraph!
    
    var currentQuiz : Quiz!
    var question: Question!
    
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setResultLabels(results: currentQuiz.calculateScore())
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    self.navigationItem.setHidesBackButton(true, animated:false);
       navigationController?.setNavigationBarHidden(true, animated: false)

    }
    
/* -----------------------------  INTERACTION FUNCTIONS  -------------------------------- */
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentQuiz.getAmountAnsweredQuestions()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "resultCell", for: indexPath) as! ResultCell
        
        cell.setQuestion(questionNr: (indexPath.item + 1), answerCorrect: currentQuiz.questions[indexPath.item].checkIfAnswerCorrect())
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let question = currentQuiz.questions[indexPath.item]
       showRightAnswer(question: question)
    }
    
    /*
     CODE for the 2 animation functions underneath found at https://stackoverflow.com/questions/45651816/animate-cell-when-pressed-using-swift-3 by Rob
     CODE Implemented By Karel Heyndrickx
     */
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5) {
            if let cell = collectionView.cellForItem(at: indexPath) as? ResultCell {
                cell.contentView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5) {
            if let cell = collectionView.cellForItem(at: indexPath) as? ResultCell {
                cell.contentView.backgroundColor = .clear
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "showCorrectAnswerSegue"){
            let popupController = segue.destination as! PopUpViewController
            popupController.titel = "De onthulling"
            popupController.question = question.text
            popupController.answers = "Jouw antwoord: \n " + question.userAnswer! + "\nJuist antwoord: \n " + question.rightAnswer
        }
        
    }
    
    
    func showRightAnswer(question: Question){
        self.question = question
        performSegue(withIdentifier: "showCorrectAnswerSegue", sender: self)
    }
    
    @IBAction func btnSaveTapped(_ sender: Any) {
        
        let archiveUrl = documentsDirectory.appendingPathComponent("current_quiz").appendingPathExtension("plist")
        
        let propertyListEncoder = PropertyListEncoder()
        let encodedSettings = try? propertyListEncoder.encode(currentQuiz)
        try? encodedSettings?.write(to: archiveUrl, options: .noFileProtection)
        
    }
    @IBAction func btnEndQuizTapped(_ sender: Any) {
        
        let filemanager = FileManager.default
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask,true)[0] as NSString
        let destinationPath = documentsPath.appendingPathComponent("current_quiz.plist")
        
        //Try to delete the currently saved quiz and if the quiz file doens't exist, do nothing.
        do { try filemanager.removeItem(atPath: destinationPath)} catch {
            
        }
        
    }
    
/* ------------------------------------------------------------------------------- */


/* -----------------------------  GUI FUNCTIONS  -------------------------------- */
    
    func setResultLabels(results: (Int, Int)){
        lblScore.text = String(results.0) + "/" + String(results.1)
        
        if results.1 == 0 {
            lblSucceeded.text = "Hmmm..."
        } else {
            let percentageScore = Double(results.0) / Double(results.1)
            
            switch (percentageScore){
            case ..<0.80:
                lblSucceeded.text = "Gebuisd!"
                break
            default:
                lblSucceeded.text = "Goed zo!"
                
            }
        }
    }
    
/* ------------------------------------------------------------------------------- */


}
