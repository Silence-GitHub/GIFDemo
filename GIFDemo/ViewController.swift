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

    var imageView: UIImageView!
    
    var imageData: Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveImage))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Pick", style: .plain, target: self, action: #selector(pickImage))
        
        imageView = UIImageView(frame: CGRect(x: 10, y: 100, width: UIScreen.main.bounds.width - 20, height: 300))
        view.addSubview(imageView)
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
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let url = info[UIImagePickerControllerReferenceURL] as? URL,
            let asset = PHAsset.fetchAssets(withALAssetURLs: [url], options: nil).firstObject {
            PHImageManager.default().requestImageData(for: asset, options: nil, resultHandler: { (imageData, _, _, _) in
                if let data = imageData {
                    self.imageData = data
                    self.imageView.image = UIImage.sd_animatedGIF(with: data)
                }
            })
        }
    }

}

