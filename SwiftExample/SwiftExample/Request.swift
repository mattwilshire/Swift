//
//  Request.swift
//  SwiftExample
//
//  Created by Matthew Wilshire on 02/04/2022.
//

import Foundation

class Request {
    var url: String!
    private var request: URLRequest!
    
    init(_url: String) {
        url = _url
        request = URLRequest(url: URL(string: url)!)
    }
    
    func getPersons(completion: @escaping ( [Person] ) -> ( ) ) {
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            let decoder = JSONDecoder()
            let response = try? decoder.decode([Person].self, from: data)
            completion(response!)
            
        }
        task.resume()
    }
    
    func postPerson(person: Person, completion: @escaping (String) -> ( ) ) {
        do {
            let encoder = JSONEncoder()
            let jsonString = try? encoder.encode(person)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-type")
            request.httpBody = jsonString
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    return
                }
                completion(String(data: data, encoding: .utf8)!)
                // You can decode the response like the get request below but I would rather return a string for a post request.
//                print("DECODING Response")
//                let decoder = JSONDecoder()
//                let response = try? decoder.decode(Personn.self, from: data)
//                print(response!.name)
//                print(response!.age)
            }
            task.resume()
        }
    }
}
