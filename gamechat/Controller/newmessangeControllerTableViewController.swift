//
//  newmessangeControllerTableViewController.swift
//  gamechat
//
//  Created by eric on 2019/1/19.
//  Copyright © 2019 eric. All rights reserved.
//

import UIKit
import Firebase

class newmessangeControllerTableViewController: UITableViewController {
    
    let cellid = "cellId"
    
    var users = [User]()
    
    override func viewDidLoad() {
        //print("test")
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        self.tableView.register(UserCell.self, forCellReuseIdentifier: cellid)
        fetchUser()
    }
    
    @objc func fetchUser(){
        //var ref: DatabaseReference!
        
        //ref = Database.database().reference()
        //let uid = Auth.auth().currentUser?.uid;
 Database.database().reference().child("users").observe(.childAdded, with: {(snapshot) in
    //print(snapshot)
    if let dictionary = snapshot.value as?[String: AnyObject]{
        //print(dictionary)
        let user = User()
        user.id = snapshot.key
            //user.set
        //let email = dictionary["email"]
        //let name = dictionary["name"]
        //print(email)
        //print(name)
            user.setValuesForKeys(dictionary)
        
        //print(user.name,user.email)
            self.users.append(user)
            //user.setValue(dictionary)
            //user.setValuesForKeys(dictionary)
            //if you user the setter ,your app will crash id your class properties don't exactly match up with firebase dictionary keys
        //user.setValuesForKeys(dictionary)
       // self.users.append(user)
            DispatchQueue.main.async {
                self.tableView.reloadData()
                
            }
        //self.users.append(user)
        }
    
        }, withCancel: nil)
    }
    
    @objc func handleCancel(){
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellid);
        //
        //會在tableview cell下滑時 deque cell 這樣就只要 創建一個視窗的cell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath) as! UserCell
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        //cell.imageView?.image = UIImage(named: "joker")
        //cell.imageView?.contentMode = .scaleAspectFill
        if let profileImageUrl = user.profileImageUrl{
            cell.profileImageview.loadImageUsingCacheUrlString(urlString: profileImageUrl)
        }
        //cell.textLabel?.text = "hello"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    var messagesController: MessangeController?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true, completion:nil)
        print("dismiss completed")
        let user = self.users[indexPath.row]
        self.messagesController?.showChatControllerForuser(user: user)
    }
}




class UserCell: UITableViewCell{
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect.init(x: 64, y: textLabel!.frame.origin.y-2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect.init(x: 64, y: detailTextLabel!.frame.origin.y+2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
    }
    
    let profileImageview: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(named:"joker")
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.layer.cornerRadius = 24
        imageview.layer.masksToBounds = true
        imageview.contentMode = .scaleAspectFill
        return imageview
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)

        addSubview(profileImageview)
        
        profileImageview.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageview.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageview.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageview.heightAnchor.constraint(equalToConstant: 48).isActive = true
            }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:)has not been implemented")
    }
}
