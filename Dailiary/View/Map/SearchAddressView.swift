//
//  SearchAddressView.swift
//  Dailiary
//
//  Created by 박민주 on 2023/01/12.
//

import SwiftUI
import MapKit

struct SearchAddressView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var locationManager: LocationManager = .init()
    // Navigation Tag to Push View to MapView
    @State var showMapView: Bool = false
    @Binding var address: String
    @Binding var latitude: Double
    @Binding var longitude: Double
    @Binding var showingMapSheet: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
//                // 뒤로가기 버튼 -> 필요없을 듯
//                HStack(spacing: 15) {
//                    Button {
//
//                    } label: {
//                        Image(systemName: "chevron.left")
//                            .font(.title3)
//                            .foregroundColor(.primary)
//                    }
//
//                    Text("Search Location")
//                        .font(.title3)
//                        .fontWeight(.semibold)
//
//                } // HStack
//                .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(spacing: 10) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("주소를 검색해주세요.", text: $locationManager.searchAddress)
                } // HStack
                .padding(.vertical, 12)
                .padding(.horizontal)
                .background {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .strokeBorder(.gray)
                }
                
                if let places = locationManager.fetchedPlaces, !places.isEmpty {
                    List {
                        ForEach(places, id: \.self) { place in
                            Button {
                                // setting Map Region
                                if let coordinate = place.location?.coordinate {
                                    locationManager.isDraggable = true
                                    locationManager.pickedLocation = .init(latitude: coordinate.latitude, longitude: coordinate.longitude)
                                    locationManager.mapView.region = .init(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                                    locationManager.addPin(coordinate: coordinate)
                                    locationManager.updatePlacemark(location: .init(latitude: coordinate.latitude, longitude: coordinate.longitude))
                                }
                                // Navigation To MapView
                                showMapView = true
                            } label: {
                                HStack(spacing: 15) {
                                    Image(systemName: "mappin.circle.fill")
                                        .font(.title2)
                                        .foregroundColor(.gray)
                                    
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text(place.name ?? "")
                                            .font(.title3.bold())
                                        
                                        Text("\(place.country ?? "") \(place.locality ?? "")")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    } // VStack
                                } // HStack
                            } // Button
                            .navigationDestination(isPresented: $showMapView) {
                                MapView(address: $address, latitude: $latitude, longitude: $longitude ,showingMapSheet: $showingMapSheet)
                                    .environmentObject(locationManager)
                                    .navigationBarHidden(true)
                            }
                        } // ForEach
                    } // List
                    .listStyle(.plain)
                } else {
                    // MARK: - Live Location Button
                    Button {
                        // setting Map Region
                        if let coordinate = locationManager.userLocation?.coordinate {
                            locationManager.mapView.region = .init(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                            locationManager.addPin(coordinate: coordinate)
                            locationManager.updatePlacemark(location: .init(latitude: coordinate.latitude, longitude: coordinate.longitude))
                        }
                        // Navigation To MapView
                        showMapView = true
                    } label: {
                        Label {
                            Text("현재 위치")
                                .font(.callout)
                        } icon: {
                            Image(systemName: "location.north.circle.fill")
                        }
                        .foregroundColor(.accentColor)
                    } // Button label
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .navigationDestination(isPresented: $showMapView) {
                        MapView(address: $address, latitude: $latitude, longitude: $longitude ,showingMapSheet: $showingMapSheet)
                            .environmentObject(locationManager)
                            .navigationBarHidden(true)
                    }
                }
                
                
            } // VStack
            .padding()
            .frame(maxHeight: .infinity, alignment: .top)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        // 닫기 버튼 클릭 시 로그인 뷰(시트) 사라짐.
                        dismiss()
                    } label: {
                        Image(systemName: "multiply")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 17)
                            .foregroundColor(.gray)
                            .fontWeight(.light)
                    } // label
                } // ToolbarItem
            } // toolbar
        } // NavigationStack
    }
}

struct SearchAddressView_Previews: PreviewProvider {
    static var previews: some View {
        SearchAddressView(address: .constant("주소"), latitude: .constant(0.0) , longitude: .constant(0.0) ,showingMapSheet: .constant(true))
    }
}
