//
//  MediaVC.swift
//  WiFinder
//
//  Created by Boariu Andy on 9/12/18.
//  Copyright © 2018 Momentous Tech Corp. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

enum MediaType: String {
    case music
    case tvShow
    case movie
}

class MediaVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var strMediaType = MediaType.music.rawValue

    // MARK: - View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        fetchMediaFromItunes()
    }
    
    // MARK: - Notification Methods
    
    // MARK: - Public Methods
    
    // MARK: - Custom Methods
    
    private func buildSearchUrl() -> URL? {
        
        if var urlComponents = URLComponents(string: "https://itunes.apple.com/search") {
            urlComponents.queryItems = [
                URLQueryItem(name: "media", value: strMediaType)
            ]
            
            if let strSearchText = searchBar.text {
                urlComponents.queryItems?.append(URLQueryItem(name: "term", value: strSearchText))
            }
            
            return urlComponents.url
        }
        
        return nil
    }
    
    // MARK: - API Methods
    
    private func fetchMediaFromItunes() {
        if let url = buildSearchUrl() {
            Alamofire.request(url, method: .get, parameters: nil, headers: nil).responseJSON { (response) in
                print("Request: \(String(describing: response.request))")   // original url request
                print("Response: \(String(describing: response.response))") // http url response
                print("Result: \(response.result)")                         // response serialization result
                
//                if let json = response.result.value {
//                    print("JSON: \(json)") // serialized json response
//                }
                
//                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
//                    print("Data: \(utf8Text)") // original server data as UTF8 string
//                }
                
                if let data = response.data {
                    let json = try! JSON(data: data)
                    
                    
                }
            }
        }
    }
    
    // MARK: - Action Methods
    
    // MARK: - Memory Cleanup
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */

}

// MARK: - UITableViewDataSource Methods

extension MediaVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MediaCell.cellID, for: indexPath) as! MediaCell
        //cell.lblMenuOption.text = arrMenuOptions[indexPath.row]
        //cell.imgOption.image = UIImage(named: arrMenuImages[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}

// MARK: - UISearchBarDelegate Methods
extension MediaVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        if selectedScope == 0 {
            strMediaType = MediaType.music.rawValue
        }
        else
            if selectedScope == 1 {
                strMediaType = MediaType.tvShow.rawValue
            }
            else {
                strMediaType = MediaType.movie.rawValue
            }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        fetchMediaFromItunes()
    }
}
