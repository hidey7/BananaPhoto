//
//  MainViewController.swift
//  BananaPhoto
//
//  Created by 始関秀弥 on 2022/08/27.
//

import UIKit
import AVFoundation
import PhotosUI

class MainViewController: UIViewController, PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        let itemProvider = results.first?.itemProvider
        
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                if let image = image {
//                    self.selectedImage = image as! UIImage
                    DispatchQueue.main.async {
                        self.imageContainerView.backgroundColor = .black
                        self.setImageToSelectedImageView(image: image as! UIImage)
                    }
                }
            }
        }
    }
    
    
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
    
    var selectedImage = UIImage()
    var selectedImageView = UIImageView()
    
    //colorRGB = R238 G243 B67
    let bananaColor = UIColor.init(red: 238/255, green: 243/255, blue: 67/255, alpha: 1.0)
    
    var imageViewWidthConstraint: NSLayoutConstraint!
    var imageViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = bananaColor
            self.navigationController?.navigationBar.standardAppearance = appearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
        
        setupUI()
    }
    
    
    private func setupUI() {
        setupNavigationBar()
        setupToolBar()
        setupSuperStackView()
        
        selectedImageView.translatesAutoresizingMaskIntoConstraints = false
        selectedImageView.image = UIImage(named: "noImage")
        imageContainerView.addSubview(selectedImageView)
        selectedImageView.centerXAnchor.constraint(equalTo: imageContainerView.centerXAnchor).isActive = true
        selectedImageView.centerYAnchor.constraint(equalTo: imageContainerView.centerYAnchor).isActive = true
        
    }
    
    
    //MARK: - NAVIGATIONBAR
    private func setupNavigationBar() {
        let barButton = UIBarButtonItem(image: UIImage(systemName: "photo"), style: .plain, target: self, action: #selector(barButtonItemTapped(_:)))
        navigationItem.rightBarButtonItem = barButton
    }
    
    @objc func barButtonItemTapped(_ sender: UIBarButtonItem) {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .any(of: [.images, .livePhotos])
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    //MARK: - TOOLBAR
    private func setupToolBar() {
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
        
        self.view.addSubview(toolBar)
        toolBar.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        NSLayoutConstraint.activate([
            toolBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            toolBar.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            toolBar.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            toolBar.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc func shareButtonTapped(_ sender: UIButton) {
        print("shareButtonTapped")
    }
    @objc func saveButtonTapped(_ sender: UIButton) {
        print("saveButtonTapped")
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
        
        self.view.addSubview(superStackView)
        
        NSLayoutConstraint.activate([
            superStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            superStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            superStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            superStackView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            superStackView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            superStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -44),
        ])
    }
    
    //MARK: - IMAGECONTAINERVIEW
    private func setupImageContainerView() {
        self.imageContainerView = UIView()
        imageContainerView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    //MARK: - BUTTONSCONTAINERSTACKVIEW
    private func setupButtonsContainerStackView() {
        self.buttonsContainerStackView = UIStackView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 300))
        self.bananaButton = UIButton()
        self.grapeButton = UIButton()
        self.appleButton = UIButton()
        
        buttonsContainerStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonsContainerStackView.widthAnchor.constraint(equalToConstant: self.view.bounds.width).isActive = true
        buttonsContainerStackView.axis = .horizontal
        
        bananaButton.translatesAutoresizingMaskIntoConstraints = false
        grapeButton.translatesAutoresizingMaskIntoConstraints = false
        appleButton.translatesAutoresizingMaskIntoConstraints = false
        
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

extension MainViewController {
    
    private func setImageToSelectedImageView(image: UIImage) {
        
        selectedImageView.translatesAutoresizingMaskIntoConstraints = false
        selectedImageView.image = image
        
        let containerWidth: CGFloat = imageContainerView.frame.size.width
        let containerHeight: CGFloat = imageContainerView.frame.size.height
        let imgWidth: CGFloat = image.size.width
        let imgHeight: CGFloat = image.size.height
        
        let widthScale: CGFloat = containerWidth / imgWidth
        let heightScale: CGFloat = containerHeight / imgHeight
        
        if imageViewWidthConstraint == nil {
            imageViewWidthConstraint = self.selectedImageView.widthAnchor.constraint(equalToConstant: imgWidth * widthScale)
            selectedImageView.addConstraint(imageViewWidthConstraint)
        }
        if imageViewHeightConstraint == nil {
            imageViewHeightConstraint = self.selectedImageView.heightAnchor.constraint(equalToConstant: imgHeight * widthScale)
            selectedImageView.addConstraint(imageViewHeightConstraint)
        }
        
        if imgWidth >= imgHeight {
            
            imageViewWidthConstraint.constant = imgWidth * widthScale
            imageViewHeightConstraint.constant = imgHeight * widthScale
            selectedImageView.layoutIfNeeded()
                    
        } else {
            
            imageViewWidthConstraint.constant = imgWidth * heightScale
            imageViewHeightConstraint.constant = imgHeight * heightScale
            selectedImageView.layoutIfNeeded()
            
        }
        
        
        
        
    }
}
