//
//  PhotoViewController.swift
//  BananaPhoto
//
//  Created by 始関秀弥 on 2021/08/21.
//

import UIKit
import Photos

class PhotoViewController: UIViewController {
    
    @IBOutlet weak var bananaImageView: UIImageView!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var shareButton: UIButton!
    
    var photo = UIImage()
    
    var tagNumber = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bananaImageView.image = photo
        addBanana()
        
        saveButton.layer.cornerRadius = saveButton.frame.size.height / 2
        
        shareButton.layer.cornerRadius = shareButton.frame.size.height / 2
        
        overrideUserInterfaceStyle = .light
        
        gradation(view)
        
        
        
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
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
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        
        let shareImage = screenShot()
        let items = [shareImage] as [Any]
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        present(activityVC, animated: true, completion: nil)
    }
    
    
    
    
    
    func addBanana(){
        
        let banana = UIImage(named: "bigbanana")
        
        
        
        for y in 0...9{
            for x in 0...9{
                if (x % 2 == 0 && y % 2 == 0) || (x % 2 != 0 && y % 2 != 0){
                    let setupBanana = imageRotatedByDegrees(oldImage: banana!, deg: CGFloat.random(in: 0...365))
                    let bananaImage = UIImageView(image: setupBanana)
                    bananaImage.frame = CGRect(x: CGFloat(x) * bananaImageView.frame.size.width / 9, y: CGFloat(y) * bananaImageView.frame.size.width / 9, width: bananaImageView.frame.size.width / 9, height: bananaImageView.frame.size.width / 9)
                    bananaImageView.addSubview(bananaImage)
                }
            }
        }
    }
    
    
    func saveImage(){
        
        
        let targetImage = screenShot()
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
    
    
    
    
    
    
    //UIImageを回転させる関数
    func imageRotatedByDegrees(oldImage: UIImage, deg degrees: CGFloat) -> UIImage {
        //Calculate the size of the rotated view's containing box for our drawing space
        let rotatedViewBox: UIView = UIView(frame: CGRect(x: 0, y: 0, width: oldImage.size.width, height: oldImage.size.height))
        let t: CGAffineTransform = CGAffineTransform(rotationAngle: degrees * CGFloat.pi / 180)
        rotatedViewBox.transform = t
        let rotatedSize: CGSize = rotatedViewBox.frame.size
        //Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap: CGContext = UIGraphicsGetCurrentContext()!
        //Move the origin to the middle of the image so we will rotate and scale around the center.
        bitmap.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
        //Rotate the image context
        bitmap.rotate(by: (degrees * CGFloat.pi / 180))
        //Now, draw the rotated/scaled image into the context
        bitmap.scaleBy(x: 1.0, y: -1.0)
        bitmap.draw(oldImage.cgImage!, in: CGRect(x: -oldImage.size.width / 2, y: -oldImage.size.height / 2, width: oldImage.size.width, height: oldImage.size.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    
    func screenShot() -> UIImage{
        
        let width = CGFloat(bananaImageView.bounds.width)
        
        let height = CGFloat(bananaImageView.bounds.height)
        
        let size = CGSize(width: width, height: height)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        let context: CGContext = UIGraphicsGetCurrentContext()!
        
        self.bananaImageView.layer.render(in: context)
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        return image
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
