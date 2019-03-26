//
//  Permission.swift
//  PtitMe
//
//  Created by kienpt on 02/18/19.
//  Copyright © 2019 Mobileteam. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

// MARK: - Camera permission
class Permission {
    static var cameraAuthStatus: AVAuthorizationStatus {
        return AVCaptureDevice.authorizationStatus(for: .video)
    }
    
    static func requestCameraPermission(completion: @escaping ((_ authorized: Bool) -> Void)) {
        switch Permission.cameraAuthStatus {
        case .authorized:
            completion(true)
        case .denied:
            completion(false)
        default:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
        }
    }
}

// MARK: - Photo permission
extension Permission {
    static var photoAuthStatus: PHAuthorizationStatus {
        return PHPhotoLibrary.authorizationStatus()
    }
    
    static func requestPhotoPermission(completion: @escaping ((_ authorized: Bool) -> Void)) {
        switch Permission.photoAuthStatus {
        case .authorized:
            completion(true)
        case .denied:
            completion(false)
        default:
            PHPhotoLibrary.requestAuthorization { status in
                DispatchQueue.main.async {
                    completion(status == .authorized)
                }
            }
        }
    }
}

// MARK: - Record permission
extension Permission {
    static var recordStatus: AVAudioSession.RecordPermission {
        return AVAudioSession.sharedInstance().recordPermission
    }
    
    static func requestRecordPermission(completion: @escaping ((_ authorized: Bool) -> Void)) {
        switch recordStatus {
        case .granted:
            completion(true)
        case .denied:
            completion(false)
        default:
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
        }
    }
}
