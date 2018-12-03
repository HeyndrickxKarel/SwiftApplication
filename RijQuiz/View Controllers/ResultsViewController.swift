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
    
    var items = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30]
    
    
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
        
        return cell
    }
    

   

}
