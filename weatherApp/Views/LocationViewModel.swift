import Foundation
import SwiftUI
import CoreLocation

struct WeatherData {
    let locationName: String
    let temperature: Double
    let condition: String
    let date: String
}

struct WeatherResponse: Codable {
    let name: String
    let main: MainWeather
    let weather: [Weather]
    let dt: Double
}

struct MainWeather: Codable {
    let temp: Double
}

struct Weather: Codable {
    let description: String
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var location: CLLocation?
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription, "WeatherData")
    }
}

func convertUnixTimestamp(_ timestamp: Double) -> String {
    let date = Date(timeIntervalSince1970: timestamp)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE"  // "EEEE" gives the full name of the day (e.g., "Monday")
    return dateFormatter.string(from: date)
}
