//
//  MainViewController.swift
//  BananaPhoto
//
//  Created by 始関秀弥 on 2022/08/27.
//

import UIKit
import AVFoundation

class MainViewController: UIViewController {
    
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
    
    //colorRGB = R238 G243 B67
    let bananaColor = UIColor.init(red: 238/255, green: 243/255, blue: 67/255, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //        navigationItem.title = "画面1"
        
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = bananaColor
            self.navigationController?.navigationBar.standardAppearance = appearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
        
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    private func setupUI() {
        setupNavigationBar()
        setupToolBar()
        setupSuperStackView()
    }
    
    //MARK: - NAVIGATIONBAR
    private func setupNavigationBar() {
        let barButton = UIBarButtonItem(image: UIImage(systemName: "photo"), style: .plain, target: self, action: #selector(barButtonItemTapped(_:)))
        navigationItem.rightBarButtonItem = barButton
    }
    
    @objc func barButtonItemTapped(_ sender: UIBarButtonItem) {
        
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
        imageContainerView.widthAnchor.constraint(equalToConstant: self.view.bounds.width).isActive = true
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
        //        buttonsContainerStackView?.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 300)
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
            //            buttonsContainerStackView.widthAnchor.constraint(equalToConstant: self.view.bounds.width),
            
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
