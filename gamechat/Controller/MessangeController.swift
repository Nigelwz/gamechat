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
        
        
        
        }
    @objc func handlenewmessange(){
        let newmessangecontrol = newmessangeControllerTableViewController()
        let navController = UINavigationController(rootViewController: newmessangecontrol)
        present(navController, animated: true, completion: nil)
    }
    
    @objc func checkifuserisloggedin() {
        if Auth.auth().currentUser?.uid == nil{
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }else{
            let uid = Auth.auth().currentUser?.uid
            
            //let ref = Database.database().reference(fromURL: "https://////gameofchat-2d688.firebaseio.com/")
            Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: {(snapshot)  in
                if let dictionary = snapshot.value as? [String:AnyObject]{
                    self.navigationItem.title = dictionary["name"] as?String
                }
            }, withCancel: nil)
        }
    }
    @objc func handleLogout() {
        
        
        do{
            try Auth.auth().signOut()
        }catch let logoutError{
            print(logoutError)
        }
        let loginController = loginViewController()
        
        present(loginController, animated: true, completion: nil)
       // presentedViewController(loginController,dismiss(animated: true, completion: nil))
        //presentedViewController(loginController,animated: true, completion: nil)
        
       // print("helloworld")
    }

}

