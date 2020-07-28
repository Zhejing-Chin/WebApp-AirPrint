//
//  MainViewController.swift
//  WebApp-AirPrint
//
//  Created by Zhe Jing on 28/07/2020.
//  Copyright © 2020 Gogain Chin. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var websiteText: UITextField!
    
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        performSegue(withIdentifier: "webapp", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "webapp" {
            // Create a new variable to store the instance of ViewController
            let destinationVC = segue.destination as! ViewController
            destinationVC.website = websiteText.text!
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if websiteText.hasText {
            doneButton?.isUserInteractionEnabled = true
            doneButton?.alpha = 1.0
        }
        else {
            doneButton?.isUserInteractionEnabled = false
            doneButton?.alpha = 0.5
        }
    }
    
    
}
