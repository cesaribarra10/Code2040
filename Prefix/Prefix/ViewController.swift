//
//  ViewController.swift
//  Prefix
//
//  Created by Cesar Ibarra on 9/11/16.
//  Copyright © 2016 Cesar Ibarra. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getDictionary()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func postArray(array: NSMutableArray) {
        let urlString = "http://challenge.code2040.org/api/prefix/validate"
        guard let url = URL(string: urlString) else {return}
        let session = URLSession.shared
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        print(array.description)
        let jsonData: [String:AnyObject] = [
            "array":array,
            "token":"feb11791f036dc3f2ea5c1f39e41df63" as AnyObject
        ]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: jsonData, options: .prettyPrinted)
        } catch {
            print("there was an error parsing json")
        }
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            if error == nil {
                guard let responseReceived = response as? HTTPURLResponse else {return}
                print(responseReceived)
            }
            if error != nil {
                print(error?.localizedDescription)
            }
        }
        task.resume()
    }
    
    private func returnArray(prefix: String, array: NSArray) -> NSMutableArray {
        let mutableArray = NSMutableArray(array: array)
        for word in mutableArray {
            let wordStr = word as? String
            if (wordStr?.contains(prefix))! {
                mutableArray.remove(word)
            }
        }
        print(mutableArray)
        return mutableArray
    }

    private func getDictionary() {
        let urlString = "http://challenge.code2040.org/api/prefix"
        guard let url = URL(string: urlString) else {return}
        let session = URLSession.shared
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        let jsonData: [String:String] = [
            "token":"feb11791f036dc3f2ea5c1f39e41df63"
        ]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: jsonData, options: .prettyPrinted)
        } catch {
            print("there was an error parsing json")
        }
        
        let task = session.dataTask(with: request as URLRequest) { [unowned self] (data , response, error) in
            if error == nil {
                guard let responseReceived = response as? HTTPURLResponse else {return}
                print(responseReceived)
                do {
                    guard let dataReceived = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary else {return}
                    print(dataReceived)
                    guard let prefix = dataReceived["prefix"] as? String else {return}
                    guard let array = dataReceived["array"] as? NSArray else {return}
                    let arrayToPost = self.returnArray(prefix: prefix, array: array)
                    self.postArray(array: arrayToPost)
                    
                } catch {
                    print("there was an error parsing the json")
                }
            }
        }
        task.resume()
    }
    
}

