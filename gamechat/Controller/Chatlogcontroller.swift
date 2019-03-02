//
//  chatlogcontroller.swift
//  gamechat
//
//  Created by eric on 2019/2/17.
//  Copyright © 2019 eric. All rights reserved.
//

import UIKit
import Firebase

class Chatlogcontroller: UICollectionViewController,UITextFieldDelegate{
    var user:User?{
        didSet{
            navigationItem.title = user?.name
        }
    }
    
    
    lazy var inputTextField:UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Enter messange ..."
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.delegate = self//eric?
        return textfield
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()//eric?
        
        //navigationItem.title = "chat Log Controller"
        
        collectionView?.backgroundColor = UIColor.white
        setupinputomponents()
    }
    @objc func setupinputomponents(){
        let containview = UIView()
        containview.backgroundColor = UIColor.white
        containview.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containview)
        
        containview.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containview.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containview.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containview.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        containview.addSubview(sendButton)
        
        sendButton.rightAnchor.constraint(equalTo: containview.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containview.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containview.heightAnchor).isActive = true
        sendButton.addTarget(self, action: #selector(handlesend), for: .touchUpInside)
        
        containview.addSubview(inputTextField)
        
        inputTextField.leftAnchor.constraint(equalTo: containview.leftAnchor, constant: 8).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: containview.centerYAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containview.heightAnchor)
        
        let seprateline = UIView()
        seprateline.backgroundColor = UIColor.init(r: 220, g: 220, b: 220)
        containview.addSubview(seprateline)
        seprateline.translatesAutoresizingMaskIntoConstraints = false
        seprateline.topAnchor.constraint(equalTo: inputTextField.topAnchor).isActive = true
        seprateline.widthAnchor.constraint(equalTo: containview.widthAnchor).isActive = true
        seprateline.leftAnchor.constraint(equalTo: containview.leftAnchor).isActive = true
        seprateline.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    
    @objc func handlesend(){
        let ref = Database.database().reference().child("Messange")
        let childref = ref.childByAutoId()
        let toId = user!.id!
        let fromId = Auth.auth().currentUser!.uid
        let timestamp = NSDate().timeIntervalSince1970
        //let value : [AnyHashable: Any] = ["text":inputTextField.text!,"name": user!.name as Any]
        
        let value : [AnyHashable: Any] = ["text":inputTextField.text!,"toId": toId,"fromId":fromId,"timestamp":timestamp]
        childref.updateChildValues(value as [AnyHashable : Any])
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handlesend()
        
        return true
    }
}


