//
//  WeatherData.swift
//  virtual dog WatchKit Extension
//
//  Created by William on 06.03.21.
//

import Foundation

struct WeatherData: Codable {
    let weather: [Weather]
    let sys: Sys
}
struct Sys: Codable {
    let sunset: Int
    let sunrise: Int
}
struct Weather: Codable{
    let id: Int
}
