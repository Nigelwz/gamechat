//
//  ViewController.swift
//  gamechat
//
//  Created by eric on 2019/1/12.
//  Copyright © 2019 eric. All rights reserved.
//

import UIKit
import Firebase

class MessangeController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //var ref: DatabaseReference!
        
        //ref = Database.database().reference(fromURL: "https://gameofchat-2d688.firebaseio.com/")
        
        //ref.updateChildValues(["somevalue":123123])
        //ref.child("users/\(user.uid)/username").setValue(username)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style:.plain , target: self, action: #selector(handleLogout))
        
        //不加?.withRenderingMode(.alwaysOriginal) 圖會變藍色色塊
        let image = UIImage(named: "addmessange.png")?.withRenderingMode(.alwaysOriginal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handlenewmessange))
        
        checkifuserisloggedin()
        
        observeMessanges()
        
        }
    
    var messages = [Message]()
    
    @objc func observeMessanges(){
            let ref = Database.database().reference().child("Messange")
        ref.observe(.childAdded, with: {(snapshot) in
            if let dictionary = snapshot.value as?[String:AnyObject]{
                let message = Message()
                //message.setValuesForKeys(dictionary)
                //print(message.text)
                message.setValuesForKeys(dictionary)
                //print(message.text as Any)
                self.messages.append(message)
                print(message.text as Any)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }, withCancel: nil)
        //ref.observeSingleEvent(.childAdded, with: {(snapshot) in
            
            
          //  }, withCancel: nil)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cellId")
        let message = messages[indexPath.row]
        cell.textLabel?.text = message.toId
        cell.detailTextLabel?.text = message.text
        return cell
        //cell.textLabel?.makeTextWritingDirectionLeftToRight(<#T##sender: Any?##Any?#>)
    }
    
    
    @objc func handlenewmessange(){
        let newmessangecontrol = newmessangeControllerTableViewController()
        newmessangecontrol.messagesController = self
        let navController = UINavigationController(rootViewController: newmessangecontrol)
        present(navController, animated: true, completion: nil)
    }
    
    @objc func checkifuserisloggedin() {
        if Auth.auth().currentUser?.uid == nil{
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }else{
           fetchuserAndSetupNavBarTitle()
        }
    }
    
    @objc func fetchuserAndSetupNavBarTitle(){
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        
        
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: {(snapshot)  in
            if let dictionary = snapshot.value as? [String:AnyObject]{
                //self.navigationItem.title = dictionary["name"] as?String
                
                let user = User()
                user.setValuesForKeys(dictionary)
                self.setNavBarWithUser(user: user)
            }
        }, withCancel: nil)
    }
    
    @objc func setNavBarWithUser(user: User){
        #if false
        let titleView = UIView()
        //titleView.translatesAutoresizingMaskIntoConstraints = false
        
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        titleView.backgroundColor = UIColor.red


        
        //let profileImageView = UIView()
        let profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        if let profileImageUrl = user.profileImageUrl{
          profileImageView.loadImageUsingCacheUrlString(urlString: profileImageUrl)
        }
        titleView.addSubview(profileImageView)
        //set profileImageView layout
        profileImageView.leftAnchor.constraint(equalTo: titleView.leftAnchor).isActive = true
        //profileImageView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor, constant: 0).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        //profileImageView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor)
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        //titleView.bringSubviewToFront(profileImageView)
        
        self.navigationItem.titleView = titleView
        //titleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showChatController)))
        //titleView.isUserInteractionEnabled = true
        //self.navigationItem.title = user.name
        #endif
        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 130, height: 45)
        //titleView.backgroundColor = UIColor.red
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        //containerView.backgroundColor = UIColor.red
        self.navigationItem.titleView = titleView
        
        titleView.addSubview(containerView)
        
        containerView.topAnchor.constraint(equalTo: titleView.topAnchor, constant: 0).isActive = true
        containerView.bottomAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 0).isActive = true
        containerView.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: 0).isActive = true
        containerView.trailingAnchor.constraint(equalTo: titleView.trailingAnchor, constant: 0).isActive = true
        
        let profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        
        if let profileImageUrl = user.profileImageUrl {
            profileImageView.loadImageUsingCacheUrlString(urlString: profileImageUrl)
        }
        
        titleView.addSubview(profileImageView)
        
        profileImageView.leftAnchor.constraint(equalTo: titleView.leftAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 35).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        let nameLabel = UILabel()
        
        containerView.addSubview(nameLabel)
        
        nameLabel.text = user.name
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        self.navigationItem.titleView = titleView
        
        //titleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showChatController)))
       // titleView.isUserInteractionEnabled = true
    }
    
    @objc func showChatControllerForuser(user:User){
        
        let chatLogcontroller = Chatlogcontroller.init(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogcontroller.user = user
        navigationController?.pushViewController(chatLogcontroller, animated: true)
        //print("123")
    }
    
    @objc func handleLogout() {
        
        
        do{
            try Auth.auth().signOut()
        }catch let logoutError{
            print(logoutError)
        }
        let loginController = loginViewController()
        //eric?
        loginController.MessangeController = self
        present(loginController, animated: true, completion: nil)

    }

}

