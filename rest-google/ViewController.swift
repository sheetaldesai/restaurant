//
//  ViewController.swift
//  rest-google
//
//  Created by Sheetal Desai on 11/15/17.
//  Copyright © 2017 Sheetal Desai. All rights reserved.
//

import UIKit
import GooglePlaces
import CoreLocation
import AVFoundation

class ViewController: UIViewController {

     var placesClient: GMSPlacesClient!
     let locationManager = CLLocationManager()
    
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var distancePicker: UIPickerView!
    @IBOutlet weak var ratingPicker: UIPickerView!
    
    var ratings = [1,2,3,4,5]
    var distance = [5,10,15]
    var categories = ["Indian","Thai","Korean","American","Asian Fusion","Italian","French","Chinese","Itheopian", "Seafood"]
    
    var sRating:Int = 1
    var sDistance:Int = 5
    var sCategory:String = "Indian"
    
    var restaurants:[NSDictionary] = []
    
    var player:AVAudioPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do
        {
            let audioPath = Bundle.main.path(forResource: "pop", ofType: "mp3")
            try player = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath!) as URL)
        }
        catch
        {
            //PROCESS ERROR
        }
        let session = AVAudioSession.sharedInstance()
        
        do
        {
            try session.setCategory(AVAudioSessionCategoryPlayback)
        }
        catch
        {
        }
        
        player.play()
    
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getCurrentLocation(){
        locationManager.requestAlwaysAuthorization()
        placesClient = GMSPlacesClient.shared()
        placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            //self.nameLabel.text = "No current place"
            //self.addressLabel.text = ""
            
            if let placeLikelihoodList = placeLikelihoodList {
                let place = placeLikelihoodList.likelihoods.first?.place
                if let place = place {
                    print(place.name)
                    print(place.formattedAddress?.components(separatedBy: ", ")
                        .joined(separator: "\n"))
                }
            }
        })
    }
    
    func getRestaurants(str:String) {
        
        print(str)
        let url = URL(string: str)
        // create a URLSession to handle the request tasks
        let session = URLSession.shared
        // create a "data task" to make the request and run completion handler
        let task = session.dataTask(with: url!, completionHandler: {
            // see: Swift closure expression syntax
            data, response, error in
            // data -> JSON data, response -> headers and other meta-information, error-> if one occurred
            // "do-try-catch" blocks execute a try statement and then use the catch statement for errors
            do {
                // try converting the JSON object to "Foundation Types" (NSDictionary, NSArray, NSString, etc.)
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                    //print(jsonResult)
                   
                    self.restaurants = jsonResult["results"] as! [NSDictionary]
                    
                    DispatchQueue.main.async {
                        self.showSegue()
                    }
                    
                }
            } catch {
                print(error)
            }
        })
        // execute the task and then wait for the response
        // to run the completion handler. This is async!
        task.resume()
    }

    func showSegue() {
        print("showsegue")
        performSegue(withIdentifier: "detailSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            let detailVC = segue.destination as! RestaurantDetailViewController
            detailVC.restaurants = restaurants
        }
    }
    
    @IBAction func goButtonPressed(_ sender: UIButton) {
        print("\(sRating) \(sDistance) \(sCategory)")
        
        let dMiles = Double(sDistance) * 1609.34
        
        var str = "https://maps.googleapis.com/maps/api/place/textsearch/json?location=37.375801,-121.910352&radius=1000&query=restaurant+\(sCategory)&radius=\(dMiles)&key=AIzaSyDaMC9ItLdqeydFQagTEr6k6xXilqKqQXA"
        getRestaurants(str:str)
        
    }
    
    
    @IBAction func surpriseButtonPressed(_ sender: UIButton) {
        var str = "https://maps.googleapis.com/maps/api/place/textsearch/json?location=37.375801,-121.910352&radius=1000&query=restaurant&key=AIzaSyDaMC9ItLdqeydFQagTEr6k6xXilqKqQXA"
        getRestaurants(str:str)
    }
    
    @IBAction func dateNightButtonPressed(_ sender: UIButton) {
        var str = "https://maps.googleapis.com/maps/api/place/textsearch/json?location=37.375801,-121.910352&radius=1000&query=restaurant&key=AIzaSyDaMC9ItLdqeydFQagTEr6k6xXilqKqQXA"
        getRestaurants(str:str)
    }
    
    
    @IBAction func breakupButtonPressed(_ sender: UIButton) {
        var str = "https://maps.googleapis.com/maps/api/place/textsearch/json?location=37.375801,-121.910352&radius=1000&query=bar&key=AIzaSyDaMC9ItLdqeydFQagTEr6k6xXilqKqQXA"
        getRestaurants(str:str)
    }
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var count = 0
        if pickerView == ratingPicker {
            count = ratings.count
        } else if pickerView == distancePicker {
            count = distance.count
        } else if pickerView == categoryPicker {
            count = categories.count
        }
        return count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var title = ""
        if pickerView == ratingPicker {
            title = String(ratings[row])
        } else if pickerView == distancePicker {
            title = String(distance[row])
        } else if pickerView == categoryPicker {
            title = String(categories[row])
        }
        return title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == ratingPicker {
            sRating = ratings[row]
        } else if pickerView == distancePicker {
            sDistance = distance[row]
        } else if pickerView == categoryPicker {
            sCategory = categories[row]
        }
    }
    
    
}

