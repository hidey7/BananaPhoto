//
//  NewNextViewController.swift
//  BananaPhoto
//
//  Created by 始関秀弥 on 2022/02/04.
//

import UIKit
import Photos

@available(iOS 15.0, *)
class NewNextViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var editButtonsContainerView: UIView!
    
    @IBOutlet weak var notificationView: UIView!
    @IBOutlet weak var noimageLabel: UILabel!
    
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    //画像表示用のimageView
    var imageviewOfselectedImageView = UIImageView()
    //選択されたimage用のUIImage
    var image = UIImage()
    
    
    @IBOutlet weak var bananaButton: UIButton!
    @IBOutlet weak var grapeButton: UIButton!
    @IBOutlet weak var appleButton: UIButton!
    
    
    var prevPinch:CGFloat = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noimageLabel.adjustsFontSizeToFitWidth = true
        checkIsimageSelected()
        
        overrideUserInterfaceStyle = .light
        setupNavigationbar()
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        adjustButtonImage(button: bananaButton)
        adjustButtonImage(button: grapeButton)
        adjustButtonImage(button: appleButton)
    }
    
    func adjustButtonImage(button: UIButton) {
        button.imageView?.contentMode = .scaleAspectFill
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
    }
    
    
    func setupNavigationbar() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 238/255, green: 243/255, blue: 56/255, alpha: 1.0)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "photo"), landscapeImagePhone: UIImage(systemName: "photo"), style: .plain, target: self, action: #selector(showPhotoLibrary))
    }
    
    
    @objc func showPhotoLibrary(){
        let sourceType:UIImagePickerController.SourceType = .photoLibrary
        
        //カメラ利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            
            let cameraPicker = UIImagePickerController()
            cameraPicker.allowsEditing = false
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            cameraPicker.modalPresentationStyle = .fullScreen
            self.present(cameraPicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // モーダルビュー（つまり、イメージピッカー）を閉じる
        dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            //ボタンの背景に選択した画像を設定
            imageviewOfselectedImageView.image = image
            resizeSelectedImage(image: image)
            
            var subViews = imageviewOfselectedImageView.subviews
            for subView in subViews {
                subView.removeFromSuperview()
            }
            
        } else{
            print("Error")
        }
        
        checkIsimageSelected()
    }
    
    func resizeSelectedImage(image: UIImage){
        let screenWidth:CGFloat = imageContainerView.frame.size.width
        let screenHeight:CGFloat = imageContainerView.frame.size.height
        let imgWidth:CGFloat = image.size.width
        let imgHeight:CGFloat = image.size.height
        
        let widthScale:CGFloat = screenWidth / imgWidth
        let heightScale: CGFloat = screenHeight / imgHeight * 0.9
        
        
        var rect = CGRect()
        if imgWidth >= imgHeight {
            rect = CGRect(x:0, y:0, width:imgWidth*widthScale, height:imgHeight*widthScale)  //横長
        }else{
            rect = CGRect(x:0, y:0, width:imgWidth*heightScale, height:imgHeight*heightScale)  //縦長
        }
        
        
        imageviewOfselectedImageView.frame = rect
        
        imageviewOfselectedImageView.center = CGPoint(x:screenWidth/2, y:screenHeight/2)
        
        imageContainerView.addSubview(imageviewOfselectedImageView)
        
    }
    
    //画像選択がキャンセルされた時に呼ばれる.
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        // モーダルビューを閉じる
        picker.dismiss(animated: true, completion: nil)
        checkIsimageSelected()
        imageviewOfselectedImageView.center = imageContainerView.center
    }
    
    
    
    func checkIsimageSelected() {
        
        if imageviewOfselectedImageView.image == nil {
            notificationView.isHidden = false
            shareButton.isEnabled = false
            saveButton.isEnabled = false
            
            bananaButton.isEnabled = false
            grapeButton.isEnabled = false
            appleButton.isEnabled = false
            
        }else{
            notificationView.isHidden = true
            shareButton.isEnabled = true
            saveButton.isEnabled = true
            
            bananaButton.isEnabled = true
            grapeButton.isEnabled = true
            appleButton.isEnabled = true
            
        }
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

@available(iOS 15.0, *)
//画像のスクリーンショット、その保存に関するextension
extension NewNextViewController {
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        let accessLevel: PHAccessLevel = .addOnly
        
        if PHPhotoLibrary.authorizationStatus(for: accessLevel) != .authorized {
            PHPhotoLibrary.requestAuthorization(for: accessLevel){ status in
                if status == .authorized {
                    DispatchQueue.main.sync {
                        self.saveImage()
                    }
                }else if status == .denied {
                    DispatchQueue.main.sync {
                        let alart = UIAlertController(title: "許可", message: "設定から写真の保存を許可してください", preferredStyle: .alert)
                        alart.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alart, animated: true, completion: nil)
                    }
                }
            }
        }else{
            saveImage()
        }
        
        
    }
    
    func saveImage(){
        
        if imageviewOfselectedImageView.image != nil {
            let targetImage = screenShot(imageView: imageviewOfselectedImageView)
            let alertController = UIAlertController(title: "保存", message: "この画像を保存しますか？", preferredStyle: .alert)
            
            //OK
            let okAction = UIAlertAction(title: "OK", style: .default) { (ok) in
                //ここでフォトライブラリに画像を保存
                UIImageWriteToSavedPhotosAlbum(targetImage, self, #selector(self.showResultOfSaveImage(_:didFinishSavingWithError:contextInfo:)), nil)
            }
            
            //CANCEL
            let cancelAction = UIAlertAction(title: "キャンセル", style: .default) { (cancel) in
                alertController.dismiss(animated: true, completion: nil)
            }
            //OKとCANCELを表示追加し、アラートを表示
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
        
    }
    
    // 保存結果をアラートで表示
    @objc func showResultOfSaveImage(_ image: UIImage, didFinishSavingWithError error: NSError!, contextInfo: UnsafeMutableRawPointer) {
        
        var title = "保存完了"
        var message = "カメラロールに保存しました"
        
        if error != nil {
            title = "エラー"
            message = "保存に失敗しました"
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // OKボタンを追加
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        // UIAlertController を表示
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func screenShot(imageView: UIImageView) -> UIImage{
        
        if imageviewOfselectedImageView.image != nil {
            let width = CGFloat(imageView.bounds.width)
            
            let height = CGFloat(imageView.bounds.height)
            
            let size = CGSize(width: width, height: height)
            
            UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
            
            let context: CGContext = UIGraphicsGetCurrentContext()!
            
            imageView.layer.render(in: context)
            
            let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            
            UIGraphicsEndImageContext()
            
            return image
        }else{
            return UIImage()
        }
        
    }
    
}

//画像のシェアに関するextension
@available(iOS 15.0, *)
extension NewNextViewController {
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        
        let shareImage = screenShot(imageView: imageviewOfselectedImageView)
        let items = [shareImage] as [Any]
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        present(activityVC, animated: true, completion: nil)
    }
    
}

//果物のボタンが押された時の処理
//addSubViewしたオブジェクトのドラッグ移動
@available(iOS 15.0, *)
extension NewNextViewController {
    
    @IBAction func bananaButtonTapped(_ sender: Any) {
        
        AddFruits.shared.addFruits(imgView: self.imageviewOfselectedImageView, fruitName: "bigbanana")
        
    }
    
    
    
    @IBAction func grapeButtonTapped(_ sender: Any) {
        
        AddFruits.shared.addFruits(imgView: self.imageviewOfselectedImageView, fruitName: "biggrape")
        
    }
    
    @IBAction func appleButtonTapped(_ sender: Any) {
        
        AddFruits.shared.addFruits(imgView: self.imageviewOfselectedImageView, fruitName: "apple")
        
    }
    
    
}

