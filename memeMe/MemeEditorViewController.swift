//
//  ViewController.swift
//  memeMe
//
//  Created by mahmoud mortada on 6/14/18.
//  Copyright © 2018 mahmoud mortada. All rights reserved.
//

import UIKit


class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    

    @IBOutlet weak var shareButton: UIBarButtonItem!

    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var imageViewMeme: UIImageView!
    
    @IBOutlet weak var navigator: UINavigationBar!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var bottomButtons: UIStackView!

    var memedImage : UIImage?
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        cameraButton.isEnabled  = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotification()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configure(topTextField, with: memeTextDefaultAttributes)
        configure(bottomTextField, with: memeTextDefaultAttributes)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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

        memedImage = generateMeme()
        let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)

        activityController.completionWithItemsHandler =  {(activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            guard completed == true else {
                print(error?.localizedDescription ?? "not completed with no errors")
                return
            }

            self.saveMeme()
        }
        present(activityController, animated: true ){
            
        }
    }
    @IBAction func showALbum(_ sender: Any) {
        
        pickAnImage(from: .photoLibrary)
    }
    @IBAction func openCamera(_ sender: Any) {
        
        
        pickAnImage(from: .camera)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image  = info[UIImagePickerControllerOriginalImage]  {
            imageViewMeme.image = image as? UIImage
            shareButton.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func pickAnImage(from source: UIImagePickerControllerSourceType) {
        // TODO:- code to pick an image from source
        let imageController = UIImagePickerController()
        imageController.delegate = self
        
        imageController.sourceType = source
        present(imageController, animated: true, completion: nil)
    }
    
}
// keyboard event handler extension
extension MemeEditorViewController {
    func subscribeToKeyboardNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardwillHide), name: .UIKeyboardWillHide , object: nil)
    }
    func unsubscribeFromKeyboardNotification(){
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification){
        
        if bottomTextField.isEditing == true{
  
            view.frame.origin.y = getKeyboardHeight(notification) * -1
    
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
extension MemeEditorViewController : UITextFieldDelegate {
    
    var memeTextDefaultAttributes :[String:Any] { get { return [
        NSAttributedStringKey.font.rawValue:UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
        NSAttributedStringKey.strokeWidth.rawValue: -3,
        NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
        ]}
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
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
    

    func configure(_ textField: UITextField, with defaultText: [String:Any]) {
        // TODO:- code to configure the textField
        textField.defaultTextAttributes = memeTextDefaultAttributes
        textField.delegate = self
    }

    
}


// meme generatation extension
extension MemeEditorViewController {
    
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
    
    func saveMeme(){
    
        let meme = Meme(topText: self.topTextField.text!, bottomText: self.topTextField.text!, memeImage: self.imageViewMeme.image!,memeTextImage: memedImage!)
        let delegate =    UIApplication.shared.delegate as! AppDelegate
        delegate.addMeme(meme)
        print("meme saved!!")
    }
    
}

extension UIImagePickerController {
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all   
    }
    
//    func getDirectory() -> URL{
//        var url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        url.appendPathComponent("meme\(Date().timeIntervalSince1970).png", isDirectory: false)
//        return url
//    }
}
