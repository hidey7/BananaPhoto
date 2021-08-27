//
//  ViewController.swift
//  BananaPhoto
//
//  Created by 始関秀弥 on 2021/08/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startButton.layer.cornerRadius = startButton.frame.size.height / 2
        
        navigationController?.isNavigationBarHidden = true
        
        
    }

    @IBAction func next(_ sender: Any) {
        performSegue(withIdentifier: "next", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "next" {
            
        }
        
    }
    
}

