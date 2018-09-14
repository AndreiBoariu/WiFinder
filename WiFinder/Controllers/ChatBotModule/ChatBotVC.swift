//
//  ChatBotVC.swift
//  WiFinder
//
//  Created by Boariu Andy on 9/12/18.
//  Copyright © 2018 Momentous Tech Corp. All rights reserved.
//

import UIKit
import GrowingTextView
import Photos

class ChatBotVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak private var txvComment: UITextView!
    @IBOutlet weak private var btnPostComment: UIButton!
    @IBOutlet weak private var constChatViewBottom: NSLayoutConstraint!

    var pickerControler = UIImagePickerController()
    
    // MARK: - View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    // MARK: - Notification Methods
    
    @objc func keyboardWillShow(notification: NSNotification) {
        //>>    Get Y of keyboard
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            constChatViewBottom.constant = keyboardSize.height
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        }) { finished in
            if finished {
                
            }
        }
    }
    
    @objc func keyboardDidHide(notification: NSNotification) {
        constChatViewBottom.constant = 0
        
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - Public Methods
    
    // MARK: - Custom Methods
    
    private func setupUI() {
        NotificationCenter.default.addObserver(self, selector: #selector(ChatBotVC.keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatBotVC.keyboardDidHide(notification:)), name: .UIKeyboardWillHide, object: nil)
        
        txvComment.layer.cornerRadius = 5.0
    }
    
    private func warnUserToAllowAccessCamera() {
        let alert = UIAlertController(title: "Opss", message: "We couldn't access your camera or photo library. You may need to enable 'WiFinder' to access your camera.", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { (action) in
            let url = NSURL(string: UIApplicationOpenSettingsURLString)
            UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Camera and Library Methods
    
    func takePhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            pickerControler.delegate        = self
            pickerControler.sourceType      = .camera
            pickerControler.allowsEditing   = true
            
            present(pickerControler, animated: true, completion: nil)
        }
    }
    
    func choosePhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            pickerControler.delegate        = self
            pickerControler.sourceType      = .photoLibrary
            pickerControler.allowsEditing   = true
            
            present(pickerControler, animated: true, completion: nil)
        }
    }
    
    func checkStatusOfCamera() {
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch status {
        case .authorized:
            takePhoto()
            
        case .denied:
            warnUserToAllowAccessCamera()
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (allowed) in
                if allowed {
                    self.takePhoto()
                }
            })
            
        case .restricted:
            break
        }
    }
    
    func checkStatusOfPhotoLibrary() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            self.choosePhoto()
            
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == PHAuthorizationStatus.authorized {
                    self.choosePhoto()
                }
            })
            
        case .restricted:
            break
            
        case .denied:
            warnUserToAllowAccessCamera()
        }
    }
    
    // MARK: - API Methods
    
    // MARK: - Action Methods
    
    @IBAction func btnAddImageAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "Please select one option below:", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Choose Existing Photo", style: .default, handler: { (action) in
            self.checkStatusOfPhotoLibrary()
        }))
        
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { (action) in
            self.checkStatusOfCamera()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
        
        view.endEditing(true)
    }
    
    @IBAction func btnSendMessageAction(_ sender: UIButton) {
    }
    
    // MARK: - Memory Cleanup

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - UIImagePickerControllerDelegate Methods

extension ChatBotVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true) {
            if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
                
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true)
    }
}
