//
//  ImagenViewControllerViewController.swift
//  GonzaloSnapchat
//
//  Created by Gonzalo Vargas on 7/06/23.
//

import UIKit
import FirebaseStorage
import AVFoundation

class ImagenViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imagePicker = UIImagePickerController()
    var imagenID = NSUUID().uuidString
    var imagenURL = ""
    
    var audioURL:URL?
    var audioURLString = ""
    var grabar: AVAudioRecorder?
    var reproducir: AVAudioPlayer?
    var audioID = NSUUID().uuidString
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descripcionTextField: UITextField!
    @IBOutlet weak var elegirContactoBoton: UIButton!
    @IBOutlet weak var btnGrabar: UIButton!
    @IBOutlet weak var btnReproducir: UIButton!
    @IBOutlet weak var txtMensajeAudio: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        elegirContactoBoton.isEnabled = false
        Grabacion()
    }
    
    @IBAction func camaraTapped(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func elegirContactoTapped(_ sender: Any) {
        self.elegirContactoBoton.isEnabled = false
        let imagenesFolder = Storage.storage().reference().child("imagenes")
        let imagenData = imageView.image?.jpegData(compressionQuality: 0.50)
        let cargarImagen = imagenesFolder.child("\(imagenID).jpg")
        
        let audiosFolder = Storage.storage().reference().child("audios")
        let audioData = try? Data(contentsOf: self.audioURL!)
        let uploadAudio = audiosFolder.child("\(audioID).m4a")
        
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        
        cargarImagen.putData(imagenData!, metadata: nil) { (metadata, error) in
            if error != nil {
                self.mostrarAlerta(titulo: "Error", mensaje: "Se produjo un error al subir la imagen. Verifique su conexion a internet y vuelva a intentarlo", accion: "Aceptar")
                self.elegirContactoBoton.isEnabled = true
                print("Ocurrió un error al subir imagen \(error)")
                return
            }else{
                cargarImagen.downloadURL(completion: {(url, error) in
                if let url = url{
                    self.imagenURL = url.absoluteString
                        print("URL de la imagen subida: \(self.imagenURL)")
                }else{
                    print("Ocurrió un error al obtener la url de la imagen subida: \(error)")
                    self.mostrarAlerta(titulo: "Error", mensaje: "Se produjo un error al obtener la informacion de la imagen", accion: "Cancelar")
                    self.elegirContactoBoton.isEnabled = true
                }
                dispatchGroup.leave()
                })
            }
        }
        dispatchGroup.enter()
        uploadAudio.putData(audioData!, metadata: nil) { (metadata, error) in
            if let error = error {
                print("Ocurrió un error al subir el audio: \(error)")
                self.mostrarAlerta(titulo: "ERROR", mensaje: "Ocurrió un error al subir el audio", accion: "Aceptar")
                self.elegirContactoBoton.isEnabled = true
            } else {
                uploadAudio.downloadURL { (url, error) in
                    if let url = url {
                        self.audioURLString = url.absoluteString
                        print("Audio subido correctamente: \(self.audioURLString)")
                    } else {
                        print("Ocurrió un error al obtener la URL del audio: \(error)")
                    }
                    
                    dispatchGroup.leave()
                }
            }
        }

        dispatchGroup.notify(queue: .main){
            let recibirURL:[String:Any] = ["URLImagen":self.imagenURL, "URLAudio":self.audioURLString]
            print(recibirURL)
            self.performSegue(withIdentifier: "seleccionarContactoSegue", sender: recibirURL)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imageView.image = image
        imageView.backgroundColor = UIColor.clear
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func mostrarAlerta(titulo:String, mensaje:String, accion:String) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        let btnCANCELOK = UIAlertAction(title: accion, style: .default, handler: nil)
        alerta.addAction(btnCANCELOK)
        present(alerta, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let senderDict = sender as? [String: Any]{
            let siguienteVC = segue.destination as! ElegirUsuarioViewController
            siguienteVC.imagenURL = senderDict["URLImagen"] as? String ?? ""
            siguienteVC.audioURL = senderDict["URLAudio"] as? String ?? ""
                    
            siguienteVC.descrip = descripcionTextField.text!
            siguienteVC.imagenID = imagenID
                    
            siguienteVC.audioID = audioID
            siguienteVC.descripaudio = txtMensajeAudio.text!
        }
    }
    
    @IBAction func GrabarAudio(_ sender: Any) {
        if grabar!.isRecording{
            grabar?.stop()
            btnGrabar.setTitle("GRABAR", for: .normal)
            btnReproducir.isEnabled = true
            elegirContactoBoton.isEnabled = true
        }else{
            grabar?.record()
            btnGrabar.setTitle("DETENER", for: .normal)
            btnReproducir.isEnabled = false
        }
    }
    
    @IBAction func ReproducirAudio(_ sender: Any) {
        do{
            try reproducir = AVAudioPlayer(contentsOf: audioURL!)
            reproducir!.play()
            print("Reproduciendo")
        }catch{}
    }
    
    func Grabacion(){
        do{
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSession.Category.playAndRecord, mode:AVAudioSession.Mode.default, options: [])
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true)


            let basePath:String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask,true).first!
            let pathComponents = [basePath,"audio.m4a"]
            audioURL = NSURL.fileURL(withPathComponents: pathComponents)!


            print("*****************")
            print(audioURL!)
            print("*****************")


            var settings:[String:AnyObject] = [:]
            settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC) as AnyObject?
            settings[AVSampleRateKey] = 44100.0 as AnyObject?
            settings[AVNumberOfChannelsKey] = 2 as AnyObject?


            grabar = try AVAudioRecorder(url:audioURL!, settings: settings)
            grabar!.prepareToRecord()
        }catch let error as NSError{
            print(error)
        }
    }
}
