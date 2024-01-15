import UIKit
import PhotosUI

class MainView: UIView {
    
    
    var toolBar = UIToolbar()
    
    var shareButtonItem = UIBarButtonItem()
    var saveButtonItem = UIBarButtonItem()
    
    var superStackView = UIStackView()
    var imageContainerView = UIView()
    var imageView = UIImageView()
    
    var buttonsContainerStackView = UIStackView()
    var bananaButton = UIButton()
    var grapeButton = UIButton()
    var appleButton = UIButton()
    
    var selectedImageView = UIImageView()
    
    var imageWidthConstraint: NSLayoutConstraint!
    var imageViewHeightConstraint: NSLayoutConstraint!
    
    let bananaColor = UIColor.init(red: 238/255, green: 243/255, blue: 67/255, alpha: 1.0)
    
    var navigationBar: UINavigationBar!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.backgroundColor = UIColor.init(red: 238/255, green: 243/255, blue: 67/255, alpha: 1.0)
        setupNavigationBar()
        setupToolBar()
        setupSuperStackView()
        
        selectedImageView.translatesAutoresizingMaskIntoConstraints = false
        selectedImageView.image = UIImage(named: "noImage")
        imageContainerView.addSubview(selectedImageView)
        selectedImageView.centerXAnchor.constraint(equalTo: imageContainerView.centerXAnchor).isActive = true
        selectedImageView.centerYAnchor.constraint(equalTo: imageContainerView.centerYAnchor).isActive = true
    }
    
    private func setupNavigationBar() {
        let bananaColor = UIColor.init(red: 238/255, green: 243/255, blue: 67/255, alpha: 1.0)

        self.navigationBar = UINavigationBar()
        navigationBar.barTintColor = bananaColor
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = bananaColor
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.isTranslucent = false
        let barButton = UIBarButtonItem(image: UIImage(systemName: "photo"), style: .plain, target: self, action: #selector(barButtonItemTapped(_:)))
        let clearButton = UIBarButtonItem(image: UIImage(systemName: "gobackward"), style: .plain, target: self, action: nil)
        let navItem = UINavigationItem()
        navItem.rightBarButtonItem = barButton
        navItem.leftBarButtonItem = clearButton
        navigationBar.items = [navItem]
        
        self.addSubview(navigationBar)
        
        
        self.navigationBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            navigationBar.heightAnchor.constraint(equalToConstant: 44),
            navigationBar.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            navigationBar.rightAnchor.constraint(equalTo: self.rightAnchor),
            navigationBar.leftAnchor.constraint(equalTo: self.leftAnchor)
        ])
        
       
        navigationBar.accessibilityIdentifier = "navigationBar"
    }
    
    @objc func barButtonItemTapped(_ sender: UIBarButtonItem) {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .any(of: [.images, .livePhotos])
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        
    }
    
    //MARK: - TOOLBAR
    private func setupToolBar() {
        toolBar.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 44)
        print("toolBar.frame.width \(self.frame.width)")
        print("toolBar.bounds.width \(self.bounds.width)")
        print("toolBar.frame.height \(self.frame.height)")
        print("toolBar.bounds.height \(self.bounds.height)")
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        toolBar.barTintColor = .white
        toolBar.backgroundColor = .white
        toolBar.isTranslucent = true
        
        let shareButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        shareButton.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        shareButton.addTarget(self, action: #selector(shareButtonTapped(_:)), for: .touchUpInside)
        self.shareButtonItem = UIBarButtonItem(customView: shareButton)
        
        let flexibleItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        
        let saveButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        saveButton.setImage(UIImage(systemName: "square.and.arrow.down"), for: .normal)
        saveButton.addTarget(self, action: #selector(saveButtonTapped(_:)), for: .touchUpInside)
        self.saveButtonItem = UIBarButtonItem(customView: saveButton)
        
        toolBar.items = [shareButtonItem, flexibleItem, saveButtonItem]
        
        self.addSubview(toolBar)
        NSLayoutConstraint.activate([
            toolBar.heightAnchor.constraint(equalToConstant: 44),
            toolBar.rightAnchor.constraint(equalTo: self.rightAnchor),
            toolBar.leftAnchor.constraint(equalTo: self.leftAnchor),
            toolBar.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        toolBar.accessibilityIdentifier = "toolBar"
    }
    
    @objc func shareButtonTapped(_ sender: UIButton) {
        let shareImage = selectedImageView.image
        let items = [shareImage as Any] as [Any]
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
//        present(activityVC, animated: true, completion: nil) // これはMainVCの処理
    }
    
    @objc func saveButtonTapped(_ sender: UIButton) {
        let targetImage = selectedImageView.image
        let alertController = UIAlertController(title: "保存", message: "この画像を保存しますか？", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { [self] (ok) in
            UIImageWriteToSavedPhotosAlbum(targetImage!, self, #selector(showResultOfSaveImage(_:didFinishSavingWithError:contextInfo:)), nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (cancel) in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
//        present(alertController, animated: true, completion: nil) //これはMainVCの処理
    }
    
    @objc func showResultOfSaveImage(_ image: UIImage, didFinishSavingWithError error: NSError!, contextInfo: UnsafeMutableRawPointer) {
        
        var title = "保存完了"
        var message = "カメラロールに保存しました"
        
        if error != nil {
            title = "エラー"
            message = "保存に失敗しました"
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
//        self.present(alert, animated: true, completion: nil) //これはMainVCの処理
    }
    
    //MARK: - SUPERSTAKCVIEW
    private func setupSuperStackView() {
        setupImageContainerView()
        setupButtonsContainerStackView()
        
        superStackView.translatesAutoresizingMaskIntoConstraints = false
        superStackView.backgroundColor = .white
        superStackView.axis = .vertical
        
        superStackView.addArrangedSubview(imageContainerView)
        superStackView.addArrangedSubview(buttonsContainerStackView)
        
        
        NSLayoutConstraint.activate([
            imageContainerView.heightAnchor.constraint(equalTo: superStackView.heightAnchor, multiplier: 4/5),
            buttonsContainerStackView.heightAnchor.constraint(equalTo: superStackView.heightAnchor, multiplier: 1/5),
        ])
        
        imageContainerView.backgroundColor = .white
        
        self.addSubview(superStackView)
        
        NSLayoutConstraint.activate([
            superStackView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            superStackView.rightAnchor.constraint(equalTo: self.rightAnchor),
            superStackView.leftAnchor.constraint(equalTo: self.leftAnchor),
            superStackView.bottomAnchor.constraint(equalTo: toolBar.topAnchor),
        ])
        
        superStackView.accessibilityIdentifier = "superStackView"
    }
    
    //MARK: - IMAGECONTAINERVIEW
    private func setupImageContainerView() {
        self.imageContainerView = UIView()
        imageContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        imageContainerView.accessibilityIdentifier = "imageContainerView"
    }
    
    //MARK: - BUTTONSCONTAINERSTACKVIEW
    private func setupButtonsContainerStackView() {
        self.buttonsContainerStackView = UIStackView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: 300))
        self.bananaButton = UIButton()
        self.grapeButton = UIButton()
        self.appleButton = UIButton()
        
        buttonsContainerStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonsContainerStackView.axis = .horizontal
        
        bananaButton.translatesAutoresizingMaskIntoConstraints = false
        grapeButton.translatesAutoresizingMaskIntoConstraints = false
        appleButton.translatesAutoresizingMaskIntoConstraints = false
        
        bananaButton.tag = 0
        grapeButton.tag = 1
        appleButton.tag = 2
        
        bananaButton.addTarget(self, action: #selector(fruitButtonTapped(_:)), for: .touchUpInside)
        grapeButton.addTarget(self, action: #selector(fruitButtonTapped(_:)), for: .touchUpInside)
        appleButton.addTarget(self, action: #selector(fruitButtonTapped(_:)), for: .touchUpInside)
        
        bananaButton.setImage(UIImage(named: "bigbanana"), for: .normal)
        grapeButton.setImage(UIImage(named: "biggrape"), for: .normal)
        appleButton.setImage(UIImage(named: "apple"), for: .normal)
        
        bananaButton.backgroundColor = bananaColor
        grapeButton.backgroundColor = bananaColor
        appleButton.backgroundColor = bananaColor
        
        buttonsContainerStackView.addArrangedSubview(bananaButton)
        buttonsContainerStackView.addArrangedSubview(grapeButton)
        buttonsContainerStackView.addArrangedSubview(appleButton)
        
        NSLayoutConstraint.activate([
            bananaButton.heightAnchor.constraint(equalTo: buttonsContainerStackView.heightAnchor),
            grapeButton.heightAnchor.constraint(equalTo: buttonsContainerStackView.heightAnchor),
            appleButton.heightAnchor.constraint(equalTo: buttonsContainerStackView.heightAnchor),
            
            bananaButton.widthAnchor.constraint(equalTo: buttonsContainerStackView.widthAnchor, multiplier: 1/3),
            grapeButton.widthAnchor.constraint(equalTo: buttonsContainerStackView.widthAnchor, multiplier: 1/3),
            appleButton.widthAnchor.constraint(equalTo: buttonsContainerStackView.widthAnchor, multiplier: 1/3),
        ])
        
        buttonsContainerStackView.accessibilityIdentifier = "buttonsContainerStackView"
        bananaButton.accessibilityIdentifier = "bananaButton"
        grapeButton.accessibilityIdentifier = "grapeButton"
        appleButton.accessibilityIdentifier = "appleButton"
    }
    
    @objc func fruitButtonTapped(_ sender: UIButton) {
        let targetImage = selectedImageView.image
        var editedImage = UIImage()
        switch sender.tag {
        case 0:
            editedImage = (targetImage?.addFruit(image: UIImage(named: "bigbanana")!))!
        case 1:
            editedImage = (targetImage?.addFruit(image: UIImage(named: "biggrape")!))!
        case 2:
            editedImage = (targetImage?.addFruit(image: UIImage(named: "apple")!))!
        default:
            break
        }
        selectedImageView.image = editedImage
    }
    
    
    
}

extension MainView: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        picker.dismiss(animated: true)
        
        let itemProvider = results.first?.itemProvider
        
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                if let image = image {
                    
                }
            }
        }
        
    }
    
}
