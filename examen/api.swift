//
//  api.swift
//  examen
//
//  Created by José Cadena on 26/06/20.
//  Copyright © 2020 examen.com. All rights reserved.
//

import Foundation
import UIKit

public typealias responseCompletion = (Data?,URLResponse?, Error?) -> Void

class api{
    public static var cache = NSCache<AnyObject, AnyObject>()
    public static func makeRequest(str:String, body:JSON? = nil,completion: @escaping responseCompletion){
        guard let url = URL(string: str) else {return}
        var request = URLRequest(url: url)
        request.httpBody = jsonToData(params: body)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { (data, response, error) in
            completion(data,response,error)
        }
        task.resume()
    }
    
    static func jsonToData(params:JSON?)->Data?{
        if params != nil{
            let jsonData = try? JSONSerialization.data(withJSONObject: params!)
            return jsonData
        }
        else {return nil}
    }
}

extension UIImageView{
    public func downloadWithLoader(url:String,_ placeholder:UIImage? = nil, color:UIColor = .blue, completion:((_ image:UIImage?) ->())? = nil){
        guard URL(string: url) != nil else{return}
        let loader = UIActivityIndicatorView()
        loader.center = self.center
        loader.color = color
        self.addSubview(loader)
        loader.startAnimating()
        if let imageFromCache = api.cache.object(forKey: url as AnyObject) as? UIImage {
            self.image = imageFromCache
            loader.stopAnimating()
            loader.removeFromSuperview()
            return
        }
        
        api.makeRequest(str: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            api.cache.setObject(image, forKey: url as AnyObject)
            DispatchQueue.main.async() {
                UIView.transition(with: self,
                duration:0.35,
                options: .transitionCrossDissolve,
                animations: {
                    self.image = image
                },
                completion: { _ in
                    loader.stopAnimating()
                    loader.removeFromSuperview()
                })
            }
        }
    }
}
