//
//  CrearUsuarioViewController.swift
//  GonzaloSnapchat
//
//  Created by Gonzalo Vargas on 9/06/23.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class CrearUsuarioViewController: UIViewController {
    
    @IBOutlet weak var lblUsuario: UITextField!
    @IBOutlet weak var lblContraseña: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btnRegistro(_ sender: Any) {
        Auth.auth().createUser(withEmail: self.lblUsuario.text!, password: self.lblContraseña.text!, completion: {(user, error) in
            print("Intentando crear un nuevo usuario")
            if error != nil {
                print("Se presento un error al crear un nuevo usuario \(error)")
            }else{
                print("Se ha registrado un nuevo usuario")
                Database.database().reference().child("usuarios")
                    .child(user!.user.uid).child("email")
                    .setValue(user!.user.email)
                
                let alertaCreacion = UIAlertController(title: "¡Bienvenido!✅", message: "Tu registro ha sido completado con exito 🤗", preferredStyle: .alert)
                
                let aceptarAction = UIAlertAction(title: "Aceptar", style: .default) {(action) in
                    self.dismiss(animated: true, completion: nil)
                }
                
                alertaCreacion.addAction(aceptarAction)
                
                self.present(alertaCreacion, animated: true, completion: nil)
            }
        })
    }
}
