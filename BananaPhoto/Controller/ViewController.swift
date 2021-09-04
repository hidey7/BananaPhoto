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
        
        gradation(view)
        
        overrideUserInterfaceStyle = .light
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
    }

    @IBAction func next(_ sender: Any) {
        performSegue(withIdentifier: "next", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "next" {
            
        }
        
    }
    
    
    func gradation(_ view: UIView) {
        
        //グラデーションの開始色
        let topColor = UIColor(red:255/255, green:255/255, blue:0/255, alpha:1)
        //グラデーションの終了色
        let bottomColor = UIColor(red:255/255, green:235/255, blue:205/255, alpha:1)

        //グラデーションの色を配列で管理
        let gradientColors: [CGColor] = [topColor.cgColor, bottomColor.cgColor]

        //グラデーションレイヤーを作成
        let gradientLayer: CAGradientLayer = CAGradientLayer()

        //グラデーションの色をレイヤーに割り当てる
        gradientLayer.colors = gradientColors
        //グラデーションレイヤーをスクリーンサイズにする
        gradientLayer.frame = view.bounds

        //グラデーションレイヤーをビューの一番下に配置
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
}

