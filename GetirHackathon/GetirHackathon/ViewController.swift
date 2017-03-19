//
//  ViewController.swift
//  GetirHackathon
//
//  Created by Aleks Mutlu on 19/03/2017.
//  Copyright © 2017 Mutlu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtGSM: UITextField!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var lblHint: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var delay = 0.0
        self.stackView.arrangedSubviews.forEach { view in
            view.comeIn(after: delay)
            delay += 0.1
        }
        
    }


    @IBAction func btnSendPressed(_ sender: UIButton) {
        // Check if textFields are not empty
        var formIsValid = true
        
        if self.txtEmail.text!.isEmpty { self.txtEmail.shake(); formIsValid = false }
        if self.txtName.text!.isEmpty { self.txtName.shake(); formIsValid = false }
        if self.txtGSM.text!.isEmpty { self.txtGSM.shake(); formIsValid = false }
        
        guard formIsValid else { return }
        
        // UI Updates
        self.btnSend.animate(text: "Gönderiliyor...", newBackgroundColor: .gray, animationSubType: kCATransitionFromLeft)
        self.btnSend.isEnabled = false
        
        self.view.endEditing(true)
        
        // Create User and try to fetch data
        let user = User(email: self.txtEmail.text!, name: self.txtName.text!, gsm: self.txtGSM.text!)
        user.getElements() {
            [weak self]
            shapeList, error in
            
            // Handle error
            guard error == nil else {
                let alert = UIAlertController(title: "Hata", message: "Bir hata oluştu", preferredStyle: .alert)
                let actionOk = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
                alert.addAction(actionOk)
                
                DispatchQueue.main.async {
                    self?.present(alert, animated: true, completion: nil)
                    self?.btnSend.isEnabled = true
                    
                    self?.btnSend.layer.backgroundColor = UIColor.orange.cgColor
                    self?.btnSend.setTitle("Tekrar Gönder", for: .normal)
                }
                
                return
            }
            
            // No error, show shapes
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                shapeList?.forEach { shape in
                    UIView.transition(with: self!.view, duration: 0.5, options: .transitionCrossDissolve, animations: {
                        self?.view.layer.addSublayer(shape)
                    }, completion: nil)
                }
                
                
                self?.btnSend.isEnabled = true
                
                self?.btnSend.layer.backgroundColor = UIColor.orange.cgColor
                self?.btnSend.setTitle("Tekrar Gönder", for: .normal)
            })
            
        }
    }

}

// MARK: UITextField Delegate
extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.txtEmail {
            self.txtName.becomeFirstResponder()
        }
        else if textField == self.txtName {
            self.txtGSM.becomeFirstResponder()
        }
        return true
    }
}

// MARK: ShakeMotion
extension ViewController {
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            self.view.layer.sublayers?.forEach { layer in
                if layer is Shape {
                    layer.removeFromSuperlayer()
                }
            }
        }
    }
}

