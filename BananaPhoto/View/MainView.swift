import UIKit
import PhotosUI

class MainView: UIView {
    

    var toolBar = UIToolbar()
    
    var shareButtonItem = UIBarButtonItem()
    var saveButtonItem = UIBarButtonItem()
    
    var superStackView = UIStackView()
    var imageContainerView = UIView()
    var imageView = UIImageView()
    
    var buttonsContainersStackView = UIStackView()
    var bananaButton = UIButton()
    var grapeButton = UIButton()
    var appleButton = UIButton()
    
    var selectedImageView = UIImageView()
    
    var imageWidthConstraint: NSLayoutConstraint!
    var imageViewHeightConstraint: NSLayoutConstraint!
    
    
    override init(frame: CGRect) {
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
    }
    
    private func setupNavigationBar() {
        let barButto = UIBarButtonItem(image: UIImage(systemName: "photo"), style: .plain, target: self, action: #selector(barButtonItemTapped(_:)))
    }
    
    @objc func barButtonItemTapped(_ sender: UIBarButtonItem) {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .any(of: [.images, .livePhotos])
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        
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
