//
//  ViewController.swift
//  Needle_In_Haystack
//
//  Created by Cesar Ibarra on 9/11/16.
//  Copyright © 2016 Cesar Ibarra. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        receiveAPIInfo()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func postAPIData(location: Int) {
        let urlString = "http://challenge.code2040.org/api/haystack/validate"
        guard let url = URL(string: urlString) else {return}
        let session = URLSession.shared
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        let jsonData: [String:String] = [
            "token":"feb11791f036dc3f2ea5c1f39e41df63",
            "needle":"\(location)"
        ]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: jsonData, options: .prettyPrinted)
        } catch {
            print("there was an error parsing json")
        }
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            if error == nil {
                if let responseReceived = response as? HTTPURLResponse {
                    print(responseReceived)
                }
            }
        }
        task.resume()

    }
    
    private func findNeedleIndex(haystack: NSArray, needle: String) -> Int{
        for word in haystack {
            if needle == word as? String {
                return haystack.index(of: word)
            }
        }
        return 0
    }
    
    private func receiveAPIInfo() {
        let urlString = "http://challenge.code2040.org/api/haystack"
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
        
        let task = session.dataTask(with: request as URLRequest) { [unowned self](data, response, error) in
            if error == nil {
                guard let responseReceived = response as? HTTPURLResponse else {return}
                print(responseReceived)
                do {
                    guard let dataReceived = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:AnyObject] else {return}
                    print(dataReceived)
                    guard let haystack = dataReceived["haystack"] as? NSArray else {return}
                    print(haystack)
                    guard let needle = dataReceived["needle"] as? String else {return}
                    print(needle)
                    let index = self.findNeedleIndex(haystack: haystack, needle: needle)
                    self.postAPIData(location: index)
                    
                    
                } catch {
                    print("conversion failed")
                }
            }
        }
        task.resume()
    }

}

