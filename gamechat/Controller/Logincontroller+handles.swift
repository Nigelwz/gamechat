//
//  Logincontroller+handles.swift
//  gamechat
//
//  Created by eric on 2019/1/26.
//  Copyright © 2019 eric. All rights reserved.
//

import UIKit
import Firebase



extension loginViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    
    @objc func handleSelectProfileImageView(){
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        
        
        //present(picker, animated: true,completion: :nil)
    }
    
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        
        //要加 as? UIImage 不然會報錯。會沒有 .size 的成員
        if let editimage = info[.editedImage] as? UIImage{
            selectedImageFromPicker = editimage
            //print(editimage.size)
        }else if let originalimage = info[.originalImage] as? UIImage{
            selectedImageFromPicker = originalimage
            //print(originalimage.size)
        }
        if let selectedImage = selectedImageFromPicker{
            profileimageview.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    @objc func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("cancle picker")
    }
    
    private func registerUserIntoDatabasewithUID(uid:String,value:[String: AnyObject]){
        let ref = Database.database().reference(fromURL: "https://gameofchat-2d688.firebaseio.com/")
        let usersReference = ref.child("users").child(uid)
        
        usersReference.updateChildValues(value, withCompletionBlock: {(err,ref)in
            if err != nil{
                //print(err)
                return
            }
            
            //self.MessangeController?.fetchuserAndSetupNavBarTitle()
            self.MessangeController?.navigationItem.title = value["name"]as? String
            self.dismiss(animated: true, completion: nil)
            print("sucess save to firebase")
        })
    }
    
    
    @objc func handleRegister(){
        guard let email = emailTextfild.text,let password = passwordTextfild.text,let name = nameTextfild.text else{
            print("email is not valid")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            // [START_EXCLUDE]
            // guard let user = authResult?.user else { return }
            if error != nil{
                print("user   error")
                //print(error)
                return
            }
            
            guard let uid = authResult?.user.uid else{
                return
            }
            // [END_EXCLUDE]
            
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("profile_image").child("\(imageName).jpg")
            //profileimageview.image?.pngData()
            if let uploadData = self.profileimageview.image?.jpegData(compressionQuality: 0.1){
            
           // if let uploadData = self.profileimageview.image!.pngData(){
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata,error) in
                    if error != nil{
                        print(error as Any)
                        return
                    }
                    
                    
                    storageRef.downloadURL(completion: {(url,error) in
                        if error != nil {
                            print(error!.localizedDescription)
                            return
                        }
                        if let profileImageUrl = url?.absoluteString{
                            let value = ["name":name,"email":email,"profileImageUrl":profileImageUrl]
                            self.registerUserIntoDatabasewithUID(uid: uid, value: value as [String : AnyObject])
                            
                        }
                    })
                   
                    
                    //print(metadata as Any)
                    
                })
            }
            
            
            //ref.child("users/\(user.uid)/username").setValue(username)
            //guard let user = authResult?.user else { return }
        }
    }
}
