//
//  ViewController.swift
//  ImageDetector
//
//  Created by JOHN KENNY on 01/10/2017.
//  Copyright © 2017 JOHN KENNY. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController {
    
    
    @IBOutlet var result: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func detectBtns(_ sender: Any) {
        //get the button pressed
        if let button = sender as? UIButton{
            //get the tag to identify the button pressed
            let tag = button.tag
            
            //get the image using the tag as images are named to match the tag 0 -5
            guard let image = UIImage(named: "\(tag)") else {
                return
            }
            getImage(image: image)
            print (tag)
            
            
        }
    }
    
    //get the image by name
    
    func getImage(image : UIImage){
        result.text = "Please wait.."
        //set up the model
        guard let model = try? VNCoreMLModel(for: GoogLeNetPlaces().model) else{
            return
        }
        //create a vision request
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else{
                return
            }
            //examine convidence level
            for result in results{
                print("\(result.identifier) and confidence level \(result.confidence * 100)")
            }
            let firstResult = results.first
            print("here i am")
            //update text lable when async thread is complete
            DispatchQueue.main.async {
                self.result.text =  firstResult?.identifier
            }
            
        }
        guard let ciImage = CIImage(image: image) else {
            return
        }
        
        //run the google google model here
        
        let handler = VNImageRequestHandler(ciImage: ciImage, options: [ : ])
        
        //create a bg thread
        DispatchQueue.global().async {
            do{
                try handler.perform([request])
                
            }catch{
                print(error)
            }
        }
    }
    
}

