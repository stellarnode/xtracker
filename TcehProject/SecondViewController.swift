

import UIKit
import MapKit


class SecondViewController: UIViewController, MKMapViewDelegate {

    let mapView = MKMapView()

    var entries = [Entry]()

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        entries = Entry.loadEntries()
        self.addAnnotations()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(mapView)
        mapView.frame = self.view.bounds // CGRect(x: 0, y: 0, width: 320, height: 320)
        mapView.center = self.view.center

        mapView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .Follow


        mapView.showsScale = true
        mapView.showsCompass = true
        mapView.delegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func addAnnotations() {

        mapView.removeAnnotations(mapView.annotations)

        for entry in entries {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: entry.venue.latitude, longitude: entry.venue.longitude)
            annotation.title = String(format: "%.2f", entry.amount) + " for \(entry.category)"
            annotation.subtitle = entry.venue.name
            mapView.addAnnotation(annotation)
        }


    }


    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        var view = mapView.dequeueReusableAnnotationViewWithIdentifier("entry") as? MKPinAnnotationView

        if view == nil {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "entry")
        } else {
            view?.annotation = annotation
        }

        view?.canShowCallout = true
        view?.pinTintColor = UIColor.blueColor()
        view?.animatesDrop = true
        return view!

    }
    
}

