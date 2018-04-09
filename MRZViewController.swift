//
//  MRZViewController.swift
//  Scanner
//
//  Created by Nishanthini on 09/04/18.
//  Copyright © 2018 Nishanthini. All rights reserved.
//

import UIKit

protocol ProcessMRZ {
    func processMRZ(mrz: MRZ)
}


class MRZViewController: UIViewController {
        
        /// Delegate set by the calling controler so that we can pass on ProcessMRZ events.
        var delegate: ProcessMRZ?
        
        // the .StartScan and .EndScan are IBOutlets and can be linked to your own buttons
        
        /**
         For now just start scanning the moment this view is loaded
         */
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            self.debug = true // So that we can see what's going on (scan text and quality indicator)
            self.accuracy = 1  // 1 = all checksums should pass (is the default so we could skip this line)
            self.StartScan(sender: self)
        }
        
        /**
         Called by the PassportScannerController when there was a succesfull scan
         
         :param: mrz The scanned MRZ
         */
        override func succesfullScan(mrz: MRZ) {
            print("mrz: {\(mrz.description)\n}")
            delegate?.processMRZ(mrz: mrz)
            self.dismiss(animated: true, completion: nil)
        }
        
        /**
         Called by the PassportScannerController when the 'close' button was pressed.
         */
        override func abbortScan() {
            self.dismiss(animated: true, completion: nil)
        }
        
}
