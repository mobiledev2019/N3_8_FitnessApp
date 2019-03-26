//
//  Camera.swift
//  PtitMe
//
//  Created by kienpt on 02/18/19.
//  Copyright © 2019 Mobileteam. All rights reserved.
//

import UIKit

enum CameraPhotoServiceType {
    case camera, photoLibrary
}

class CameraPhotoService: NSObject {
    // MARK: - Singleton
    static var instance = CameraPhotoService()
    
    // MARK: - Closures
    var didPickImage: ((_ image: UIImage?) -> Void)?
    
    func showScreenOf(type: CameraPhotoServiceType, canEdit: Bool = false, didPickImage: @escaping ((_ image: UIImage?) -> Void)) {
        let sourceType: UIImagePickerController.SourceType = type == .camera ? .camera : .photoLibrary
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else {
            didPickImage(nil)
            return
        }
        self.didPickImage = didPickImage
        let cameraView = UIImagePickerController()
        cameraView.delegate = self
        cameraView.sourceType = sourceType
        cameraView.allowsEditing = canEdit
        UIViewController.topViewController()?.present(cameraView, animated: true, completion: nil)
    }
}

extension CameraPhotoService: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: {
            guard let image = info[.originalImage] as? UIImage else {
                self.didPickImage?(nil)
                return
            }
            self.didPickImage?(image)
        })
        
    }
}
