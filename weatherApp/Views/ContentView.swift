import SwiftUI
import CoreLocation

struct WeatherAppView: View {
    @State public var isNight = false
    @StateObject private var locationManager = LocationManager()
    @State private var weatherData: WeatherData?
    private var week = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    var body: some View {
        ZStack {
            BackgroundView(isNight: isNight)
            if let weatherData = weatherData, let index = week.firstIndex(of: weatherData.date){
                VStack {
                    Text(weatherData.locationName)
                        .font(.system(size: 32, weight: .medium, design: .default))
                        .foregroundStyle(.white)
                        .padding()
                    
                    
                    MainWeatherView(image: weatherData.condition.contains("drizzle") ? "cloud.rain" : weatherData.condition.contains("rain") ? "cloud.heavyrain" : weatherData.condition.contains("thunderstorm") ? "cloud.bolt.rain" : weatherData.condition.contains("snow") ? "snowflake" : "cloud.sun.fill", temp: Int(weatherData.temperature))
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(.white)
                        .padding(.bottom, 20)
                    
                    
                    HStack(spacing: 30) {
                        WeatherDayView(day: String(week[(index+1)%7].prefix(3)), image: "cloud.sun.fill", temp: 20)
                        WeatherDayView(day: String(week[(index+2)%7].prefix(3)), image: "sun.max.fill", temp: 33)
                        WeatherDayView(day: String(week[(index+3)%7].prefix(3)), image: "wind.snow", temp: 21)
                        WeatherDayView(day: String(week[(index+4)%7].prefix(3)), image: "sunset.fill", temp: 25)
                        WeatherDayView(day: String(week[(index+5)%7].prefix(3)), image: "snow", temp: 15)
                    }
                    
                    Spacer()
                    
                    WeatherButton(title: "Change Day Time", textColor: .blue, backgroundColor: .white, isNight: $isNight)
                    Spacer()
                }
            } else {
                ProgressView()
            }
        }.onAppear {
            locationManager.requestLocation()
        }
        .onReceive(locationManager.$location) { location in
            guard let location = location else { return }
            fetchWeatherData(for: location)
        }
    }

    private func fetchWeatherData(for location: CLLocation) {
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
                    weatherData = WeatherData(
                        locationName: weatherResponse.name,
                        temperature: weatherResponse.main.temp,
                        condition: weatherResponse.weather.first?.description ?? "",
                        date: date
                    )
                }
            } catch {
                print(error.localizedDescription, "ContentView")
            }
        }.resume()
    }
}

#Preview {
    WeatherAppView()
}

struct BackgroundView: View {
    var isNight: Bool
    
    var body: some View {
        LinearGradient(colors: [isNight ? .black : .blue, isNight ? .gray : .lightBlue],
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing)
            .ignoresSafeArea(.all)
    }
}
