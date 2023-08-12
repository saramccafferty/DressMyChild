//
//  Location.swift
//  DressMyChild
//
//  Created by Sara on 24/2/2023.
//

import Foundation

// Location struct to store user input for address/city lon, lat, location title and selected indoor temp variance
struct Location: Codable {
    var title: String
    var lat: String
    var lon: String
    var indoorTempVariance: Int
    
    // the URL where Location instances will be saved
    static var archiveURL: URL {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL = documentDirectory.appendingPathComponent("locations").appendingPathExtension("plist")
        
        return archiveURL
    }
    
    // return an array of sample Locations for testing
    static var sampleLocations: [Location] {
        return [
            Location(title: "Grandma's", lat: "-27.4705", lon: "153.0260", indoorTempVariance: 5),
            Location(title: "Aunt Danni's", lat: "-33.8688", lon: "151.2093", indoorTempVariance: 5),
            Location(title: "Aunt Tara's", lat: "-37.8136", lon: "144.9631", indoorTempVariance: 5)
        ]
    }
    
    // save Location instances
    static func saveToFile(locations: [Location]) {
        // encode the locations array using propertyListEncoder
        let propertyListEncoder = PropertyListEncoder()
        do {
            let encodedLocation = try propertyListEncoder.encode(locations)
            try encodedLocation.write(to: Location.archiveURL)
        } catch {
            // handle if there is an error
            print("Error encoding locations: \(error)")
        }
    }
    
    // loads array of Location instances from a file
    static func loadFromFile() -> [Location]? {
        guard let locationData = try? Data(contentsOf: Location.archiveURL) else {
            return nil
        }
        
        do {
            // decode data saved to file
            let propertyListDecoder = PropertyListDecoder()
            let decodedLocations = try propertyListDecoder.decode([Location].self, from: locationData)
            
            // return decoded data
            return decodedLocations
        } catch {
            // handle if there is an error
            print("Error decoding locations: \(error))")
            return nil
        }
    }
}
