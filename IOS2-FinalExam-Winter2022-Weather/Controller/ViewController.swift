//
//  ViewController.swift
//  IOS2-FinalExam-Winter2022-Weather
//
//  Created by Daniel Carvalho on 2022-03-19.
//
import UIKit
import MapKit

class ViewController: UIViewController, UICitySearchBarDelegate {

    //Store the city that is searched by the user to check for any errors
    private var searchedCity : String? = ""
    
    private func initialize(){
            
    view.addSubviews(mapView, loadingView, citySearchBar, cityInfoView)
            
    citySearchBar.delegate = self
         
    applyConstraints()

    }

    @IBOutlet var imgBackGround : UIImageView!

    private var mapView = defaultMapView()

    private var loadingView = UILoadingView()

    private var citySearchBar = UICitySearchBar()
    
    private var cityInfoView = UICityInfoView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        initialize()
    }
    
    
    
    private func applyConstraints(){
        
        mapView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.view.sendSubviewToBack(mapView)

        loadingView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        loadingView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        loadingView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        loadingView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.view.bringSubviewToFront(loadingView)
        
        citySearchBar.leadingAnchor.constraint(equalTo:self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        citySearchBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        citySearchBar.trailingAnchor.constraint(equalTo:self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        cityInfoView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        cityInfoView.trailingAnchor.constraint(equalTo:self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        cityInfoView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 20).isActive = true
        cityInfoView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        self.view.bringSubviewToFront(cityInfoView)

    }

    func citySearchBar(cityToSearch: String) {
        
        

        //Validate searche word by user to have minimum 2 words
        if cityToSearch.count <= 2 {
            Toast.ok(view: self, title: "Alert", message: "Please Search a city with a minimum 2 characters!")
            self.citySearchBar.endSearch()
            searchedCity = cityToSearch
            return
        }
        
        //call the API to search the city
        searchedCity = cityToSearch
        loadingView.show(message: "Searching time zone information for \(cityToSearch), please wait...")
        WeatherAPI.timeZone(city: cityToSearch, successHandler: timeZoneSuccess(httpStatusCode:response:), failHandler: timeZoneFail(httpStatusCode:message:))
        
    }

    func citySearchBarValueChanged(cityToSearch: String) {
        
        cityInfoView.close()
        
    }
   
    
    private func timeZoneSuccess(httpStatusCode : Int, response : [String : Any] ){
        
        if httpStatusCode == 200 {
            
            guard let location = response["location"] as? [String : Any],
                  let current = response["current"] as? [String:Any] else {
                return
            }
            
            if let timeZoneInfo = WeatherAPILocation.decode(json: location),
               let weatherCurrentInfo = WeatherAPICurrent.decode(json: current){
                
                DispatchQueue.main.async {
                    
                    print(timeZoneInfo)
                    print(weatherCurrentInfo)

                    self.loadingView.hide()
                    self.citySearchBar.endSearch()
                    
                    //
                    
                    self.cityInfoView.show(city: timeZoneInfo.name, region: "\(timeZoneInfo.region) - \(timeZoneInfo.country)", timeZone: timeZoneInfo.tz_id, temperature: weatherCurrentInfo.temp_c,condition: weatherCurrentInfo.condition.text, conditionImage: weatherCurrentInfo.condition.icon)
                    
                    // to set the map location to the place that user searched
                    self.setMapLocation(city: timeZoneInfo)
                    
                }
                
            }
            
        } else {
            DispatchQueue.main.async {
                //Toast.show(view: self, title: "Something went wrong!", message: "Error parsing data received from server! Try again!")
            }
        }
        
        
    }
    
    private func timeZoneFail( httpStatusCode : Int, message : String ){
        
        DispatchQueue.main.async {
            
            self.loadingView.hide()
            self.citySearchBar.endSearch()

        }
        
        
    }
    
    
    private func setMapLocation( city : WeatherAPILocation ) {
        
        let coordinate = CLLocationCoordinate2D(latitude: city.lat, longitude: city.lon)
        
        let span = MKCoordinateSpan(latitudeDelta: CLLocationDegrees(0.300), longitudeDelta: CLLocationDegrees(0.300))
        
        let region = MKCoordinateRegion(center: coordinate, span: span)
        
        mapView.setRegion(region, animated: true)
        
    }
    
    
}



extension ViewController {
    
    
   private static func defaultMapView() -> MKMapView {
        let map = MKMapView()
        map.clipsToBounds = true
        map.translatesAutoresizingMaskIntoConstraints = false
        map.isZoomEnabled = false
        map.isRotateEnabled = false
        map.isScrollEnabled = false
        return map
   }
    
}
