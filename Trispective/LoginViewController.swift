//
//  ViewController.swift
//  Trispective
//
//  Created by USER on 2017/3/24.
//  Copyright © 2017年 Trispective. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet private weak var userAccount: UITextField!
    @IBOutlet private weak var password: UITextField!
    @IBOutlet private weak var coverView: UIView!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var forgetPasswordButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var alreadyHaveAccountButton: UIButton!
    
    private var state="login"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.setTitleColor(UIColor.gray, for: .highlighted)
        forgetPasswordButton.setTitleColor(UIColor.gray, for: .highlighted)
        createAccountButton.setTitleColor(UIColor.gray, for: .highlighted)
        
        let tap: UITapGestureRecognizer=UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func SwitchToLogin(_ sender: UIButton) {
        alreadyHaveAccountButton.isHidden=true;
        forgetPasswordButton.isHidden=false;
        createAccountButton.isHidden=false;
        loginButton.setTitle("Sign in", for: .normal)
        
        state="login"
    }
    
    @IBAction private func forgetPassword(_ sender: UIButton) {
        let alertSheet=UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertSheet.addAction(UIAlertAction(title: "Reset PassWord", style: .default){ _ in
            
        })
        
        alertSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel){ _ in
            
        })
        
        self.present(alertSheet,animated: true)
    }
    
    @IBAction private func createAccount(_ sender: UIButton) {
        alreadyHaveAccountButton.isHidden=false;
        forgetPasswordButton.isHidden=true;
        createAccountButton.isHidden=true;
        loginButton.setTitle("Register", for: .normal)
        
        state="register"
    }
    
    @IBAction private func login(_ sender: UIButton) {
        let loginName = userAccount.text!
        let userPassword = password.text!
        
        if state.contains("login"){
            if loginName=="customer" && userPassword=="customer"{
                performSegue(withIdentifier: "showSpot", sender: sender)
            }else if loginName=="restaurant" && userPassword=="restaurant"{
                performSegue(withIdentifier: "showRestaurant", sender: sender)
            }else{
                createAlert(title: "Sign in Failed!", message: "User account or password is incorrect!")
                return
            }
        }else if state.contains("register"){
            if loginName.isEmpty || (userPassword.isEmpty) {
                createAlert(title: "Register Failed!", message: "User account or password is empty!")
                return
            }
        }
    }
    
    private func createAlert(title:String,message:String){
        let alert = UIAlertController(title: title, message:message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
        })
        
        self.present(alert, animated: true)
    }

    func dismissKeyboard(){
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.dismissKeyboard()
        return false
    }


}

