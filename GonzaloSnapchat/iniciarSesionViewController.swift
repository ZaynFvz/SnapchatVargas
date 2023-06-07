//
//  ViewController.swift
//  GonzaloSnapchat
//
//  Created by Gonzalo Vargas on 7/06/23.
//

import UIKit
import FirebaseAuth

class iniciarSesionViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func iniciarSesionTapped(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password:
        passwordTextField.text!) { (user, error) in
        print("Intentando iniciar sesión")
        if error != nil{
            print("Se presento el siguiente error: \(error)")
        }else{
            print("Inicio de sesión exitoso")
        }
        }
    }
}
