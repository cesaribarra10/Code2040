//
//  ViewController.swift
//  Code2040Challenge
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

    func callAPI() {
        let urlString = "http://challenge.code2040.org/api/register"
        guard let url = URL(string: urlString) else {return}
        let session = URLSession.shared
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        let jsonData: [String:AnyObject] = [
            "token":"http://challenge.code2040.org/api/register" as AnyObject,
            "github":"https://github.com/cesaribarra10/Code2040" as AnyObject
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: jsonData, options: .prettyPrinted)
        } catch {
            print("there was an error parsing json")
        }
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            if error == nil {
                print("YAY")
                guard let responseReceived = response as? HTTPURLResponse else {return}
                print(responseReceived)
            }
        }
        task.resume()
        print("hello")
        
    }

}

