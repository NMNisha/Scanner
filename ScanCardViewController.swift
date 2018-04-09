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

    var panName : String?
    var panFatherName : String?
    var panDOB : String?
    var panID : String?
    var picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        picker = UIImagePickerController()
//        picker.delegate = self
//        picker.sourceType = .camera
//        picker.cameraCaptureMode = .photo
//        present(picker, animated: true)
        callOCR(image: UIImage(named: "pics1")!)
    }
    var inputImage : UIImage!
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        guard let uiImage = info[UIImagePickerControllerOriginalImage] as? UIImage
//            else { fatalError("no image from image picker") }
//
//       // inputImage = uiImage
//
//   // callOCR(image: inputImage)
//
//           DispatchQueue.main.async(execute: {
//            IJProgressView.shared.showProgressView(self.view)
//           })
//       picker.dismiss(animated: true, completion: nil)
//
//}
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "toViewController" {
            let destVC = segue.destination as! ViewController
            destVC.userName = "\(panName!)"
            destVC.userFatherName = "\(panFatherName!)"
            destVC.userDOB = "\(panDOB!)"
            destVC.userPAN = "\(panID!)"
        }
        else {
            let destVC = segue.destination as! HomeViewController
        }
        
}
    func createBodyWithBoundary(boundary: String, parameters: [String : String], imageData data: Data, filename: String) -> Data {
        let body:NSMutableData = NSMutableData()
        
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition: form-data; name=\"\("file")\"; filename=\"\(filename)\"\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using:String.Encoding.utf8)!)
        body.append(data)
        body.append("\r\n".data(using: String.Encoding.utf8)!)
        
        
        for key in parameters.keys {
            body.append("--\(boundary)\r\n".data(using:String.Encoding.utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using:String.Encoding.utf8)!)
            body.append("\(parameters[key])\r\n".data(using:String.Encoding.utf8)!)
        }
        
        body.append("--\(boundary)--\r\n".data(using:String.Encoding.utf8)!)
        
        return body as Data
    }
    func imageWithImage(image:UIImage, newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0);
        image.draw(in: CGRect(origin: CGPoint.zero, size: CGSize(width: newSize.width, height: newSize.height)))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    func callOCR(image:UIImage) {
        
        let baseURL = URL(string: "https://api.ocr.space/parse/image")
        let ocrSpaceKey = "932feaccb588957"
        let session = URLSession.shared
        var request = URLRequest(url:baseURL!)
        request.httpMethod = "POST"
        
        let name = "ttt.jpg"
        var parsedInfo: [String] = []
        
        let boundary: String = "randomString"
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var image2:UIImage! = image
        
        if (image2.size.width > 2590 || image2.size.height > 2590) {
            let maxDimension = [image2.size.width,image2.size.height].max()
            let factor = maxDimension! / 2590
            let newWidth = ceil((image2.size.width/factor))
            let newHeight = ceil((image2.size.height/factor))
            let newSize = CGSize(width: newWidth, height: newHeight)
            image2 = imageWithImage(image: image2, newSize:newSize)
        }
        
        let imageData: Data = UIImageJPEGRepresentation(image2, 0.25)!
        
        let parametersDictionary:[String:String] = ["apikey": ocrSpaceKey]
        
        let data: Data = createBodyWithBoundary(boundary: boundary, parameters: parametersDictionary, imageData: imageData, filename: name)
        print(data)
        request.httpBody = data
        
        print(request.allHTTPHeaderFields)
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
           // print(data)
           // print(response)
           // print(error)
        
            guard (error == nil) else {
                DispatchQueue.main.async {
                    IJProgressView.shared.hideProgressView()
                    print("There was an error with your request: \(error)")
                    let alertVC = UIAlertController(title: "Alert!", message: "Error! Please Try Again!", preferredStyle: .alert)
                    alertVC.addAction(UIAlertAction(title: "Scan Again", style: .default, handler: { (action) in
                        
                        self.performSegue(withIdentifier: "toScan", sender: nil)
                    }))
                    alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                        self.performSegue(withIdentifier: "toHomeView", sender: nil)
                    }))
                    self.present(alertVC, animated: true, completion: nil)
                }
                return
                
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                DispatchQueue.main.async {
                    IJProgressView.shared.hideProgressView()
                    print("Your request returned a status code other than 2xx!")
                    let alertVC = UIAlertController(title: "Alert!", message: "Error! Please Try Again!", preferredStyle: .alert)
                    alertVC.addAction(UIAlertAction(title: "Scan Again", style: .default, handler: { (action) in
                        
                        self.performSegue(withIdentifier: "toScan", sender: nil)
                    }))
                    alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                        self.performSegue(withIdentifier: "toHomeView", sender: nil)
                    }))
                    self.present(alertVC, animated: true, completion: nil)
                    // if image has no text, this is the response
                }
                return
                
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    IJProgressView.shared.hideProgressView()
                    print("No data was returned by the request!")
                    let alertVC = UIAlertController(title: "Alert!", message: "Error! Scan Valid Card", preferredStyle: .alert)
                    alertVC.addAction(UIAlertAction(title: "Scan Again", style: .default, handler: { (action) in
                        
                        self.performSegue(withIdentifier: "toScan", sender: nil)
                    }))
                    alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                        self.performSegue(withIdentifier: "toHomeView", sender: nil)
                    }))
                    self.present(alertVC, animated: true, completion: nil)
                }
                return
                
            }
            let parsedResult: [String:AnyObject]
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
            } catch {
                print("Could not parse the data as JSON: '\(data)'")
                DispatchQueue.main.async {
                    IJProgressView.shared.hideProgressView()
                    let alertVC = UIAlertController(title: "Alert!", message: "Error! Scan Valid Card", preferredStyle: .alert)
                    alertVC.addAction(UIAlertAction(title: "Scan Again", style: .default, handler: { (action) in
                        
                        self.performSegue(withIdentifier: "toScan", sender: nil)
                    }))
                    alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                        self.performSegue(withIdentifier: "toHomeView", sender: nil)
                    }))
                    self.present(alertVC, animated: true, completion: nil)
                    
                }
                return
            }
            print(parsedResult)
            let exitCode = parsedResult["OCRExitCode"] as! Int
            
            if exitCode != 1 {
                return
            }
            let parsedResults = parsedResult["ParsedResults"]! as! [[String:AnyObject]]
            let parsedText = parsedResults[0]["ParsedText"] as! String
            print(parsedText)
            parsedInfo = [parsedText.filter { !"\n".contains($0) }] // parsedText.components(separatedBy: "\n")
            
            print(parsedInfo)
            parsedInfo = (parsedInfo.first?.components(separatedBy: " \r\n"))!
            print(parsedInfo)
