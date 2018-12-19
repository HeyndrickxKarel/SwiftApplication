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
    @IBOutlet weak var btnBack: ShadowButton!
    
    var currentQuiz : Quiz!
    var question: Question!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let results = currentQuiz.calculateScore()
        lblScore.text = String(results.0) + "/" + String(results.1)
                
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(currentQuiz.getAmountAnsweredQuestions())
        return currentQuiz.getAmountAnsweredQuestions()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "resultCell", for: indexPath) as! ResultCell
        
        print(indexPath.item)
        
        cell.setQuestion(questionNr: (indexPath.item + 1), question: currentQuiz.questions[indexPath.item])
        cell.resultsViewController = self
        
        return cell
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

    

   

}
