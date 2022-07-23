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
        
//        imageviewOfselectedImageView.isUserInteractionEnabled = true
        
        overrideUserInterfaceStyle = .light
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 238/255, green: 243/255, blue: 56/255, alpha: 1.0)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "photo"), landscapeImagePhone: UIImage(systemName: "photo"), style: .plain, target: self, action: #selector(showPhotoLibrary))
        
//        setupSelectedImageView()
//        self.view.sendSubviewToBack(imageviewOfselectedImageView)
    }
    
//    func setupSelectedImageView() {
//        let doubleTouche = UIPinchGestureRecognizer(target: self, action: #selector(selectedImageViewDoubleTouched(sender:)))
//        imageviewOfselectedImageView.addGestureRecognizer(doubleTouche)
//    }
//
//    @objc func selectedImageViewDoubleTouched(sender: UIPinchGestureRecognizer) {
//        imageviewOfselectedImageView.transform = CGAffineTransform(scaleX: sender.scale, y: sender.scale)
//    }

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
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        if let obj = touches.first?.view as? UIImageView {
            
            if obj != imageviewOfselectedImageView {
                // タッチイベントを取得.
                let aTouch: UITouch = touches.first!
                
                // 移動した先の座標を取得.
                let location = aTouch.location(in: self.imageviewOfselectedImageView)
                
                // 移動する前の座標を取得.
                let prevLocation = aTouch.previousLocation(in: self.imageviewOfselectedImageView)
                
                // CGRect生成.
                //            var myFrame: CGRect = banana.frame
                var myCenterX: CGFloat = obj.center.x
                var myCenterY: CGFloat = obj.center.y
                // ドラッグで移動したx, y距離をとる.
                let deltaX: CGFloat = location.x - prevLocation.x
                let deltaY: CGFloat = location.y - prevLocation.y
                
                // 移動した分の距離をmyFrameの座標にプラスする.
                myCenterX += deltaX
                myCenterY += deltaY
                
                // frameにmyFrameを追加.
                obj.center.x = myCenterX
                obj.center.y = myCenterY
                
                let rect = imageviewOfselectedImageView.bounds.insetBy(dx: obj.frame.width / 2, dy: obj.frame.height / 2)
                if obj.center.x <= rect.minX {
                    obj.center.x = rect.minX
                }
                if obj.center.x >= rect.maxX{
                    obj.center.x = rect.maxX
                }
                if obj.center.y <= rect.minY{
                    obj.center.y = rect.minY
                }
                if obj.center.y >= rect.maxY{
                    obj.center.y = rect.maxY
                }

            }
            
        }
    }
    
    //    }
    
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
        
//        let banana = UIImageView(image: UIImage(named: "bigbanana"))
//
//        let centerX = imageviewOfselectedImageView.frame.size.width / 2
//        let centerY = imageviewOfselectedImageView.frame.size.height / 2
//        banana.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
//        banana.isUserInteractionEnabled = true
//
//        self.imageviewOfselectedImageView.addSubview(banana)
//        banana.center.x = centerX
//        banana.center.y = centerY
        
         AddFruits.shared.addFruits(imgView: self.imageviewOfselectedImageView, fruitName: "bigbanana")
        
    }
    
    
    
    @IBAction func grapeButtonTapped(_ sender: Any) {
//        let grape = UIImageView(image: UIImage(named: "biggrape"))
//
//        let centerX = imageviewOfselectedImageView.frame.size.width / 2
//        let centerY = imageviewOfselectedImageView.frame.size.height / 2
//        grape.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
//        grape.isUserInteractionEnabled = true
//
//        self.imageviewOfselectedImageView.addSubview(grape)
//        grape.center.x = centerX
//        grape.center.y = centerY
        
         AddFruits.shared.addFruits(imgView: self.imageviewOfselectedImageView, fruitName: "biggrape")
        
        
    }
    
    @IBAction func appleButtonTapped(_ sender: Any) {
        
//        let apple = UIImageView(image: UIImage(named: "apple"))
//
//        let centerX = imageviewOfselectedImageView.frame.size.width / 2
//        let centerY = imageviewOfselectedImageView.frame.size.height / 2
//        apple.frame = CGRect(x: 0, y: 0, width: 70, height: 70)
//        apple.isUserInteractionEnabled = true
//
//        self.imageviewOfselectedImageView.addSubview(apple)
//        apple.center.x = centerX
//        apple.center.y = centerY
        
        AddFruits.shared.addFruits(imgView: self.imageviewOfselectedImageView, fruitName: "apple")
    }
  
    
}

