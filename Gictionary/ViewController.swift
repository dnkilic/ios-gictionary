//
//  ViewController.swift
//  Gictionary
//
//  Created by Doğan Kılıç on 13/04/2017.
//  Copyright © 2017 Doğan Kılıç. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var ilkDil = ["eng","tur","pol","de"]
    var ikinciDil = ["eng","tur","pol","de"]
    var fromStr:String = ""
    var destStr:String = ""
    var secilen1 = -1
    var secilen2 = -1
    
    var myPickerView : UIPickerView = UIPickerView.init()
    
    
    @IBOutlet weak var phrase: UITextField!
    
    @IBOutlet weak var translationResult: UITextView!
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var pickerview: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
        //pickerview.reloadAllComponents()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named:"background")!)
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0
        {return ilkDil.count}
        
        else
        { return ikinciDil.count}
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 0
        {
            return ilkDil[row]
        }
        else
        {return ikinciDil[row]}
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            secilen1 = row
            fromStr=ilkDil[row]
        }
        
        else{
        secilen2 = row
            destStr = ikinciDil[row]
        }
    }
    
    @IBAction func translate(_ sender: Any) {
        
        var phraseStr = phrase.text!
        
        var base = "https://glosbe.com/gapi/translate?from=\(fromStr)&dest=\(destStr)&format=json&phrase=\(phraseStr)&pretty=true"
        
        let stringUrl = URL.init(string: base)
        
        if let url = stringUrl {
            
            let task = URLSession.shared.dataTask(with: url, completionHandler: {
                (data, response, error) in
                
                if(error == nil)
                {
                    if let usableData = data
                    {
                        let json = try! JSONSerialization.jsonObject(with: usableData, options: []) as! [String:Any]
                        
                        if let tuc = json["tuc"] as! [Any]?
                        {
                            var resultStr = ""
                            
                            for element in 0..<tuc.count
                            {
                                var obj = tuc[element] as! [String:Any]
                                if let phrase = obj["phrase"] as! [String:String]?
                                {
                                    if let text = phrase["text"]
                                    {
                                        resultStr = "\(resultStr)\n\(text)"

                                    }
                                    else
                                    {}
                                }
                                else
                                {}
                            }
                        
                            
                            DispatchQueue.main.sync(execute: {
                                print("deneme")
                                
                                self.deneme(resultStr)
                                
                                
                                
                                
                               self.translationResult.text = resultStr
                              
                            })
                            
                            
                            DispatchQueue.main.async(execute: {
                                self.translationResult.text = resultStr
                              
                            })
                        }
                        else
                        {
                            //tuc boş
                        }
                    }
                    else
                    {
                        //data boş nil
                    }
                }
                else
                {
                    // Error var!
                }
            })
            task.resume()
        }
        else
        {
           //URL yanlış
        }
    }
    
    func deneme (_ str:String)
    {
        translationResult.text = str
    }
    
    
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

