//
//  CLLocation+XMTool.swift
//  XMUI_Swift
//
//  Created by 张明炜 on 2022/6/23.
//

import Foundation
import UIKit
import CoreLocation

let a:Double = 6378245.0
let ee:Double = 0.00669342162296594323
let x_pi:Double = .pi * 3000.0 / 180.0

// MARK: - 「火星、地球、百度」之间坐标相关转换
extension CLLocation {
    
    /// 获取【火星】坐标 根据地球坐标
    func getMarsFromEarth_XMS() -> CLLocation {
        let (n_lat,n_lng) = CLLocation.transform_earth_from_mars(lat: self.coordinate.latitude, lng: self.coordinate.longitude)
        let coord_2d = CLLocationCoordinate2D(latitude: n_lat + self.coordinate.latitude, longitude: n_lng + self.coordinate.longitude)
        
        return CLLocation(coordinate: coord_2d, altitude: self.altitude, horizontalAccuracy: self.horizontalAccuracy, verticalAccuracy: self.horizontalAccuracy, course: self.course, speed: self.speed, timestamp: self.timestamp)
    }
    /// 获取【火星】坐标 根据百度坐标
    func getMarsFromBaidu_XMS() -> CLLocation {
        let (n_lat,n_lng) = CLLocation.transform_baidu_from_mars(lat: self.coordinate.latitude, lng: self.coordinate.longitude)
        let coord_2d = CLLocationCoordinate2D(latitude: n_lat, longitude: n_lng)
        return CLLocation(coordinate: coord_2d, altitude: self.altitude, horizontalAccuracy: self.horizontalAccuracy, verticalAccuracy: self.horizontalAccuracy, course: self.course, speed: self.speed, timestamp: self.timestamp)
    }
    
    /// 获取【百度】坐标 根据火星坐标
    func getBaiduFromMars_XMS() -> CLLocation {
        let (n_lat,n_lng) = CLLocation.transform_mars_from_baidu(lat: self.coordinate.latitude, lng: self.coordinate.longitude)
        let coord_2d = CLLocationCoordinate2D(latitude: n_lat, longitude: n_lng)
        return CLLocation(coordinate: coord_2d, altitude: self.altitude, horizontalAccuracy: self.horizontalAccuracy, verticalAccuracy: self.horizontalAccuracy, course: self.course, speed: self.speed, timestamp: self.timestamp)
    }
    /// 获取【百度】坐标 根据地球坐标
    func locationBaiduFromEarth_XMS() -> CLLocation {
        let mars = self.getMarsFromEarth_XMS()
        let baidu = mars.getBaiduFromMars_XMS()
        return baidu
    }
    
    /// 获取【地球】坐标 根据百度坐标
    func getEarthFromBaidu_XMS() -> CLLocation {
        let mars = self.getMarsFromBaidu_XMS()
        let earth = mars.getEarthFromMars_XMS()
        return earth
    }
    /// 获取【地球】坐标 根据火星坐标
    func getEarthFromMars_XMS() -> CLLocation {
        let (n_lat,n_lng) = CLLocation.transform_earth_from_mars(lat: self.coordinate.latitude, lng: self.coordinate.longitude)
        let coord_2d = CLLocationCoordinate2D(latitude: self.coordinate.latitude - n_lat, longitude: self.coordinate.longitude - n_lng)
        return CLLocation(coordinate: coord_2d, altitude: self.altitude, horizontalAccuracy: self.horizontalAccuracy, verticalAccuracy: self.horizontalAccuracy, course: self.course, speed: self.speed, timestamp: self.timestamp)
    }
    
    private class func transform_earth_from_mars(lat: Double, lng: Double) -> (Double, Double) {
        if CLLocation.transform_sino_out_china(lat: lat, lng: lng) {
            return (lat, lng)
        }
        var dLat = CLLocation.transform_earth_from_mars_lat(lng - 105.0, lat - 35.0)
        var dLng = CLLocation.transform_earth_from_mars_lng(lng - 105.0, lat - 35.0)
        let radLat = lat / 180.0 * .pi
        var magic = sin(radLat)
        magic = 1 - ee * magic * magic
        let sqrtMagic:Double = sqrt(magic)
        dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * .pi)
        dLng = (dLng * 180.0) / (a / sqrtMagic * cos(radLat) * .pi)
        return (dLat,dLng)
    }
    private class func transform_earth_from_mars_lat(_ x: Double,_ y: Double) -> Double {
        var ret: Double = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(fabs(x))
        ret += (20.0 * sin(6.0 * x * .pi) + 20.0 * sin(2.0 * x * .pi)) * 2.0 / 3.0
        ret += (20.0 * sin(y * .pi) + 40.0 * sin(y / 3.0 * .pi)) * 2.0 / 3.0
        ret += (160.0 * sin(y / 12.0 * .pi) + 320 * sin(y * .pi / 30.0)) * 2.0 / 3.0
        return ret
    }
    private class func transform_earth_from_mars_lng(_ x: Double,_ y: Double) -> Double {
        var ret: Double = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(fabs(x))
        ret += (20.0 * sin(6.0 * x * .pi) + 20.0 * sin(2.0 * x * .pi)) * 2.0 / 3.0
        ret += (20.0 * sin(x * .pi) + 40.0 * sin(x / 3.0 * .pi)) * 2.0 / 3.0
        ret += (150.0 * sin(x / 12.0 * .pi) + 300.0 * sin(x / 30.0 * .pi)) * 2.0 / 3.0
        return ret
    }
    private class func transform_mars_from_baidu(lat: Double, lng: Double) -> (Double,Double) {
        let x = lng , y = lat
        let z = sqrt(x * x + y * y) + 0.00002 * sin(y * x_pi)
        let theta = atan2(y, x) + 0.000003 * cos(x * x_pi)
        return (z * sin(theta) + 0.006, z * cos(theta) + 0.0065)
    }
    private class func transform_baidu_from_mars(lat: Double, lng: Double) -> (Double,Double) {
        let x = lng - 0.0065 , y = lat - 0.006
        let z =  sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi)
        let theta = atan2(y, x) - 0.000003 * cos(x * x_pi)
        return (z * sin(theta), z * cos(theta))
    }
    private class func transform_sino_out_china(lat: Double, lng: Double) -> Bool {
        if (lng < 72.004 || lng > 137.8347) {
            return true
        }
        if (lat < 0.8293 || lat > 55.8271) {
            return true
        }
        return false
    }

}
