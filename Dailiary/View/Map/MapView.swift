//
//  MapView.swift
//  Dailiary
//
//  Created by 박민주 on 2023/01/12.
//

import SwiftUI
import MapKit

// MARK: - MapView Live Selection
struct MapView: View {
    @EnvironmentObject var locationManager: LocationManager
    @Environment(\.dismiss) var dismiss
    @Binding var address: String
    @Binding var latitude: Double
    @Binding var longitude: Double
    @Binding var showingMapSheet: Bool
    
    var body: some View {
        ZStack {
            MapViewHelper()
                .environmentObject(locationManager)
                .ignoresSafeArea()
            
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title2.bold())
                    .foregroundColor(.primary)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            

            
            // MARK: Displaying Data
            if let place = locationManager.pickedPlaceMark {
                VStack(spacing: 15) {
                    Text("오늘 하루, 여기서 보내셨나요?")
                        .font(.title3.bold())
                        .padding(.top)
                    
                    HStack(spacing: 15) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.title2)
                            .foregroundColor(.gray)
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text(place.name ?? "")
                                .font(.body)
                            
                            Text("\(place.country ?? "") \(place.locality ?? "")")
                                .font(.caption)
                                .foregroundColor(.gray)
                        } // VStack
                    } // HStack
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 10)
                    
                    Button {
                        if let locality = place.locality {
                            address = "\(place.country ?? "") \(locality) \(place.name ?? "")"
                        } else {
                            address = "\(place.country ?? "") \(place.name ?? "")"
                        }
                        latitude = locationManager.pickedLocation?.coordinate.latitude ?? 0.0
                        longitude = locationManager.pickedLocation?.coordinate.longitude ?? 0.0
                        showingMapSheet = false
                    } label: {
                        Text("이 위치로 설정하기")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background {
                                RoundedRectangle(cornerRadius: 10 ,style: .continuous)
                                    .fill(Color.accentColor)
                            }
                            .foregroundColor(.white)
                    } // Button
                } // VStack
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 10 ,style: .continuous)
                        .fill(.white)
                        .ignoresSafeArea()
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
            } // if let
        } // ZStack
        .onDisappear {
            // 핀을 옮길 때 기존의 핀 없애기
            locationManager.pickedLocation = nil
            locationManager.pickedPlaceMark = nil
            
            locationManager.mapView.removeAnnotations(locationManager.mapView.annotations)
        }
    } // body
}

// MARK: - UIKit MapView
struct MapViewHelper: UIViewRepresentable {
    @EnvironmentObject var locationManager: LocationManager
    func makeUIView(context: Context) -> MKMapView {
        return locationManager.mapView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(address: .constant("주소"), latitude: .constant(0.0) , longitude: .constant(0.0) ,showingMapSheet: .constant(true))
    }
}
