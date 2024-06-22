//
//  ContentViewModel.swift
//  weatherApp
//
//  Created by Indraneel Varma on 23/06/24.
//

import Foundation
import CoreLocation

final class ContentViewModel: ObservableObject{
    @Published var weatherData: WeatherData?
    func fetchWeatherData(for location: CLLocation) {
        let apiKey = "4bfceda699c28bc20a472dd37eba7482"
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&appid=\(apiKey)&units=metric"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                let weatherResponse = try decoder.decode(WeatherResponse.self, from: data)
                
                DispatchQueue.main.async {
                    let date = convertUnixTimestamp(weatherResponse.dt)
                    self.weatherData = WeatherData(
                        locationName: weatherResponse.name,
                        temperature: weatherResponse.main.temp,
                        condition: weatherResponse.weather.first?.description ?? "",
                        date: date
                    )
                }
            } catch {
                print(error.localizedDescription, "ContentViewModel")
            }
        }.resume()
    }
}
