//
//  InterfaceController.swift
//  virtual dog WatchKit Extension
//
//  Created by William on 04.03.21.
//

import WatchKit
import Foundation
import Alamofire
import SpriteKit

class InterfaceController: WKInterfaceController {

    
    
    @IBOutlet weak var interfaceScene: WKInterfaceSKScene!
    var myScene = MyScene()
    var healthKitManager = HealthKitManager()
    let locationManager = CLLocationManager()
    
    override func awake(withContext context: Any?) {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            locationManager.requestLocation()
        }
        healthKitManager.checkHealthData()
        myScene.addingNodesToMainScene()
        interfaceScene.presentScene(myScene.mainScene)
        print("Scene Loaded !")
        }
            
            
    
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        print("willActivate Launched")
        locationManager.requestLocation()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }

    @IBAction func dogIsTouched(_ sender: Any) {
    }
}




//MARK: LocationManager & Alamo Request & Response
extension InterfaceController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else {
            return
        }
        print("location = \(locValue.latitude)\(locValue.longitude)")
        let request = AF.request("https://api.openweathermap.org/data/2.5/weather?lat=\(locValue.latitude)&lon=\(locValue.longitude)&appid=5f4e5914475a7bf11d3355722ffb14c6").responseJSON { response in
        }
        request.responseDecodable(of: WeatherData.self){(response) in
            guard let weatherData = response.value else { return }
            print("sunset: \(weatherData.sys.sunset), sunrise: \(weatherData.sys.sunrise), DateTime Now: \(Date().timeIntervalSince1970), weather is: \(weatherData.weather[0])")
            
            switch weatherData.weather[0].id {
            case 200...531:
                self.myScene.rain.alpha = 1
                self.myScene.rain_2.alpha = 1
            default:
                self.myScene.rain.alpha = 0
                self.myScene.rain_2.alpha = 0
                break
            }
            
            switch Int(Date().timeIntervalSince1970) {
            case Int(weatherData.sys.sunrise-900)..<Int(weatherData.sys.sunrise+900):
                if(self.myScene.mainScene.children.contains(self.myScene.stars)){
                    self.myScene.mainScene.removeChildren(in: [self.myScene.stars, self.myScene.stars_2])
                    self.myScene.stars.removeAllActions()
                    self.myScene.stars_2.removeAllActions()
                }
                print("this is sunrise")
                self.myScene.sky.run(SKAction.setTexture(SKTexture(imageNamed: "sky_sunrise")))
                self.myScene.sky_2.run(SKAction.setTexture(SKTexture(imageNamed: "sky_sunrise")))
            case Int(weatherData.sys.sunset-900)..<Int(weatherData.sys.sunset+900):
                print("this is sunset")
                self.myScene.sky.run(SKAction.setTexture(SKTexture(imageNamed: "sky_sunset")))
                self.myScene.sky_2.run(SKAction.setTexture(SKTexture(imageNamed: "sky_sunset")))
            case Int(weatherData.sys.sunrise+900)..<Int(weatherData.sys.sunset):
                print("this is Daylight")
                if weatherData.weather.first!.id > 802 || weatherData.weather.first!.id < 800 {
                    print("this is overcast")
                    self.myScene.sky.run(SKAction.setTexture(SKTexture(imageNamed: "sky_overcast")))
                    self.myScene.sky_2.run(SKAction.setTexture(SKTexture(imageNamed: "sky_overcast")))
                } else {
                    print("this is sunny")
                    self.myScene.sky.run(SKAction.setTexture(SKTexture(imageNamed: "sky_sunny")))
                    self.myScene.sky_2.run(SKAction.setTexture(SKTexture(imageNamed: "sky_sunny")))
                }
            case let x where x > Int(weatherData.sys.sunset+900):
                print("this is Night")
                self.myScene.stars.alpha = 1
                self.myScene.stars_2.alpha = 1
                self.myScene.stars.run(SKAction.repeatForever(SKAction.animate(with: self.myScene.starsFrame, timePerFrame: 0.7)))
                self.myScene.stars_2.run(SKAction.repeatForever(SKAction.animate(with: self.myScene.starsFrame, timePerFrame: 0.7)))
                self.myScene.sky.run(SKAction.setTexture(SKTexture(imageNamed: "sky_night")))
                self.myScene.sky_2.run(SKAction.setTexture(SKTexture(imageNamed: "sky_night")))
            default:
                break
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}
