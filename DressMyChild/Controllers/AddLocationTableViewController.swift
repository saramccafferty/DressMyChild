//
//  AddLocationTableViewController.swift
//  DressMyChild
//
//  Created by Sara on 24/2/2023.
//

import UIKit

import CoreLocation

class AddLocationTableViewController: UITableViewController {
    
    var location: Location?
    // property with Bool flag to indicate if the address/city entered by the user was successfully converted to a location with CLLocation
    var locationFound = false
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var addressTextField: UITextField!
    @IBOutlet var addressFeedbackLabel: UILabel!
    @IBOutlet var saveButton: UIBarButtonItem!
    @IBOutlet var tempVarianceSlider: UISlider!
    @IBOutlet var tempVarianceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set the background view of the table view
        tableView.backgroundView = UIImageView(image: UIImage(named: "nightSkyImage"))
        tableView.backgroundView?.alpha = 0.35
        tableView.backgroundView?.contentMode = .scaleAspectFill
        // initialise the location property with a new Location object if it is currently nil
        self.location = location ?? Location(title: "", lat: "", lon: "", indoorTempVariance: 5)
        // disable save button if required feilds are not entered and CLLocation successfully found
        updateSaveButtonState()
    }
    

    
    // update save button state if text in the name and address text field, and if a location has been successfully found
    func updateSaveButtonState() {
        let titleText = titleTextField.text ?? ""
        let addressText = addressTextField.text ?? ""
        saveButton.isEnabled = !titleText.isEmpty && !addressText.isEmpty && locationFound
    }
    
    // annimate addressFeedbackLabel to fade out after label appears
    func fadeFeedbackLabel(_ animated: Bool) {
        super.viewDidAppear(animated)
        let duration = TimeInterval(1.5)
        self.addressFeedbackLabel.alpha = 1.0
        
        UIView.animate(withDuration: duration, delay: 0.0, animations: {
            self.addressFeedbackLabel.alpha = 0.0
        })
    }
    
    // shaking animation for the address text field to indicate to the user there was an error
    func shakeTextField() {
        // animate the addressTextField to shake horizontally
        UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 6.0, options: .curveEaseOut, animations: {
            let shakeTransform = CGAffineTransform(translationX: 20, y: 0)
            self.addressTextField.transform = shakeTransform
        })
        { (_) in
            // return the addressTextField to its original position after the shake animation finishes
            UIView.animate(withDuration: 0.6, animations: {
                self.addressTextField.transform = CGAffineTransform.identity
            })
        }
    }
    
    
    // create a CLGeocoder object to convert the address text into a location coordinate
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        let geocoder = CLGeocoder()
        let address = "\(addressTextField.text!)"
        // convert the address text into a location coordinate
        geocoder.geocodeAddressString(address, completionHandler: { (placemarks, error) in
            // if there was an error converting the address, display an error message and shake the text field
            if error != nil {
                self.addressFeedbackLabel.text = "Location not found."
                self.addressFeedbackLabel.textColor = .red
                self.fadeFeedbackLabel(true)
                self.shakeTextField()
            }
            
            var location: CLLocation?
            // if location was found save the latitude and longitude coordinates to the location object
            if let placemarks = placemarks, placemarks.count > 0 {
                location = placemarks.first?.location
            }
            
            if let location = location {
                let coordinate = location.coordinate
                self.location?.lon = String(coordinate.longitude)
                self.location?.lat = String(coordinate.latitude)
                self.locationFound = true
                self.addressFeedbackLabel.text = "Location found."
                self.addressFeedbackLabel.textColor = .green
                self.fadeFeedbackLabel(true)
                self.updateSaveButtonState()

            }
            else
            {
                // if no location was found shake the text field and print error
                self.shakeTextField()
                print("No Matching Location Found")
            }
        })
    }
    
    
    // update the save button state when there are changes to text fields and sliders
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    // update the temperature variance label based on the slider value
    @IBAction func tempVarianceSliderChanged(_ sender: UISlider) {
        let sliderValue = Int(sender.value)
        tempVarianceLabel.text = String(sliderValue) + "°C"
    }
    
    
    // MARK: - Navigation
    // prepare to save the location object when the save button is tapped and initialize a location object with the values of the text fields and sliders
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "saveUnwind" else {return}
        let title = titleTextField.text!
        let lat = location?.lat ?? ""
        let lon = location?.lon ?? ""
        let indoorTempVariance = Int(tempVarianceSlider.value)
        
        location = Location(title: title, lat: lat, lon: lon, indoorTempVariance: indoorTempVariance)
    }
    
}
