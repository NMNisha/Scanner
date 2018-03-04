//
//  ViewController.swift
//  Scanner
//
//  Created by Nishanthini on 01/03/18.
//  Copyright © 2018 Nishanthini. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

   
    @IBOutlet weak var tableView: UITableView!
    
    
    var userName : String?
    var userFatherName : String?
    var userDOB : String?
    var userPAN : String?
    
    var infoArray = [String]()
    
    
    
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
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       fillText()
      
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func fillText(){
         DispatchQueue.main.async {
            
            self.tableView.register(TableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.infoArray.append(self.userName!)
        self.infoArray.append(self.userFatherName!)
        self.infoArray.append(self.userDOB!)
        self.infoArray.append(self.userPAN!)
        print(self.infoArray)
            self.tableView.reloadData()
        }
       
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
       
        tableView.isScrollEnabled = false

        print(infoArray[indexPath.row])
        cell.infoLabel?.layer.cornerRadius = 10
        cell.infoLabel?.layer.borderColor = UIColor.black.cgColor
        cell.infoLabel?.layer.borderWidth = 2
        cell.infoLabel?.layer.shadowRadius = 2
        cell.infoLabel?.layer.shadowColor = UIColor.lightGray.cgColor
        cell.infoLabel?.layer.shadowOpacity = 2
        cell.infoLabel?.layer.shadowOffset = CGSize(width: -2, height: 2)
        cell.infoLabel?.text = infoArray[indexPath.row]
        cell.infoLabel?.text = "Success"
        return cell
    }
    
    func alertView(alertTitle: String, alertMessage: String) {
        let alertVC = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }

}

