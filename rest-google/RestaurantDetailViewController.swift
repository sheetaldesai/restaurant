//
//  RestaurantDetailViewController.swift
//  rest-google
//
//  Created by Sheetal Desai on 11/15/17.
//  Copyright © 2017 Sheetal Desai. All rights reserved.
//

import UIKit
import GooglePlaces

class RestaurantDetailViewController: UIViewController {

    var restaurants:[NSDictionary] = []
    var restaurant:NSDictionary = NSDictionary()
    
    @IBOutlet weak var lblRating: UILabel!
    
    @IBOutlet weak var lblUrl: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    var price_level:[String:String] = ["0":"Free","1":"Inexpensive","2":"Moderate","3":"Expensive","4":"Very Expensive"]
    
   
    
    override func viewDidLoad() {
        
        var rating = "NA"
        var price = "NA"
        
        super.viewDidLoad()
        // Pick a random restaurnat
        let randomNum = arc4random_uniform(UInt32(self.restaurants.count))
        print("Count: \(self.restaurants.count) rand: \(randomNum)")
        restaurant = self.restaurants[Int(randomNum)]
        print("restaurnat: \(restaurant)")
        
        if let r = restaurant["rating"] as? String{
            rating = r
        }
        if let rint = restaurant["rating"] as? Int {
            rating = String(rint)
        }
        
        if let p = restaurant["price_level"] as? String {
            if let l = price_level[p] {
                price = l
            }
        }
        
        lblName.text = restaurant["name"] as! String
        lblRating.text = rating
        lblPrice.text = price
        lblAddress.text = restaurant["formatted_address"] as! String
        
        loadFirstPhotoForPlace(placeID: restaurant["place_id"] as! String)
    }
    
    func loadFirstPhotoForPlace(placeID: String) {
        GMSPlacesClient.shared().lookUpPhotos(forPlaceID: placeID) { (photos, error) -> Void in
            if let error = error {
                // TODO: handle the error.
                print("Error: \(error.localizedDescription)")
            } else {
                if let firstPhoto = photos?.results.first {
                    self.loadImageForMetadata(photoMetadata: firstPhoto)
                }
            }
        }
    }
    
    func loadImageForMetadata(photoMetadata: GMSPlacePhotoMetadata) {
        GMSPlacesClient.shared().loadPlacePhoto(photoMetadata, callback: {
            (photo, error) -> Void in
            if let error = error {
                // TODO: handle the error.
                print("Error: \(error.localizedDescription)")
            } else {
                self.imgView.image = photo;
                //self.attributionTextView.attributedText = photoMetadata.attributions;
            }
        })
    }

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
