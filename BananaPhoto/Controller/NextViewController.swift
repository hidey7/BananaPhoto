//
//  NextViewController.swift
//  BananaPhoto
//
//  Created by 始関秀弥 on 2021/08/21.
//

import UIKit
import Photos
import PhotosUI


class NextViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var selectButton: UIButton!
    
    @IBOutlet weak var bananaButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = UIImage(named: "mostbanana")
        
        selectButton.layer.cornerRadius = selectButton.frame.size.height / 2
        
        bananaButton.layer.cornerRadius = bananaButton.frame.size.height / 2
        
        gradation(view)
        
        overrideUserInterfaceStyle = .light
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
        
    }
    
    
    
    func selectPhotos(){
        
        // カメラロール設定
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1 // 選択数
        configuration.filter = .images // 写真のみ
        configuration.preferredAssetRepresentationMode = .current // これがないとJPEGが選択できなかった
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
        
    }
    
    
    @IBAction func selectButtonTapped(_ sender: Any) {
        
        
        selectPhotos()
        
    }
    
    @IBAction func bananaButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "select", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "select" {
            let nextVC = segue.destination as! PhotoViewController
            nextVC.photo = imageView.image!
        }
    }
    
    
    func openImagePickerView(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // モーダルビュー（つまり、イメージピッカー）を閉じる
        dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            //ボタンの背景に選択した画像を設定
            imageView.image = image
        } else{
            print("Error")
        }
    }
    
    //画像選択がキャンセルされた時に呼ばれる.
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        // モーダルビューを閉じる
        dismiss(animated: true, completion: nil)
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
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}



extension NextViewController: PHPickerViewControllerDelegate {
    
    
    // カメラロール表示
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        
        
        
        results.forEach { result in
            result.itemProvider.loadDataRepresentation(forTypeIdentifier: "public.image", completionHandler: { [weak self] data, _ in
                guard let data = data else { return }
                DispatchQueue.main.sync {
                    self?.imageView.image = UIImage(data: data)
                }
                
            })
        }
        
        
        
        picker.dismiss(animated: true) // カメラロールを閉じる
    }
    
    
    
    
    
}


