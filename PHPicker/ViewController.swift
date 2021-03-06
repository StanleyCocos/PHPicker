//
//  ViewController.swift
//  PHPicker
//
//  Created by ljc on 2021/11/26.
//

import UIKit
import PhotosUI


class ViewController: UIViewController {
    
    var pickerViewController: PHPickerViewController?
    
    var list: Array<UIImage> = []
    
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        var config = PHPickerConfiguration.init(photoLibrary: PHPhotoLibrary.shared())
        config.selectionLimit = 9
        config.filter = PHPickerFilter.images
        pickerViewController = PHPickerViewController.init(configuration: config)
        pickerViewController?.delegate = self
        
        _setup()
        
    }
    
    private func _setup(){
        let width = view.bounds.width
        //        let height = view.bounds.height
        
        
        navigationItem.rightBarButtonItem =  UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onTap))
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: width / 3 - 10, height: width / 3)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        //        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(Cell.self, forCellWithReuseIdentifier: "Cell")
        view.addSubview(collectionView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}


extension ViewController {
    
    @objc public func onTap(){
        self.present(pickerViewController!, animated: true, completion: nil)
    }
    
}

extension ViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        list.removeAll()
        weak var weakSelf = self
        let itemProviders = results.map(\.itemProvider)
        for item in itemProviders {
            // ?????????????????????load class ??????
            // tip???iPhone ??????????????????iOS 11????????????????????????????????????????????????????????????.heic ???.heif ?????????
            //
            
            
            
            for type in item.registeredTypeIdentifiers {
                item.loadDataRepresentation(forTypeIdentifier: type, completionHandler:{(data, error) in
                    print("\(type)?????? -- ??????:\(data?.count ?? 0)")
                    
                    guard let data = data, data.count > 0 else {
                        return
                    }
                    print("\(type)?????? ?????? -- ??????:\(data.count ?? 0)")
                    DispatchQueue.main.async {
                        guard let image = UIImage(data : data) else { return }
                        weakSelf?.list.append(image)
                        weakSelf?.collectionView.reloadData()
                    }
                })
            }
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Cell
        cell.image = list[indexPath.row]
        return cell
    }
    
}


class Cell: UICollectionViewCell {
    
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView.init(frame: self.contentView.bounds);
        return imageView
    }()
    
    
    var image: UIImage? {
        didSet{
            imageView.image = image
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
