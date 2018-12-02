//
//  SettingsTableController.swift
//  RijQuiz
//
//  Created by Karel Heyndrickx on 14/11/2018.
//  Copyright © 2018 Karel Heyndrickx. All rights reserved.
//

import UIKit

class SettingsTableController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var btnSave: UIBarButtonItem!
    @IBOutlet weak var stpSecondsPerQuestion: UIStepper!
    @IBOutlet weak var stpAmountOfQuestions: UIStepper!
    @IBOutlet weak var txtAmountOfQuestions: UITextField!
    @IBOutlet weak var txtSecondsPerQuestion: UITextField!
    
    @IBOutlet weak var swtRedo: UISwitch!
    
    @IBOutlet weak var swtSaveQuiz: UISwitch!
    @IBOutlet weak var swtShowAnswer: UISwitch!
    
    @IBOutlet weak var btnReset: UIButton!
    
    var previousValueStpSecondsPerQuestion : Double = 15
    var previousValueStpAmountOfQuestions : Double = 15
    let minimumSecondsPerQuestion : Int = 5
    let maximumSecondsPerQuestion : Int = 60
    let maxiumumAmountOfQuestions: Int = 100
    let standardAmountOfQuestions : Int = 50
    let standardSecondsPerQuestion : Int = 15
    let minimumAmountOfQuestions : Int = 1
    let standardShowAnswer : Bool = false
    let standardRedo : Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtAmountOfQuestions.delegate = self
        txtSecondsPerQuestion.delegate = self
        
        loadData()
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)                
        
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func loadData(){
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveUrl = documentsDirectory.appendingPathComponent("settings").appendingPathExtension("plist")
        
        let propertyListDecoder = PropertyListDecoder()
        if let retrievedPersonalSettings = try? Data(contentsOf: archiveUrl), let decodedPersonalSettings = try? propertyListDecoder.decode(Settings.self, from: retrievedPersonalSettings){
            txtAmountOfQuestions.text = String(decodedPersonalSettings.amountOfQuestions)
            txtSecondsPerQuestion.text = String(decodedPersonalSettings.secondsPerQuestion)
            swtRedo.isOn = decodedPersonalSettings.redo
            swtShowAnswer.isOn = decodedPersonalSettings.showAnswer
        }
    }
    
    @IBAction func btnSaveTapped(_ sender: Any) {
        let secondsPerQuestion:Int! = Int(txtSecondsPerQuestion.text!)
        let amountOfQuestions:Int! = Int(txtAmountOfQuestions.text!)
        let showAnswer = swtShowAnswer.isOn
        let redo = swtRedo.isOn
        let saveQuiz = swtSaveQuiz.isOn
        
        let personalSettings = Settings(secondsPerQuestion: secondsPerQuestion, amountOfQuestions: amountOfQuestions, showAnswer: showAnswer, redo: redo, saveQuiz: saveQuiz)
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveUrl = documentsDirectory.appendingPathComponent("settings").appendingPathExtension("plist")
        
        let propertyListEncoder = PropertyListEncoder()
        let encodedSettings = try? propertyListEncoder.encode(personalSettings)
        try? encodedSettings?.write(to: archiveUrl, options: .noFileProtection)
        
        
    }
    
    
    @IBAction func btnResetTriggered(_ sender: Any) {
        previousValueStpSecondsPerQuestion = Double(standardSecondsPerQuestion)
        previousValueStpAmountOfQuestions = Double(standardAmountOfQuestions)
        txtAmountOfQuestions.text =  String(standardAmountOfQuestions)
        txtSecondsPerQuestion.text = String(standardSecondsPerQuestion)
        swtRedo.isOn = false
        swtShowAnswer.isOn = false
        stpAmountOfQuestions.value = Double(standardAmountOfQuestions)
        stpSecondsPerQuestion.value = Double(standardSecondsPerQuestion)
    }
    // Deze functie zorgt er voor dat er enkel cijfers kunnen ingegeven worden in de textfields
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacter = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacter.isSuperset(of: characterSet)
    }
    
    
    /* Hieronder staan de controlefuncties om te controleren of de gebruiker niet buiten de grenswaarden gaat van het aantal vragen en het aantal seconden per vraag. Deze waarden kunnen aangepast worden door gebruik van een stepper en alsook door in te geven in een textfield. */
    @IBAction func stpAantalVragenTriggered(_ sender: UIStepper) {
        
        var value:Int! = Int(txtAmountOfQuestions.text!)
    
        if value == nil{
            value = 1
        }
    
        if sender.value > previousValueStpAmountOfQuestions {
            value += 1
        } else {
            value -= 1
        }
        txtAmountOfQuestions.text = String(value)
        sender.value = Double(value)
        previousValueStpAmountOfQuestions = Double(value)
    }
    
    
    @IBAction func stpSecondenVraagTriggered(_ sender: UIStepper) {
        var value:Int! = Int(txtSecondsPerQuestion.text!)
        
        if value == nil{
            value = 1
        }
        
        if sender.value > previousValueStpSecondsPerQuestion {
            value += 1
        } else {
            value -= 1
        }
        txtSecondsPerQuestion.text = String(value)
        sender.value = Double(value)
        previousValueStpSecondsPerQuestion = Double(value)
    }
    
    @IBAction func txtAantalVragenAangepast(_ sender: Any) {
        var value:Int! = Int(txtAmountOfQuestions.text!)
        
        if value == nil || value < minimumAmountOfQuestions{
            value = minimumAmountOfQuestions
        } else if value > maxiumumAmountOfQuestions {
            value = maxiumumAmountOfQuestions
        }
        txtAmountOfQuestions.text = String(value)
    }
    @IBAction func txtSecondenVraagAangepast(_ sender: Any) {
        var value:Int! = Int(txtSecondsPerQuestion.text!)
        
        if value == nil || value < minimumSecondsPerQuestion{
            value = minimumSecondsPerQuestion
        } else if value > maximumSecondsPerQuestion {
            value = maximumSecondsPerQuestion
        }
        txtSecondsPerQuestion.text = String(value)
    }
   
}
