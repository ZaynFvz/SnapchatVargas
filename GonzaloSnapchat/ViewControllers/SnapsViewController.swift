//
//  SnapsViewController.swift
//  GonzaloSnapchat
//
//  Created by Gonzalo Vargas on 7/06/23.
//

import UIKit

class SnapsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cerrarSesionTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
