//
//  SecondViewController.swift
//  Skin_cancer
//
//  Created by Vivek D on 26/03/2021.
//

import UIKit

class SecondViewController: UIViewController {
    
    var oneview : ViewController!
    
    @IBOutlet weak var prediction: UILabel!

    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var prob: UILabel!
    var predtext = String()
    var probtext = String()
    var temp = String()
    var info = String()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prediction.text = predtext
        desc.text = info
        temp = probtext.replacingOccurrences(of: "{", with: "")
        temp = temp.replacingOccurrences(of: "}", with: "")
        temp = temp.replacingOccurrences(of: "'", with: "")
        prob.text = temp.replacingOccurrences(of: ",", with: "\n")
        

    }
    

    



}
