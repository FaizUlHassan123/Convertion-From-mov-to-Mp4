//
//  ViewController.swift
//  mov to Mp4
//
//  Created by Faiz Ul Hassan on 14/06/2023.
//

import UIKit
import AVFoundation
import MobileCoreServices
import PhotosUI


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func click(sender : UIButton){
        presentVideoPicker()
    }

    func presentVideoPicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = [kUTTypeMovie as String]
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }


}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)

        guard let mediaType = info[.mediaType] as? String,
              mediaType == kUTTypeMovie as String,
              let videoURL = info[.mediaURL] as? URL else {
            return
        }

        convertMovToMp4AndSaveToAppFolder(inputURL: videoURL)
    }
    

    func convertMovToMp4AndSaveToAppFolder(inputURL: URL) {
        let outputURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("output.mp4")
        
        let asset = AVURLAsset(url: inputURL)
        let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetPassthrough)
        
        exportSession?.outputFileType = .mp4
        exportSession?.outputURL = outputURL
        
        exportSession?.exportAsynchronously(completionHandler: {
            if exportSession?.status == .completed {
                print("Video converted successfully.")
                
                // Access the converted video at outputURL and perform further actions if needed
            } else if let error = exportSession?.error {
                print("Video conversion failed: \(error.localizedDescription)")
            }
        })
    }


}
