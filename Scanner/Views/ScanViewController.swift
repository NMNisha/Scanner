//
//  ScanViewController.swift
//  Scanner
//
//  Created by Nishanthini on 02/03/18.
//  Copyright © 2018 Nishanthini. All rights reserved.
//

import UIKit
import AVFoundation

class ScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, AVCapturePhotoCaptureDelegate, XMLParserDelegate {

    @IBOutlet weak var previewView: UIView!
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var capturePhotoOutput: AVCapturePhotoOutput?
    var qrCodeFrameView: UIView?
    var qrError = String()
    
    var panName : String?
    var panFatherName : String?
    var panDOB : String?
    var panID : String?
    
    let supportdCodeTyes = [AVMetadataObject.ObjectType.upce,
                            AVMetadataObject.ObjectType.code39,
                            AVMetadataObject.ObjectType.code39Mod43,
                            AVMetadataObject.ObjectType.code93,
                            AVMetadataObject.ObjectType.code128,
                            AVMetadataObject.ObjectType.ean8,
                            AVMetadataObject.ObjectType.ean13,
                            AVMetadataObject.ObjectType.aztec,
                            AVMetadataObject.ObjectType.pdf417,
                            AVMetadataObject.ObjectType.qr]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
       
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportdCodeTyes
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            captureSession?.startRunning()
            
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                previewView.addSubview(qrCodeFrameView)
                view.addSubview(qrCodeFrameView)
    
                view.bringSubview(toFront: qrCodeFrameView)
            }
            
            
        } catch {
            print(error)
            alertView(alertTitle: "Scanning not supported", alertMessage: error.localizedDescription)
            return
        }
        captureSession?.startRunning()
}
    override var prefersStatusBarHidden: Bool {
        return true
    }
    func alertView(alertTitle: String, alertMessage: String) {
        let alertVC = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
}

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if captureSession?.isRunning == false {
            captureSession?.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if captureSession?.isRunning == true {
            captureSession?.stopRunning()
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession?.stopRunning()
        if metadataObjects == nil || metadataObjects.count == 0 {
            self.qrCodeFrameView?.frame = CGRect.zero
            return
        }
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportdCodeTyes.contains(metadataObj.type) {
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                print(metadataObj.stringValue!)
                //showActivityIndicator
                IJProgressView.shared.showProgressView(view)
                foundOutput(output: metadataObj.stringValue!)
            }
        }
    }
    func foundOutput(output: String) {
        print(output)
        if let data = output.data(using: .utf8) {
            do{
                    let xmlData = data
                    let parser = XMLParser(data: xmlData)
                    parser.delegate = self
                    parser.parse()
            }
            catch{
                print(error)
                return
            }
            
        }
    }
  func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {

        print(parseError.localizedDescription)
    qrError = parseError.localizedDescription
   IJProgressView.shared.hideProgressView()
    let alertVC = UIAlertController(title: "Alert!", message: "Please Scan Valid PAN QRCode", preferredStyle: .alert)
    alertVC.addAction(UIAlertAction(title: "Scan Again", style: .default, handler: { (action) in
        print("Scan QR again")
        self.captureSession?.startRunning()
    }))
    alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
        self.performSegue(withIdentifier: "toHome", sender: nil)
    }))
    self.present(alertVC, animated: true, completion: nil)
    
    }
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if attributeDict.isEmpty == false {
        print(attributeDict)
            //Values from the parsed sample pan qr. The Keys may differ for original Pan Card QR
            panName = attributeDict["name"]
            panFatherName = attributeDict["fathername"]
            panDOB = attributeDict["dob"]
            panID = attributeDict["id"]
            
        self.performSegue(withIdentifier: "toForm", sender: nil)
           IJProgressView.shared.hideProgressView()
        }
        else{
            print(parser.parserError?.localizedDescription)
           IJProgressView.shared.hideProgressView()
            let alertVC = UIAlertController(title: "Alert!", message: qrError, preferredStyle: .alert)
                    alertVC.addAction(UIAlertAction(title: "Scan Again", style: .default, handler: { (action) in
                        print("Scan QR again")
                        self.captureSession?.startRunning()
                    }))
                    alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                        self.performSegue(withIdentifier: "toHome", sender: nil)
                    }))
                    self.present(alertVC, animated: true, completion: nil)
            
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toForm" {
            self.navigationController?.navigationBar.isHidden = false
            
            
            let destVC = segue.destination as! ViewController
            destVC.userName = panName
            destVC.userFatherName = panFatherName
            destVC.userDOB = panDOB
            destVC.userPAN = panID
            
        } else {
            let destVC = segue.destination as! HomeViewController
           
        }
    }

}
    
    
    
