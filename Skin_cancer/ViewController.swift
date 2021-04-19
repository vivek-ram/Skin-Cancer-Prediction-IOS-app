//
//  ViewController.swift
//  Skin_cancer
//
//  Created by Vivek D on 26/03/2021.
//

import UIKit


class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var SelectPhoto: UIButton!
    
    @IBOutlet weak var prediction: UILabel!
    
    var photo : UIImage!
    
   public var out = String()
    var dis = String()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    
    
    
// selecting photo library
    @IBAction func didTapButton() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary //to change camera .camera
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
    
    
    @IBAction func Post(_ sender: UIButton) {
    

    }
    
    
    @IBAction func sendserver(_ sender: UIButton) {
        DispatchQueue.global(qos: .background).async {
            self.img_pre(image: self.photo){ [self] (output) in
                DispatchQueue.main.async { [self] in

                    
//                    print(output)
                    out = output
                    let tempo = convertStringToDictionary(text: out)
                    dis = tempo?["prediction"] as! String
                    self.prediction.text = dis

                    
//                    print("first : \(out)")
                    
                    self.performSegue(withIdentifier: "segue", sender: out)
                    
                    
                }
                
                
            }
            
            
        }
        
    }
    
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue"{
            let destinationController = segue.destination as! SecondViewController
            let py = convertStringToDictionary(text: out)
            let name = py?["prediction"] as! String
            let po = py?["probability"] as! String
            

            destinationController.predtext = py?["prediction"] as! String
            destinationController.probtext = po
            destinationController.info = information(name: name)

        }


    }
    
    
    public func information(name: String) -> String {

         var one = String()
         if name == "Bowen’s disease"{
              one = " Bowen's disease is a common squamous cell carcinoma of the skin in situ. In situ refers to the fact that tumor cells are confined to the epidermis, so it is a very early skin malignant tumor with good therapeutic effect."
         } else if name == "Basal cell carinoma"{
             one = "Basal cell tumor, also known as moth ulcer, is the most common type of skin cancer. The incidence rate is very high, accounting for the first place in eyelid malignancies (about 50%). There are slightly more males than females, and the elderly are more common than the young. The peak age is between 50 and 60 years old. The characteristic lesions were round plaques with pearl like protuberant margin, with capillary dilation on the surface and gradually enlarged lesions."
         }else if name == "benign keratosis" {
             one = "Seborrheic keratosis is the most common benign skin tumor. It is mainly seen in adults over 40 years old. The incidence rate increases with age. It is also known as senile wart and senile plaque, also known as basal cell papilloma."

         }else if name == "dermatofibroma" {
             one = "Dermatofibroma is a benign dermal tumor caused by focal proliferation of fibroblasts or histiocytes. The disease can occur at any age, more common in young and middle-aged, female than male. It can occur naturally or after trauma."

         }else if name == "melanoma" {
             one = "Melanoma, usually referred to as malignant melanoma, is a kind of highly malignant tumor derived from melanocytes. It mostly occurs in the skin, but also in the mucosa and viscera, accounting for about 3% of all tumors. Skin malignant melanoma is the third most common skin malignant tumor (about 6.8% ~ 20%)."

         }else if name == "melanocytic nevi" {
             one = "Nevus is produced by a group of benign melanocytes, which gather at the junction of epidermis and dermis.Melanin cells may be distributed in the lower part of reticular dermis, between connective tissue bundles, around other accessory organs of the skin, such as sweat glands, hair follicles, blood vessels, nerves, etc., and occasionally extend to subcutaneous fat."

         }else if name == "vascular lesions" {
             one = "Skin vascular disease refers to the disease involving the skin vascular wall, vascular damage and abnormalities, the most important is vasculitis. The damage can be limited to the skin, but in many cases it is the manifestation of systemic disease involving other organs."

         }
     
     
         return one
     }
    
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
       if let data = text.data(using: .utf8) {
           do {
               let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
               return json
           } catch {
               print("Something went wrong")
           }
       }
       return nil
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

