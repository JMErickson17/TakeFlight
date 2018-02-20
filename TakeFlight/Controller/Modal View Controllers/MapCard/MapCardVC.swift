//
//  MapCardVC.swift
//  TakeFlight
//
//  Created by Justin Erickson on 2/16/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import UIKit
import MapKit

class MapCardVC: UIViewController {

    // MARK: Properties
    
    private var flightPathPolyline: MKGeodesicPolyline?
    private var planeAnnotation: PlaneAnnotation?
    private var planeAnnotationPosition = 0
    private var planeDirection: CLLocationDirection?
    private let steps = 5
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.mapType = .standard
        mapView.delegate = self
        mapView.isUserInteractionEnabled = false
        return mapView
    }()
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    // MARK: Setup
    
    private func setupView() {
        view.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: Public API
    
    func addFlightPathAnnotations(from origin: Coordinates, to destination: Coordinates) {
        let origin = CLLocation(latitude: origin.latitude, longitude: origin.longitude)
        let originAnnotation = AirportAnnotation(title: "Origin", coordinate: origin.coordinate)
        
        let destination = CLLocation(latitude: destination.latitude, longitude: destination.longitude)
        let destinationAnnotation = AirportAnnotation(title: "Destination", coordinate: destination.coordinate)
        
        mapView.addAnnotation(originAnnotation)
        mapView.addAnnotation(destinationAnnotation)
        
        var annotations = [originAnnotation, destinationAnnotation].map { $0.coordinate }
        let arcPolyLine = MKGeodesicPolyline(coordinates: &annotations, count: annotations.count)
        self.flightPathPolyline = arcPolyLine
        mapView.add(arcPolyLine)
        animatePlaneAnnotation()
    }
    
    // MARK: Convenience
    
    private func animatePlaneAnnotation() {
        guard planeAnnotation == nil else { return }
        let annotation = PlaneAnnotation(reuseIdentifier: "Plane", image: #imageLiteral(resourceName: "AirplaneAnnotation"))
        mapView.addAnnotation(annotation)
        self.planeAnnotation = annotation
        self.updatePlanePosition()
    }
    
    @objc private func updatePlanePosition() {
        guard let flightPathPolyline = flightPathPolyline else { return }
        guard planeAnnotationPosition + steps < flightPathPolyline.pointCount else { return }
        let points = flightPathPolyline.points()
        
        let previousMapPoint = points[planeAnnotationPosition]
        self.planeAnnotationPosition += steps
        let nextMapPoint = points[planeAnnotationPosition]
        
        self.planeDirection = directionBetweenPoints(previousMapPoint, destination: nextMapPoint)
        self.planeAnnotation?.coordinate = MKCoordinateForMapPoint(nextMapPoint)
        perform(#selector(updatePlanePosition), with: nil, afterDelay: 0.03)
    }
    
    private func directionBetweenPoints(_ source: MKMapPoint, destination: MKMapPoint) -> CLLocationDirection {
        let x = destination.x - source.x
        let y = destination.y - source.y
        return radiansToDegrees(atan2(y, x)).truncatingRemainder(dividingBy: 360) + 90
    }
    
    private func radiansToDegrees(_ radians: Double) -> Double {
        return radians * 180 / .pi
    }
    
    private func degreesToRadians(_ degrees: Double) -> Double {
        return degrees * .pi / 180
    }
}

// MARK:- MKMapViewDelegate

extension MapCardVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? PlaneAnnotation else { return MKAnnotationView() }
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotation.reuseIdentifier) ??
            MKAnnotationView(annotation: annotation, reuseIdentifier: annotation.reuseIdentifier)
        annotationView.image = annotation.image
        if let planeDirection = self.planeDirection {
            annotationView.transform = CGAffineTransform(rotationAngle: CGFloat(degreesToRadians(planeDirection)))
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer()
        }
        
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = UIColor.primaryBlue
        renderer.lineWidth = 1
        
        return renderer
    }
}
