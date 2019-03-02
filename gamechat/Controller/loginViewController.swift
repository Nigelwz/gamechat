//
//  loginViewController.swift
//  gamechat
//
//  Created by eric on 2019/1/12.
//  Copyright © 2019 eric. All rights reserved.
//

import UIKit
import Firebase

class loginViewController: UIViewController {

    var MessangeController: MessangeController?
    
    let inputContainerview: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    
    let loginregisterbutton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor=UIColor(r:80,g:101,b:161)
        button.setTitle("Register", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        button.addTarget(self, action: #selector(handleloginRegister), for: .touchUpInside)
        return button
    }()
    
    @objc func handleloginRegister(){
        if loginRegisterSegmentedcontrol.selectedSegmentIndex == 0{
            handleloginIn()
        }else{
            handleRegister()
        }
    }
    @objc func handleloginIn(){
        guard let email = emailTextfild.text,let password = passwordTextfild.text else{
            print("form is not valid")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password, completion:
            {(user,error)in
                if error != nil{
                   // print(error)
                    return
                }
                self.MessangeController?.fetchuserAndSetupNavBarTitle()
                self.dismiss(animated: true, completion: nil)
                
                print("sucesss log in")
        })
    }
    
    
    let nameTextfild : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        
        return tf
    }()
    let nameSeprateview: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r:220,g:220,b:220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let emailTextfild : UITextField = {
        let tf = UITextField()
        tf.placeholder = "email"
        tf.translatesAutoresizingMaskIntoConstraints = false
        
        return tf
    }()
    let emailSeprateview: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r:220,g:220,b:220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let passwordTextfild : UITextField = {
        let tf = UITextField()
        tf.placeholder = "password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        return tf
    }()
    
    lazy var profileimageview: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(named: "joker")
        imageview.translatesAutoresizingMaskIntoConstraints = false
        
