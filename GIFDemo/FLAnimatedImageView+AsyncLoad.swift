//
//  FLAnimatedImageView+AsyncLoad.swift
//  GIFDemo
//
//  Created by Kaibo Lu on 2017/4/5.
//  Copyright © 2017年 Kaibo Lu. All rights reserved.
//

import Foundation

extension FLAnimatedImageView {
    
    func setImage(with url: URL?, placeholderImage: UIImage?) {
        sd_internalSetImage(with: url, placeholderImage: placeholderImage, options: SDWebImageOptions(rawValue: 0), operationKey: nil, setImageBlock: { [weak self] (image, imageData) in
            DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                guard self != nil else { return }
                
                let imageFormat = NSData.sd_imageFormat(forImageData: imageData)
                if imageFormat == .GIF {
                    let animatedImage = FLAnimatedImage(animatedGIFData: imageData)
                    DispatchQueue.main.async { [weak self] in
                        guard let strongSelf = self else { return }
                        strongSelf.animatedImage = animatedImage
                        strongSelf.image = nil
                    }
                } else {
                    DispatchQueue.main.async { [weak self] in
                        guard let strongSelf = self else { return }
                        strongSelf.image = image
                        strongSelf.animatedImage = nil
                    }
                }
            }
            }, progress: nil, completed: nil)
    }
}
