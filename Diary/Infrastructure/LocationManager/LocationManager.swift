//
//  LocationManager.swift
//  Diary
//
//  Created by 써니쿠키on 2023/03/05.
//

import Foundation
import CoreLocation

protocol LocationManager {

    func fetchLocation() -> Location
}

final class DefaultLocationManager: NSObject {

    private var locationManager: CLLocationManager
    private var currentLocation: Location = Location(latitude: 0, longitude: 0)

    init(locationManager: CLLocationManager = CLLocationManager()) {
        self.locationManager = locationManager
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.delegate = self
    }

}

extension DefaultLocationManager: LocationManager {

    func fetchLocation() -> Location {
        locationManager.requestLocation()
        return currentLocation
    }
}

extension DefaultLocationManager: CLLocationManagerDelegate {

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            manager.requestLocation()
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locationCoordinate: CLLocationCoordinate2D = manager.location?.coordinate else {
            return
        }

        currentLocation = Location(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
