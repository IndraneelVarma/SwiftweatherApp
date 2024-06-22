import SwiftUI
import CoreLocation

struct ContentView: View {
    @State public var isNight = false
    @StateObject private var locationManager = LocationManager()
    @StateObject private var viewModel = ContentViewModel()
    private var week = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    var body: some View {
        ZStack {
            BackgroundView(isNight: isNight)
            if let weatherData = viewModel.weatherData, let index = week.firstIndex(of: weatherData.date) {
                VStack {
                    Text(weatherData.locationName)
                        .font(.system(size: 32, weight: .medium, design: .default))
                        .foregroundStyle(.white)
                        .padding()
                    
                    MainWeatherModel(image: weatherData.condition.contains("drizzle") ? "cloud.rain" : weatherData.condition.contains("rain") ? "cloud.heavyrain" : weatherData.condition.contains("thunderstorm") ? "cloud.bolt.rain" : weatherData.condition.contains("snow") ? "snowflake" : "cloud.sun.fill", temp: Int(weatherData.temperature))
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(.white)
                        .padding(.bottom, 20)
                    
                    HStack(spacing: 30) {
                        SecondaryWeatherModel(day: String(week[(index+1)%7].prefix(3)), image: "cloud.sun.fill", temp: 20)
                        SecondaryWeatherModel(day: String(week[(index+2)%7].prefix(3)), image: "sun.max.fill", temp: 33)
                        SecondaryWeatherModel(day: String(week[(index+3)%7].prefix(3)), image: "wind.snow", temp: 21)
                        SecondaryWeatherModel(day: String(week[(index+4)%7].prefix(3)), image: "sunset.fill", temp: 25)
                        SecondaryWeatherModel(day: String(week[(index+5)%7].prefix(3)), image: "cloud.snow.fill", temp: 15)
                    }
                    
                    Spacer()
                    
                    ThemeButton(title: "Change Day Time", textColor: .blue, backgroundColor: .white, isNight: $isNight)
                    Spacer()
                }
            } else {
                ProgressView()
            }
        }
        .onAppear {
            locationManager.requestLocation()
        }
        .onReceive(locationManager.$location) { location in
            guard let location = location else { return }
            viewModel.fetchWeatherData(for: location)
        }
    }
}

#Preview {
    ContentView()
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