//            var i: Int = 0
//            print(parsedInfo.count)
//            for index in 0 ..< parsedInfo.count where parsedInfo.indices.contains(index) {
//                print(index)
//                print(parsedInfo[index])
//                print(parsedInfo[index].characters.count)
//                let noSpace = parsedInfo[index].replacingOccurrences(of: " ", with: "")
//                print(noSpace.characters.count)
//                print(noSpace)
//                if noSpace.hasPrefix("IN")  || noSpace.hasSuffix("MENT ") {
//                    print(index)
//                   i = index
//                    self.panName = parsedInfo[i+1]
//
//                    self.panFatherName = parsedInfo[i+2]
//
//                    self.panDOB = parsedInfo[i+3]
//
//                    self.panID = parsedInfo[i+5]
//                    i = i+5
//                } else {
//                    print("No Prefix IN")
//                }
//            }
//            if i == 0{
//                DispatchQueue.main.async {
//
//                    IJProgressView.shared.hideProgressView()
//                    let alertVC = UIAlertController(title: "Alert!", message: "Please Scan Valid PAN Card", preferredStyle: .alert)
//                    alertVC.addAction(UIAlertAction(title: "Scan Again", style: .default, handler: { (action) in
//
//                        self.performSegue(withIdentifier: "toScan", sender: nil)
//                    }))
//                    alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
//                        self.performSegue(withIdentifier: "toHomeView", sender: nil)
//                    }))
//                    self.present(alertVC, animated: true, completion: nil)
//                }
//            }
//
//            print("success OCR.space")
//
//            if self.panName != nil && self.panName != nil && self.panName != nil && self.panName != nil{
//                print(self.panName!)
//                print(self.panFatherName!)
//                print(self.panDOB!)
//                print(self.panID!)
//                DispatchQueue.main.async(execute: {
//
//                    self.performSegue(withIdentifier: "toViewController", sender: nil)
//                })
//            }
//            else {
//                DispatchQueue.main.async(execute: {
//                    IJProgressView.shared.hideProgressView()
//                    let alertVC = UIAlertController(title: "Alert!", message: "Please Scan Valid PAN Card", preferredStyle: .alert)
//                    alertVC.addAction(UIAlertAction(title: "Scan Again", style: .default, handler: { (action) in
//                        self.present(self.picker, animated: true)
//                    }))
//                    alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
//                        self.performSegue(withIdentifier: "toHomeView", sender: nil)
//                    }))
//                    self.present(alertVC, animated: true, completion: nil)
//                })
//            }
        })
        task.resume()
        
        
    }

}
