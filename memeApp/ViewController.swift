//
//  ViewController.swift
//  memeApp
//
//  Created by SH MAC on 2017. 1. 17..
//  Copyright © 2017년 승희. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
  
  
    @IBOutlet weak var TopTextField: UITextField!
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var BtmTextField: UITextField!
    @IBOutlet weak var shareBtn: UIBarButtonItem!
   
    
    struct Meme{
        var topText: String
        var bottomText:String
        var originalImage:UIImage
        var memedImage:UIImage
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let memeTextAttributes:[String:Any] = [
            NSStrokeColorAttributeName: UIColor.black,
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName: -3.5] //양수면 투명하게 나오고 음수면 색나옴
        
        //설정한 memeTextAttributes값을 textField에 할당
        TopTextField.defaultTextAttributes = memeTextAttributes
        BtmTextField.defaultTextAttributes = memeTextAttributes
        
        //textfield값 가운데로
        TopTextField.textAlignment = .center
        BtmTextField.textAlignment = .center
        
        TopTextField.delegate = self
        BtmTextField.delegate = self
        
        //share버튼 비활성화
        shareBtn.isEnabled = false
        
        
    }


    
   //카메라- 시뮬레이터 지원x
    @IBAction private func pickerImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
       

       
    }
    //앨범에서 이미지 선택
    @IBAction func PickAnImageCamera(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        //delegate가 있어야 이미지를 보여줌
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
        
    }
    
  
    
    
    @IBAction func sharedBtn(_ sender: Any) {
       
        let image = generateMemedImage()
        let nextController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
      
        self.present(nextController, animated: true, completion: nil)

    }
    
    //선택한 이미지 보여주기
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
           
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView1.image = image
            shareBtn.isEnabled = true
            dismiss(animated: true, completion: nil)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    //텍스트 필드 작성할때 뷰가 올라가게 하는거. 그렇다면 키보드가 위로 올라가는건 어떻게 알수있을까??답은 NSNotification을 통해 알아
    func keyboardWillShow(_ notification:Notification) {
        //y=0일때 화면 가장 위를 의미함 , 뷰가 키보드보다 위에 있게 하려면 키보드의 높이만큼을 빼주면됨
        if BtmTextField.isFirstResponder{
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(_ notification:Notification){
        view.frame.origin.y = 0
        
    }
    
    
    //여기서 notification은 유저의 정보를 가지고있어
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        print( "keyboardSize값 :\(keyboardSize)")
        print("리턴값:\(keyboardSize.cgRectValue.height)")
        return keyboardSize.cgRectValue.height
        
        
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // Figure out what the new text will be, if we return true
        var newText = textField.text! as NSString
        newText = newText.replacingCharacters(in: range, with: string) as NSString
        
        
        // returning true gives the text field permission to change its text
        return true;
    }
    
    
    
    
    //이벤트가 생기는 알림을 등록해, 여기서 이벤트는 UIKeyboardWillShow
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    // 키보드 알림 해제하는 코드
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
        
        
    }
    
    //리턴키누르면 닫히는 코드
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true;
    }
    

    
    
    //저장
    func save() {
        // Create the meme
        let meme = Meme(topText: TopTextField.text!, bottomText: BtmTextField.text!, originalImage: imageView1.image!, memedImage: generateMemedImage())
    }
   
    
    func generateMemedImage() -> UIImage {
        
        // TODO: Hide toolbar and navbar

        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: false)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        
        // TODO: Show toolbar and navbar
        
        return memedImage
    }
    //textfield 초기값을  빈값으로 주기
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }


    
    
    
}