        imageview.addGestureRecognizer(UITapGestureRecognizer(target:self,action: #selector(handleSelectProfileImageView)))
        
        imageview.isUserInteractionEnabled = true
        return imageview
    }()
    
    
    
    let loginRegisterSegmentedcontrol: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login","Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor.white
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleLoginRegisterchange), for: .valueChanged)
        return sc
    }()
    
    @objc func handleLoginRegisterchange(){
        let title = loginRegisterSegmentedcontrol.titleForSegment(at: loginRegisterSegmentedcontrol.selectedSegmentIndex)
        loginregisterbutton.setTitle(title, for: .normal)
        
        inputconsraintviewHeightAnchor?.constant = loginRegisterSegmentedcontrol.selectedSegmentIndex == 0 ? 100:150
        
        nametextfieldconsraintviewHeightAnchor?.isActive = false
        nametextfieldconsraintviewHeightAnchor = nameTextfild.heightAnchor.constraint(equalTo: inputContainerview.heightAnchor, multiplier: loginRegisterSegmentedcontrol.selectedSegmentIndex == 0 ? 0 :1/3)
        nametextfieldconsraintviewHeightAnchor?.isActive = true
        
        emailconsraintviewHeightAnchor?.isActive = false
        emailconsraintviewHeightAnchor = emailTextfild.heightAnchor.constraint(equalTo: inputContainerview.heightAnchor, multiplier: loginRegisterSegmentedcontrol.selectedSegmentIndex == 0 ? 1/2 :1/3)
        emailconsraintviewHeightAnchor?.isActive = true
        
        passwordconsraintviewHeightAnchor?.isActive = false
        passwordconsraintviewHeightAnchor = passwordTextfild.heightAnchor.constraint(equalTo: inputContainerview.heightAnchor, multiplier: loginRegisterSegmentedcontrol.selectedSegmentIndex == 0 ? 1/2 :1/3)
        passwordconsraintviewHeightAnchor?.isActive = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(r:61,g:91,b:151)
        
        view.addSubview(inputContainerview)
        view.addSubview(loginregisterbutton)
        view.addSubview(profileimageview)
        view.addSubview(loginRegisterSegmentedcontrol)
        setupInputContainerView()
        setupLoginRegisterView()
        setupimageview()
        setuploginRegisterSegmentcontrol()

    }
    
    func setuploginRegisterSegmentcontrol(){
        loginRegisterSegmentedcontrol.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentedcontrol.bottomAnchor.constraint(equalTo: inputContainerview.topAnchor, constant: -12).isActive = true
        loginRegisterSegmentedcontrol.widthAnchor.constraint(equalTo: inputContainerview.widthAnchor).isActive = true
        loginRegisterSegmentedcontrol.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    
    var inputconsraintviewHeightAnchor: NSLayoutConstraint?
    var nametextfieldconsraintviewHeightAnchor: NSLayoutConstraint?
    var emailconsraintviewHeightAnchor: NSLayoutConstraint?
    var passwordconsraintviewHeightAnchor: NSLayoutConstraint?
    
    func setupInputContainerView() {
        inputContainerview.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputContainerview.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputContainerview.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive=true
        
        inputconsraintviewHeightAnchor = inputContainerview.heightAnchor.constraint(equalToConstant: 150)
        inputconsraintviewHeightAnchor?.isActive=true
        //inputContainerview.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        //textfield
        inputContainerview.addSubview(nameTextfild)
        inputContainerview.addSubview(nameSeprateview)
        inputContainerview.addSubview(emailTextfild)
        inputContainerview.addSubview(emailSeprateview)
         inputContainerview.addSubview(passwordTextfild)
        nameTextfild.leftAnchor.constraint(equalTo: inputContainerview.leftAnchor, constant: 12).isActive = true
        nameTextfild.topAnchor.constraint(equalTo: inputContainerview.topAnchor).isActive = true
        nameTextfild.widthAnchor.constraint(equalTo: inputContainerview.widthAnchor).isActive = true
        
        nametextfieldconsraintviewHeightAnchor = nameTextfild.heightAnchor.constraint(equalTo: inputContainerview.heightAnchor, multiplier: 1/3)
        nametextfieldconsraintviewHeightAnchor?.isActive = true
        //nameTextfild.heightAnchor.constraint(equalTo: inputContainerview.heightAnchor, multiplier: 1/3).isActive = true
        
        nameSeprateview.leftAnchor.constraint(equalTo: inputContainerview.leftAnchor).isActive = true
        nameSeprateview.topAnchor.constraint(equalTo: nameTextfild.bottomAnchor).isActive = true
        nameSeprateview.widthAnchor.constraint(equalTo: inputContainerview.widthAnchor).isActive = true
        nameSeprateview.heightAnchor.constraint(equalToConstant: 1).isActive = true
    
        emailTextfild.leftAnchor.constraint(equalTo: inputContainerview.leftAnchor, constant: 12).isActive = true
        emailTextfild.topAnchor.constraint(equalTo: nameTextfild.bottomAnchor).isActive = true
        emailTextfild.widthAnchor.constraint(equalTo: inputContainerview.widthAnchor).isActive = true
        emailconsraintviewHeightAnchor = emailTextfild.heightAnchor.constraint(equalTo: inputContainerview.heightAnchor, multiplier: 1/3)
        emailconsraintviewHeightAnchor?.isActive = true
        //emailTextfild.heightAnchor.constraint(equalTo: inputContainerview.heightAnchor, multiplier: 1/3).isActive = true
        
       emailSeprateview.leftAnchor.constraint(equalTo: inputContainerview.leftAnchor).isActive = true
        emailSeprateview.topAnchor.constraint(equalTo: emailTextfild.bottomAnchor).isActive = true
        emailSeprateview.widthAnchor.constraint(equalTo: inputContainerview.widthAnchor).isActive = true
        emailSeprateview.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        passwordTextfild.leftAnchor.constraint(equalTo: inputContainerview.leftAnchor, constant: 12).isActive = true
        passwordTextfild.topAnchor.constraint(equalTo: emailTextfild.bottomAnchor).isActive = true
        passwordTextfild.widthAnchor.constraint(equalTo: inputContainerview.widthAnchor).isActive = true
        passwordconsraintviewHeightAnchor = passwordTextfild.heightAnchor.constraint(equalTo: inputContainerview.heightAnchor, multiplier: 1/3)
        
        passwordconsraintviewHeightAnchor?.isActive = true
        //passwordTextfild.heightAnchor.constraint(equalTo: inputContainerview.heightAnchor, multiplier: 1/3).isActive = true
    }
    
    func setupLoginRegisterView() {
        loginregisterbutton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginregisterbutton.topAnchor.constraint(equalTo: inputContainerview.bottomAnchor, constant: 12).isActive = true
        loginregisterbutton.widthAnchor.constraint(equalTo: inputContainerview.widthAnchor).isActive = true
        loginregisterbutton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    func setupimageview(){
        profileimageview.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileimageview.bottomAnchor.constraint(equalTo: loginRegisterSegmentedcontrol.topAnchor, constant: -12).isActive = true
        profileimageview.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileimageview.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }


}


extension UIColor{
    convenience init(r: CGFloat,g:CGFloat,b:CGFloat) {
        self.init(red: r/255,green: g/255,blue: b/255,alpha:1)
    }
}
