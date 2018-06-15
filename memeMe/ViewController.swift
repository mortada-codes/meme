//
//  ViewController.swift
//  memeMe
//
//  Created by mahmoud mortada on 6/14/18.
//  Copyright © 2018 mahmoud mortada. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var imageViewMeme: UIImageView!
    
    @IBOutlet weak var navigator: UINavigationBar!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var bottomButtons: UIStackView!
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        cameraButton.isEnabled  = UIImagePickerController.isSourceTypeAvailable(.camera)
    subscribeToKeyboardNotification()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        topTextField.defaultTextAttributes = self.memeTextDefaultAttributes
        bottomTextField.defaultTextAttributes = memeTextDefaultAttributes
        topTextField.delegate = self
        bottomTextField.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unsubscribeFromKeyboardNotification()
    }

    @IBAction func resetMem(_ sender: Any) {
        imageViewMeme.image = nil
        topTextField.attributedText = NSMutableAttributedString(string:"TOP")
      
        bottomTextField.attributedText = NSMutableAttributedString(string:"BOTTOM")
                }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   
    @IBAction func shareMeme(_ sender: Any) {
        let newMeme = generateMeme()
        let activityController = UIActivityViewController(activityItems: [newMeme], applicationActivities: nil)
        activityController.completionWithItemsHandler =  {(activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            guard completed != true else {
                return
            }
            let meme = Meme(topText: self.topTextField.text!, bottomText: self.topTextField.text!, memeImage: self.imageViewMeme.image!,memeTextImage: newMeme)
            self.saveMeme(meme: meme)
        }
        present(activityController, animated: true ){
            
        }
    }
    @IBAction func showALbum(_ sender: Any) {
        
        let imageController = UIImagePickerController()
        imageController.delegate = self
        imageController.sourceType = .photoLibrary
        present(imageController, animated: true, completion: nil)
    }
    @IBAction func openCamera(_ sender: Any) {
        
        let imageController = UIImagePickerController()
        imageController.delegate = self
        imageController.sourceType = .camera
        present(imageController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image  = info[UIImagePickerControllerOriginalImage]  {
            imageViewMeme.image = image as? UIImage
        }
       dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss(animated: true, completion: nil)
    }
    
}
// keyboard event handler extension
extension ViewController {
    func subscribeToKeyboardNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardwillHide), name: .UIKeyboardWillHide , object: nil)
    }
    func unsubscribeFromKeyboardNotification(){
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification){
        if topTextField.isEditing == true {
            view.frame.origin.y = getKeyboardHeight(notification)
        }else if bottomTextField.isEditing == true{
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
        
    }
    
    @objc func keyboardwillHide(_ notification: Notification){
        view.frame.origin.y = 0
    }
    
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo  = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
}

// text delegate  extension
extension ViewController : UITextFieldDelegate {
    
    var memeTextDefaultAttributes :[String:Any] { get { return [
        NSAttributedStringKey.font.rawValue:UIFont(name: "HelveticaNeue", size: 60)!,
        NSAttributedStringKey.strokeColor.rawValue: UIColor.green,
        NSAttributedStringKey.strokeWidth.rawValue: 3,
    NSAttributedStringKey.foregroundColor.rawValue: UIColor.blue,
   ]}
    }
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    textField.allowsEditingTextAttributes = true
        textField.attributedText = NSMutableAttributedString(string:"")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        
    }
    
}
// meme Struct
struct Meme {
    var topText:String
    var bottomText:String
    var memeImage: UIImage
    var memeTextImage: UIImage
}

// meme generatation extension
extension ViewController {
    
    func hideHeaderAndFooter(isHidden: Bool,withDuration:Double){
        
        UIView.animate(withDuration: withDuration){
            self.navigator.isHidden = isHidden
            
        }
        UIView.animate(withDuration: withDuration){
            
            self.bottomButtons.isHidden = isHidden
        }
       
    }
    
    func generateMeme() -> UIImage{
        hideHeaderAndFooter(isHidden: true,withDuration: 0.0)
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        hideHeaderAndFooter(isHidden: false,withDuration: 0.7)
        return image
    }
    
    func saveMeme(meme: Meme){
         let image = meme.memeTextImage
            if let data = UIImagePNGRepresentation(image){
                let path = getDirectory()
                try? data.write(to: path)
            }
        
    }
    func getDirectory() -> URL{
        var url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        url.appendPathComponent("meme\(Date().timeIntervalSince1970).png", isDirectory: false)
        return url
    }
}
