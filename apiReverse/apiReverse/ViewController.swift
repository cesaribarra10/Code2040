//
//  ViewController.swift
//  apiReverse
//
//  Created by Cesar Ibarra on 9/11/16.
//  Copyright © 2016 Cesar Ibarra. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        callAPI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func performPostRequest(element: String) {
        let urlString = "http://challenge.code2040.org/api/reverse/validate"
        guard let url = URL(string: urlString) else {return}
        let session = URLSession.shared
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        let jsonData: [String:String] = [
            "token":"feb11791f036dc3f2ea5c1f39e41df63",
            "string": "\(element)"
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
            
        }
        task.resume()
    }
    
    private func reverseWord(word: String) -> String {
        return String(word.characters.reversed())
    }
    
    private func callAPI() {
        let urlString = "http://challenge.code2040.org/api/reverse"
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
        let task = session.dataTask(with: request as URLRequest) { [unowned self] (data, response, error) in
            if error == nil {
                guard let responseReceived = response as? HTTPURLResponse else {return}
                print(responseReceived)
                guard let dataReceived = data else {return}
                guard let stringToReverse = String(data: dataReceived, encoding: String.Encoding.utf8) else {return}
                let stringToSendBack = self.reverseWord(word: stringToReverse)
                self.performPostRequest(element: stringToSendBack)
            }
        }
        task.resume()
    }
}
