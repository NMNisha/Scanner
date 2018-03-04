//
//  ScanCardViewController.swift
//  Scanner
//
//  Created by Nishanthini on 03/03/18.
//  Copyright © 2018 Nishanthini. All rights reserved.
//
import Foundation
import UIKit
import CoreML
import Vision
import ImageIO
import CoreGraphics

class ScanCardViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
//    var panData : [String] = []
//    var name : String?
//    var fatherName : String?
//    var dOB : String?
//    var pAN : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        picker.cameraCaptureMode = .photo
        present(picker, animated: true)
        
    }
    var inputImage : UIImage!
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
       IJProgressView.shared.showProgressView(view)
        guard let uiImage = info[UIImagePickerControllerOriginalImage] as? UIImage
            else { fatalError("no image from image picker") }
        
        inputImage = uiImage
        
        // Show the image in the UI.
     
        performSegue(withIdentifier: "toOCR", sender: self)
        IJProgressView.shared.hideProgressView()
         picker.dismiss(animated: true)
}
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toOCR" {
            let destVC = segue.destination as! OCRParserViewController
            destVC.image = inputImage
        }
}
   

}
