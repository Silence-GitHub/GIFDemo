//
//  ViewController.swift
//  GIFDemo
//
//  Created by Kaibo Lu on 2017/3/27.
//  Copyright © 2017年 Kaibo Lu. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var imageView: FLAnimatedImageView!
    
    var imageData: Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveImage))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Pick", style: .plain, target: self, action: #selector(pickImage))
        
        imageView = FLAnimatedImageView(frame: CGRect(x: 0,
                                                      y: 64,
                                                      width: UIScreen.main.bounds.width,
                                                      height: 300))
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        
        let button = UIButton(frame: CGRect(x: 0,
                                            y: UIScreen.main.bounds.height - 50,
                                            width: view.bounds.width,
                                            height: 50))
        button.backgroundColor = .blue
        button.setTitle("Table view", for: .normal)
        button.addTarget(self, action: #selector(pushToTVC), for: .touchUpInside)
        view.addSubview(button)
    }
    
    func saveImage() {
        guard let data = imageData else { return }
        if #available(iOS 9.0, *) {
            PHPhotoLibrary.shared().performChanges({ 
                PHAssetCreationRequest.forAsset().addResource(with: .photo, data: data, options: nil)
            }, completionHandler: { (success, error) in
                if success {
                    print("Saved")
                } else if let error = error {
                    print(error)
                }
            })
        } else {
            let tempPath = NSTemporaryDirectory().appending("TempGIFImage.gif")
            let tempUrl = URL(fileURLWithPath: tempPath)
            try? data.write(to: tempUrl)
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: tempUrl)
            }) { (success, error) in
                if success {
                    print("Saved")
                } else if let error = error {
                    print(error)
                }
                try? FileManager.default.removeItem(at: tempUrl)
            }
        }
    }
    
    func pickImage() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    func pushToTVC() {
        navigationController?.pushViewController(TableViewController(), animated: true)
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let url = info[UIImagePickerControllerReferenceURL] as? URL,
            let asset = PHAsset.fetchAssets(withALAssetURLs: [url], options: nil).firstObject {
            PHImageManager.default().requestImageData(for: asset, options: nil, resultHandler: { (imageData, _, _, _) in
                if let data = imageData {
                    self.imageData = data
                    self.imageView.animatedImage = FLAnimatedImage(animatedGIFData: data)
                }
            })
        }
    }

}

