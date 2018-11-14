//
//  SettingsTableController.swift
//  RijQuiz
//
//  Created by Karel Heyndrickx on 14/11/2018.
//  Copyright © 2018 Karel Heyndrickx. All rights reserved.
//

import UIKit

class SettingsTableController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var stpSecondenVraag: UIStepper!
    @IBOutlet weak var stpAantalVragen: UIStepper!
    @IBOutlet weak var txtAantalVragen: UITextField!
    @IBOutlet weak var txtSecondenVraag: UITextField!
    
    @IBOutlet weak var swtHerkansing: UISwitch!
    
    @IBOutlet weak var swtToonAntwoord: UISwitch!
    
    @IBOutlet weak var btnReset: UIButton!
    
    var vorigeWaardeStpSecondenVraag : Double = 15
    var vorigeWaardeStpAantalVragen : Double = 15
    let minimumSecondenVraag : Int = 5
    let maximumSecondenVraag : Int = 60
    let maxiumumAantalVragen: Int = 100
    let standaardAantalVragen : Int = 50
    let standaardAantalSeconden : Int = 15
    let minimumAantalVragen : Int = 1
    let standaardToonAntwoord : Bool = false
    let standaardHerkansing : Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtAantalVragen.delegate = self
        txtSecondenVraag.delegate = self
        
    }
    
    @IBAction func btnResetTriggered(_ sender: Any) {
        vorigeWaardeStpSecondenVraag = Double(standaardAantalSeconden)
        vorigeWaardeStpAantalVragen = Double(standaardAantalVragen)
        txtAantalVragen.text =  String(standaardAantalVragen)
        txtSecondenVraag.text = String(standaardAantalSeconden)
        swtHerkansing.isOn = false
        swtToonAntwoord.isOn = false
        stpAantalVragen.value = Double(standaardAantalVragen)
        stpSecondenVraag.value = Double(standaardAantalSeconden)
    }
    // Deze functie zorgt er voor dat er enkel cijfers kunnen ingegeven worden in de textfields
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacter = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacter.isSuperset(of: characterSet)
    }
    
    
    /* Hieronder staan de controlefuncties om te controleren of de gebruiker niet buiten de grenswaarden gaat van het aantal vragen en het aantal seconden per vraag. Deze waarden kunnen aangepast worden door gebruik van een stepper en alsook door in te geven in een textfield. */
    @IBAction func stpAantalVragenTriggered(_ sender: UIStepper) {
        
        var waarde:Int! = Int(txtAantalVragen.text!)
    
        if waarde == nil{
            waarde = 1
        }
    
        if sender.value > vorigeWaardeStpAantalVragen {
            waarde += 1
        } else {
            waarde -= 1
        }
        txtAantalVragen.text = String(waarde)
        sender.value = Double(waarde)
        vorigeWaardeStpAantalVragen = Double(waarde)
    }
    
    
    @IBAction func stpSecondenVraagTriggered(_ sender: UIStepper) {
        var waarde:Int! = Int(txtSecondenVraag.text!)
        
        if waarde == nil{
            waarde = 1
        }
        
        if sender.value > vorigeWaardeStpSecondenVraag {
            waarde += 1
        } else {
            waarde -= 1
        }
        txtSecondenVraag.text = String(waarde)
        sender.value = Double(waarde)
        vorigeWaardeStpSecondenVraag = Double(waarde)
    }
    
    @IBAction func txtAantalVragenAangepast(_ sender: Any) {
        var waarde:Int! = Int(txtAantalVragen.text!)
        
        if waarde == nil || waarde < minimumAantalVragen{
            waarde = minimumAantalVragen
        } else if waarde > maxiumumAantalVragen {
            waarde = maxiumumAantalVragen
        }
        txtAantalVragen.text = String(waarde)
    }
    @IBAction func txtSecondenVraagAangepast(_ sender: Any) {
        var waarde:Int! = Int(txtSecondenVraag.text!)
        
        if waarde == nil || waarde < minimumSecondenVraag{
            waarde = minimumSecondenVraag
        } else if waarde > maximumSecondenVraag {
            waarde = maximumSecondenVraag
        }
        txtSecondenVraag.text = String(waarde)
    }
   
}
