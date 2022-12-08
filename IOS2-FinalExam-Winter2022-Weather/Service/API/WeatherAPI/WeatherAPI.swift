import Foundation
import UIKit


class WeatherAPI {
    
    static let baseURL = "https://weatherapi-com.p.rapidapi.com/"
    
    
    static func timeZone( city : String,
                            successHandler: @escaping (_ httpStatusCode : Int, _ response : [String: Any]) -> Void,
                            failHandler : @escaping (_ httpStatusCode : Int, _ errorMessage: String) -> Void) {
        
        
        var formattedCity = city.replacingOccurrences(of: " ", with: "_")
        formattedCity = formattedCity.applyingTransform(.stripDiacritics, reverse: false)!
       
        let endPoint = "current.json?q=\(formattedCity)"
        
        let header = ["x-rapidapi-host" : "weatherapi-com.p.rapidapi.com",
                      "x-rapidapi-key" : "66fe353c83msha1dd838675bd333p1851bdjsna0c8c459dcba"]
        
        let payload : [String:String] = [:]
        
        
        API.call(baseURL: baseURL, endPoint: endPoint, method: "GET", header: header, payload: payload, successHandler: successHandler, failHandler: failHandler)
        
    }
    
}


struct WeatherAPILocation : Codable {
    
    var name : String
    var region : String
    var country : String
    var tz_id : String
    var lat : Double
    var lon : Double
    
    
    static func decode( json : [String:Any] ) -> WeatherAPILocation? {
        
        let decoder = JSONDecoder()
        do{
            let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            let object = try decoder.decode(WeatherAPILocation.self, from: data)
            return object
        } catch {
        }
        return nil
    }
}


struct WeatherAPICurrent : Codable {
    
    var temp_c : Double
    var condition : Condition
    
    struct Condition : Codable {
        var icon : String
        var text : String
    }
        
    static func decode( json : [String:Any] ) -> WeatherAPICurrent? {
        
        let decoder = JSONDecoder()
        do{
            let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            let object = try decoder.decode(WeatherAPICurrent.self, from: data)
            return object
        } catch {
        }
        return nil
    }
}
