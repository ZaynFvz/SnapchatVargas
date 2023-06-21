//
//  VerSnapViewController.swift
//  GonzaloSnapchat
//
//  Created by Gonzalo Vargas on 14/06/23.
//

import UIKit
import SDWebImage
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import AVFoundation

class VerSnapViewController: UIViewController {
    
    var escucharaudio: AVPlayer?
    var snap = Snap()
    
    @IBOutlet weak var lblMensaje: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lblmensajeVoz: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblMensaje.text = "Mensaje: " + snap.descrip
        imageView.sd_setImage(with: URL(string: snap.imagenURL), completed: nil)
        lblmensajeVoz.text = "Nota: " + snap.descripaudio
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("snaps").child(snap.id).removeValue()
               
        Storage.storage().reference().child("imagenes").child("\(snap.imagenID).jpg").delete(completion: {(error) in
            print("Se elimino la imagen correctamente")
        })
                
        Storage.storage().reference().child("audios").child("\(snap.audioID).m4a").delete(completion: {(error) in
            print("Se eliminó el audio correctamente")
        })
    }
    
    @IBAction func reproducirAudio(_ sender: Any) {
        guard let audioURL = URL(string: snap.audioURL)else{
            return
        }
        escucharaudio = AVPlayer(url: audioURL)
        escucharaudio?.play()
    }
}
