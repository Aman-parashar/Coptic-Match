//
//  LocationManager.swift
//  HalalDating
//
//  Created by Apple on 18/11/24.
//

import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    
    private let locationManager = CLLocationManager()
    private var completion: ((String?) -> Void)?
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func startMonitoringLocation() {
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.distanceFilter = 50 // Update every 50 meters
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    func getCountryName(completion: @escaping (String?) -> Void) {
        self.completion = completion
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    // MARK: CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        // Logic for existing country name retrieval
        if let completion = self.completion {
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
                self?.locationManager.stopUpdatingLocation()
                
                if let error = error {
                    print("Reverse geocode failed: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                
                if let country = placemarks?.first?.country {
                    completion(country)
                } else {
                    completion(nil)
                }
                self?.completion = nil
            }
        }
        
        // Logic for Background Location Update (Shared Instance)
        if self == LocationManager.shared {
            updateAddressAPI(location: location)
        }
    }
    
    func updateAddressAPI(location: CLLocation) {
        // Check if user is logged in
        let user = Login_LocalDB.getLoginUserModel()
        // Assuming id is Int, check for 0 or logic that implies not logged in
        // If `user.data` is nil or `id` is missing/0, skip.
        guard let userData = user.data, userData.id != 0 else {
            return
        }
        
        let userId = String(userData.id)
        let lat = String(location.coordinate.latitude)
        let lng = String(location.coordinate.longitude)
        
        let params: [String: Any] = [
            "user_id": userId,
            "lat": lat,
            "lng": lng
        ]
        
        // Call API
        HttpWrapper.requestWithparamdictParamPostMethod(url: update_address, dicsParams: params as [String : AnyObject]) { (response) in
            print("Location updated successfully: \(response)")
        } errorBlock: { (error) in
            print("Location update failed: \(error.localizedDescription)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location update failed: \(error.localizedDescription)")
        completion?(nil)
    }
}
