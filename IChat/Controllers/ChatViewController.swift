//
//  ChatViewController.swift
//  IChat
//
//  Created by Дмитрий Межевич on 2.03.22.
//

import UIKit
import MessageKit
import Firebase
import InputBarAccessoryView

class ChatViewController: MessagesViewController {
    
    private let currentUser: MUser
    private let chat: MChat
    
    private var listenerMessages: ListenerRegistration?
    
    private var messages = [MMessage]()
    
    init(currentUser: MUser, chat: MChat) {
        self.currentUser = currentUser
        self.chat = chat
        super.init(nibName: nil, bundle: nil)
        
        title = chat.username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        listenerMessages?.remove()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messagesCollectionView.backgroundColor = .mainWhite()
        configureMessagesInputBar()
        
        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
            layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
            layout.textMessageSizeCalculator.incomingAvatarSize = .zero
            layout.photoMessageSizeCalculator.incomingAvatarSize = .zero
            layout.photoMessageSizeCalculator.outgoingAvatarSize = .zero
        }
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        
        listenerMessages = ListenerService.shared.addListenerMessages(chat: chat, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(var message):
                
                if let url = message.downloadURL {
                    FirebaseStorage.shered.downlaodImage(url: url) { [weak self] result in
                        guard let self = self else { return }
                        switch result {
                        case .success(let image):
                            message.image = image
                            self.insertNewMassage(message: message)
                        case .failure(let error):
                            self.showAlert(title: "Error", message: error.localizedDescription)
                        }
                    }
                } else {
                    if !self.messages.contains(message) {
                        self.insertNewMassage(message: message)
                    }
                }
            case .failure(let error):
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        })
    }
    
}

// MARK: - Piravet method
extension ChatViewController {
    
    private func configureMessagesInputBar() {
        messageInputBar.isTranslucent = true
        messageInputBar.separatorLine.isHidden = true
        messageInputBar.backgroundView.backgroundColor = .mainWhite()
        messageInputBar.inputTextView.backgroundColor = .white
        messageInputBar.inputTextView.placeholderTextColor = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1)
        messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 14, left: 30, bottom: 14, right: 36)
        messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 14, left: 36, bottom: 14, right: 36)
        messageInputBar.inputTextView.layer.borderColor = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 0.4033635232)
        messageInputBar.inputTextView.layer.borderWidth = 0.2
        messageInputBar.inputTextView.layer.cornerRadius = 18.0
        messageInputBar.inputTextView.layer.masksToBounds = true
        messageInputBar.inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 14, left: 0, bottom: 14, right: 0)
        
        
        messageInputBar.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        messageInputBar.layer.shadowRadius = 5
        messageInputBar.layer.shadowOpacity = 0.3
        messageInputBar.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        configureSendButton()
        configureCameraIcon()
    }
    
    private func configureSendButton() {
        messageInputBar.sendButton.setImage(UIImage(named: "Sent"), for: .normal)
        messageInputBar.sendButton.applyGradients(cornerRadius: 10)
        messageInputBar.setRightStackViewWidthConstant(to: 56, animated: false)
        messageInputBar.sendButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 6, right: 30)
        messageInputBar.sendButton.setSize(CGSize(width: 48, height: 48), animated: true)
        messageInputBar.middleContentViewPadding.right = -38
    }
    
    private func configureCameraIcon() {
        let cameraItem = InputBarButtonItem(type: .system)
        cameraItem.tintColor = #colorLiteral(red: 0.8309458494, green: 0.7057176232, blue: 0.9536159635, alpha: 1)
        let cameraImage = UIImage(systemName: "camera")!
        cameraItem.image = cameraImage
        
        cameraItem.addTarget(self, action: #selector(cameraButtonPressed), for: .primaryActionTriggered)
        cameraItem.setSize(CGSize(width: 60, height: 30), animated: false)
        
        messageInputBar.leftStackView.alignment = .center
        messageInputBar.setLeftStackViewWidthConstant(to: 50, animated: true)
        
        messageInputBar.setStackViewItems([cameraItem], forStack: .left, animated: false)
    }
    
    private func insertNewMassage(message: MMessage) {
        messages.append(message)
        messages.sort()
        
        let isLastMessage = messages.firstIndex(of: message) == messages.count - 1
        let shouldScrollToBottom = messagesCollectionView.isAtBotton && isLastMessage
        
        messagesCollectionView.reloadData()
        
        if shouldScrollToBottom {
            DispatchQueue.main.async {
                self.messagesCollectionView.scrollToLastItem()
            }
        }
    }
    
    private func sendImage(image: UIImage) {
        
        FirebaseStorage.shered.uplaodImageMessage(image: image, to: chat) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let imageURL):
                var message = MMessage(user: self.currentUser, downloadURL: imageURL)
                message.image = image
                FirebaseService.shered.sendMessageInChat(sender: self.currentUser, chat: self.chat, message: message) { result in
                    switch result {
                    case .success():
                        self.messagesCollectionView.scrollToLastItem()
                    case .failure(let error):
                        self.showAlert(title: "Error", message: error.localizedDescription)
                    }
                }
            case .failure(let error):
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    @objc private func cameraButtonPressed() {
        let picker = UIImagePickerController()
        picker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        
        present(picker, animated: true)
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        
        sendImage(image: image)
    }
}

// MARK: - Messages Data Source
extension ChatViewController: MessagesDataSource {
    func currentSender() -> SenderType {
        Sender(senderId: currentUser.id, displayName: currentUser.username)
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        messages.count
    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if indexPath.section % 4 == 0 {
            let attributedString = MessageKitDateFormatter.shared.attributedString(from: message.sentDate,
                                                                                   with: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 10),
                                                                                          NSAttributedString.Key.foregroundColor: UIColor.darkGray])
            return NSAttributedString(attributedString: attributedString)
        } else {
            return nil
        }
    }
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if indexPath.section % 4 == 0 {
            return 30
        } else {
            return 0
        }
    }
}

// MARK: - Messages Layout Delegate
extension ChatViewController: MessagesLayoutDelegate {
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        16
    }
}

// MARK: - Messages Display Delegate
extension ChatViewController: MessagesDisplayDelegate {
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        isFromCurrentSender(message: message) ? .white : #colorLiteral(red: 0.8309458494, green: 0.7057176232, blue: 0.9536159635, alpha: 1)
    }
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        isFromCurrentSender(message: message) ? #colorLiteral(red: 0.2392156863, green: 0.2392156863, blue: 0.2392156863, alpha: 1) : .white
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        avatarView.isHidden = true
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        isFromCurrentSender(message: message) ? .bubbleTail(.bottomRight, .pointedEdge) : .bubbleTail(.bottomLeft, .pointedEdge)
        
    }
    
}

extension ChatViewController: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        let message = MMessage(user: currentUser, text: text)
        FirebaseService.shered.sendMessageInChat(sender: currentUser, chat: chat, message: message) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success():
                inputBar.inputTextView.text = ""
                self.messagesCollectionView.scrollToLastItem()
            case .failure(let error):
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
}

extension UIScrollView {
    
    var isAtBotton: Bool {
        contentOffset.y >= verticalOffsetForBottm
    }
    
    var verticalOffsetForBottm: CGFloat {
        let scrollViewHeight = bounds.height
        let scrollContentSizeHeight = contentSize.height
        let bottomInset = contentInset.bottom
        let scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViewHeight
        return scrollViewBottomOffset
    }
}
