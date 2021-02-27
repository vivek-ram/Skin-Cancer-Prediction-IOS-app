//
//  ViewController.swift
//  SkinCancer
//
//  Created by Vivek D on 25/02/2021.
//

import UIKit
var dict: [String : String] = [:]

class ViewController: UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var button: UIButton!
    
    @IBOutlet weak var answer: UILabel!
    var photo : UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        imageView.backgroundColor = .secondarySystemBackground
        button.backgroundColor = .systemBlue
        button.setTitle("Take Picture", for: .normal)
        button.setTitleColor(.white, for: .normal)
        
    }
    
    @IBAction func didTapButton(){
        
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        present( picker, animated:  true)
                
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        else {
            return
        }
//        imageView.image = image
        photo = image
        
    }
    
    
    @IBAction func click(_ sender: UIButton) {
        DispatchQueue.global(qos: .background).async {
            self.img_pre(image: self.photo){ ( output) in
                print(output)
                DispatchQueue.main.async {
                    print(output)
                   self.answer.text = output
                }
                
                
            }
              
            

        }
        
    }
    
    
    
    public func img_pre(image : UIImage , completionBlock: @escaping (String) -> Void) -> Void{
        let imageData:NSData = image.pngData()! as NSData
        let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
        let url = URL(string: "https://fastapi-skincancer.herokuapp.com/")!
        var request = URLRequest(url: url)
        // Serialize HTTP Body data as JSON
        let body = ["image": strBase64]
        let bodyData = try? JSONSerialization.data(
            withJSONObject: body,
            options: []
        )
        // Change the URLRequest to a POST request
        request.httpMethod = "POST"
        request.httpBody = bodyData
        // Create the HTTP request

        let session = URLSession.shared
            let task = URLSession.shared.dataTask(with: request) {
                (data: Data?, response: URLResponse?, error: Error?) in
                
                if(error != nil) {
                                print("Error: \(error)")
                            }else
                            {

                                let outputStr  = String(data: data!, encoding: String.Encoding.utf8) as String?
                                //send this block to required place
                                completionBlock(outputStr!);
                            }
                        }
                        task.resume()
            
    }
    
    
    
}
    


    





