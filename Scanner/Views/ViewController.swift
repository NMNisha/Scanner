//
//  ViewController.swift
//  Scanner
//
//  Created by Nishanthini on 01/03/18.
//  Copyright © 2018 Nishanthini. All rights reserved.
//
import UIKit
import CoreData

class ViewController: UIViewController {
    
    
    @IBOutlet weak var panTf: UITextField!
    
    
    @IBOutlet weak var nameTf: UITextField!
    
    @IBOutlet weak var fathernameTf: UITextField!
    
    @IBOutlet weak var dobTf: UITextField!
    
    var userName : String?
    var userFatherName : String?
    var userDOB : String?
    var userPAN : String?
    
    @IBAction func submitClicked(_ sender: Any) {

        if userName != "" && userFatherName != "" && userDOB != "" && userPAN != ""{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.insertNewObject(forEntityName: "User", into: managedContext)

        entity.setValue(userName, forKey: "name")
        entity.setValue(userFatherName, forKey: "fatherName")
        entity.setValue(userDOB, forKey: "dOB")
        entity.setValue(userPAN, forKey: "pAN")

        do {
            try managedContext.save()
            print("Data Saved")
            DispatchQueue.main.async {

                self.alertView(alertTitle: "Success", alertMessage: "PAN Details saved successfully")
                
            }
            
        } catch {
            print("Error")
              DispatchQueue.main.async {
                self.alertView(alertTitle: "Error", alertMessage: "PAN Details not Valid")
        }
            }
        }
        else{
            DispatchQueue.main.async {
                self.alertView(alertTitle: "Error", alertMessage: "Mandatory Fields Empty")
            }
        }
        self.navigationController?.popToRootViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       //fillText()
      print("View Did load")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fillText()
    }
    func fillText(){
        DispatchQueue.main.async(execute: {

        self.nameTf.text = self.userName
        self.fathernameTf.text = self.userFatherName
        self.dobTf.text = self.userDOB
        self.panTf.text = self.userPAN
        })
    }
        


    
    func alertView(alertTitle: String, alertMessage: String) {
        let alertVC = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }

}

