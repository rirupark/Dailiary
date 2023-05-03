//
//  LocationManager.swift
//  Dailiary
//
//  Created by 박민주 on 2023/01/12.
//

import Foundation
import CoreLocation
import MapKit
// Combine Framework to watch Textfield Change
import Combine

class LocationManager: NSObject, ObservableObject, MKMapViewDelegate, CLLocationManagerDelegate {
    // MARK: - Property Wrappers
    @Published var mapView: MKMapView = .init()
    @Published var manager: CLLocationManager = .init()
    
    // Search Bar Text
    @Published var searchAddress: String = ""
    
    @Published var fetchedPlaces: [CLPlacemark]?
    
    // User Location
    @Published var userLocation: CLLocation?
    
    // Final Location
    @Published var pickedLocation: CLLocation?
    @Published var pickedPlaceMark: CLPlacemark?
    
    @Published var isDraggable: Bool = true

    
    // MARK: - Properties
    var cancelLabel: AnyCancellable?
    
    override init() {
        super.init()
        // MARK: Setting Delegates
        manager.delegate = self
        mapView.delegate = self
        
        // MARK: Requesting Location Access
        manager.requestWhenInUseAuthorization()
        
        // MARK: Search Textfield Watching
        cancelLabel = $searchAddress
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink(receiveValue: { value in
                if value != "" {
                    self.fetchPlaces(value: value)
                } else {
                    self.fetchedPlaces = nil
                }
            })
    }
    
    // MARK: - Fetching places using MKLocalSearch & Async/Await
    func fetchPlaces(value: String) {
        //print(value)
        Task {
            do {
                let request = MKLocalSearch.Request()
                request.naturalLanguageQuery = value.lowercased()
                
                let response = try await MKLocalSearch(request: request).start()
                
                // We can also use MainActor To publish changes in Main Thread
                await MainActor.run(body: {
                    self.fetchedPlaces = response.mapItems.compactMap({ item -> CLPlacemark? in
                        return item.placemark
                    })
                })
            }
            catch {
                // handle error
                print(error.localizedDescription)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Handle Error
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }
        self.userLocation = currentLocation
    }
    
    // MARK: - Location Authorization
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways: manager.requestLocation()
        case .authorizedWhenInUse: manager.requestLocation()
        case .denied: handleLocationError()
        case .notDetermined: manager.requestWhenInUseAuthorization()
        default: ()
            
        }
    }
    
    // MARK: - Handle Error
    func handleLocationError() {
        
    }
    
    // MARK: - Add Draggable Pin to MapView
    func addPin(coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = ""
        
        mapView.addAnnotation(annotation)
    }
    
    // MARK: - Enabling Dragging
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let marker = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "PIN")
        marker.isDraggable = self.isDraggable
        marker.canShowCallout = false
        
        return marker
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        //print("Location Updated")
        guard let newLocation = view.annotation?.coordinate else { return }
        self.pickedLocation = .init(latitude: newLocation.latitude, longitude: newLocation.longitude)
        updatePlacemark(location: .init(latitude: newLocation.latitude, longitude: newLocation.longitude))
    }
    
    func updatePlacemark(location: CLLocation) {
        Task {
            do {
                guard let place = try await reverseLocationCoordinates(location: location) else { return }
                await MainActor.run(body: {
                    self.pickedPlaceMark = place
                })
            }
            catch {
                // Handle Error
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Displaying New Location Data
    func reverseLocationCoordinates(location: CLLocation) async throws -> CLPlacemark? {
        let place = try await CLGeocoder().reverseGeocodeLocation(location).first
        return place
    }
}
