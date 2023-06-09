//
//  ViewController.swift
//  GonzaloSnapchat
//
//  Created by Gonzalo Vargas on 7/06/23.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

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
            let alertController = UIAlertController(title: "⛔ Ups! Ha ocurrido un error", message: "Parece que estas intentando acceder con un usuario no registrado 😳", preferredStyle: .alert)
            
            let crearusuario = UIAlertAction(title: "Registrarme", style: .default){(action) in
                self.performSegue(withIdentifier: "crearUsuariosegue", sender: nil)
            }
            
            let cancelarAlerta = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
            
            alertController.addAction(cancelarAlerta)
            alertController.addAction(crearusuario)
            
            self.present(alertController, animated: true, completion: nil)
            
            print("Se presento un error: \(error)")
            
        }else{
            print("Inicio de sesión exitoso")
            self.performSegue(withIdentifier: "iniciarsesionsegue", sender: nil)
        }
        }
    }
    
}
