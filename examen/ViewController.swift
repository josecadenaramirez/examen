//
//  ViewController.swift
//  examen
//
//  Created by José Cadena on 26/06/20.
//  Copyright © 2020 examen.com. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var tableSearch: UITableView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var edtSearch: UITextField!
    var items = [item]()
    var searches = [History]()
    override func viewDidLoad() {
        super.viewDidLoad()
        searches = saveSearch.getHistory().reversed()
        
    }

    func getItems(_ name:String){
        api.makeRequest(str: "https://shoppapp.liverpool.com.mx/appclienteservices/services/v3/plp?force-plp=true&search-string=\(name)&page-number=1&number-of-items-per-page=40") { (data, response, error) in
            if data != nil{
                let str = String(decoding: data!, as: UTF8.self)
                print("json:.º\(str)")
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: []) as? JSON
                    if let httpResponse = response as? HTTPURLResponse {
                        let statusCode = httpResponse.statusCode
                        if !(200..<300).contains(statusCode) {
                            
                        }
                    }
                    DispatchQueue.main.async {
                        self.items = item.getItems(json ?? [:])
                        self.tableView.reloadData()
                    }
                    
                } catch {
                    print("JSON error: \(error.localizedDescription)")
                }
            }
        }
    }

}


extension ViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("aslkjaskjaslkjasdsad:\(items.count)")
        if tableView.isEqual(tableSearch){
            return searches.count
        }else{
            return items.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.isEqual(tableSearch){
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! searchCell
            cell.setCell(search: searches[indexPath.row])
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! itemCell
            cell.setItem(item: items[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEqual(tableSearch){
            edtSearch.text = searches[indexPath.row].name
        }
    }
}

extension ViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        getItems(textField.text ?? "")
        tableSearch.alpha = 0
        if textField.text != ""{
            if !searches.contains(where: {$0.name?.lowercased() == textField.text!.lowercased()}){
                saveSearch.save(str: textField.text!)
            }
        }
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard searches.count > 0 else {return}
        tableSearch.reloadData()
        tableSearch.alpha = 1
    }
}
