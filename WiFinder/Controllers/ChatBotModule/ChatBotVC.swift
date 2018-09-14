//
//  ChatBotVC.swift
//  WiFinder
//
//  Created by Boariu Andy on 9/12/18.
//  Copyright © 2018 Momentous Tech Corp. All rights reserved.
//

import UIKit
import Photos

class ChatBotVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak private var txvComment: UITextView!
    @IBOutlet weak private var btnPostComment: UIButton!
    @IBOutlet weak private var constChatViewBottom: NSLayoutConstraint!

    var pickerControler = UIImagePickerController()
    
    var arrMessages = [Message]()
    var arrBotMessages = [Message]()
    
    // MARK: - View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        prepareBotMessages()
    }
    
    // MARK: - Notification Methods
    
    @objc func keyboardWillShow(notification: NSNotification) {
        //>>    Get Y of keyboard
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            constChatViewBottom.constant = -keyboardSize.height + (tabBarController?.tabBar.frame.size.height)!
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        }) { [weak self] finished in
            guard let me = self else { return }
            
            if finished {
                if me.arrMessages.count > 2 {
                    me.tableView.scrollToRow(at: IndexPath(row: me.arrMessages.count - 1, section: 0), at: UITableViewScrollPosition.bottom, animated: true)
                }
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
        
        //=>    Load first bot message
        loadRandomBotMessage()
    }
    
    private func prepareBotMessages() {
        let bot1 = Message(text: "Find Happening Places. See where the fun crowds are hanging out. Be in the right place at the right time!", image: nil, sender: .bot, type: .text)
        let bot2 = Message(text: nil, image: #imageLiteral(resourceName: "imgBot1"), sender: .bot, type: .image)
        let bot3 = Message(text: "Connect To WiFiesta Community's Wi-Fi Hot Spots. Stay connected while traveling, stuck in a dead spot or trying to save on data usage.", image: nil, sender: .bot, type: .text)
        let bot4 = Message(text: nil, image: #imageLiteral(resourceName: "imgBot2"), sender: .bot, type: .image)
        let bot5 = Message(text: "Share Your Media Automatically. Your photos and videos get shared automatically with friends who are checked in at your Fiesta.", image: nil, sender: .bot, type: .text)
        let bot6 = Message(text: nil, image: #imageLiteral(resourceName: "imgBot3"), sender: .bot, type: .image)
        arrBotMessages.append(contentsOf: [bot1, bot2, bot3, bot4, bot5, bot6])
    }
    
    private func loadMessageInTableView(message: Message) {
        //=>    Load message
        arrMessages.append(message)
        tableView.reloadData()
        
        //=>    Scroll to latest cell
        tableView.scrollToRow(at: IndexPath(row: arrMessages.count - 1, section: 0), at: UITableViewScrollPosition.bottom, animated: true)
    }
    
    private func loadRandomBotMessage() {
        //=>    This will return a random number between 0 and array count - 1
        let random = Int(arc4random_uniform(UInt32(arrBotMessages.count)))
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.loadMessageInTableView(message: self.arrBotMessages[random])
        }
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
        //=>    Hide keyboard
        if txvComment.isFirstResponder {
            txvComment.resignFirstResponder()
        }
        
        let alert = UIAlertController(title: "Please select one option below:", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { (action) in
            self.checkStatusOfCamera()
        }))
        alert.addAction(UIAlertAction(title: "Choose Existing Photo", style: .default, handler: { (action) in
            self.checkStatusOfPhotoLibrary()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnSendMessageAction(_ sender: UIButton) {
        if let strTextMessage = txvComment.text,
            !strTextMessage.isEmpty {
            
            //=>    Load new message text in table view
            let message = Message(text: strTextMessage, image: nil, sender: .user, type: .text)
            loadMessageInTableView(message: message)
            
            //=>    Clear text
            txvComment.text = ""
            
            //=>    Push a rand bot message
            loadRandomBotMessage()
        }
    }
    
    // MARK: - Memory Cleanup

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - UITableViewDataSource Methods

extension ChatBotVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let curMessage = arrMessages[indexPath.row]
        if curMessage.type == .text {
            let cell = tableView.dequeueReusableCell(withIdentifier: TextMessageCell.cellID, for: indexPath) as! TextMessageCell
            cell.loadMessage(curMessage)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ImageMessageCell.cellID, for: indexPath) as! ImageMessageCell
            cell.loadMessage(curMessage)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //=>    Hide keyboard
        if txvComment.isFirstResponder {
            txvComment.resignFirstResponder()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //=>    Get message
        let curMessage = arrMessages[indexPath.row]
        if curMessage.type == .text {
            return UITableViewAutomaticDimension
        }
        else {
            return 210.0
        }
    }
}

// MARK: - UIImagePickerControllerDelegate Methods

extension ChatBotVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true) {
            if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
                let message = Message(text: nil, image: editedImage, sender: .user, type: .image)
                self.loadMessageInTableView(message: message)
                
                self.loadRandomBotMessage()
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true)
    }
}
