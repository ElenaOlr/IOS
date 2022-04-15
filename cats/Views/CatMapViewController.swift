import UIKit
import MapKit



class CatMapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        mapView.delegate = self
        
        let coords = CLLocationCoordinate2D(latitude: 44.422200886673714, longitude: 26.109487661371528)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coords
        annotation.title = "Miau Cafe Bucuresti"
        mapView.addAnnotation(annotation)
        
        let circle = MKCircle(center: coords, radius: 100000)
        mapView.addOverlay(circle)
    }
}

extension CatMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay.isKind(of: MKCircle.self) {
            let circleRenderer = MKCircleRenderer(overlay: overlay)
            circleRenderer.fillColor = UIColor.blue.withAlphaComponent(0.25)
            circleRenderer.strokeColor = UIColor.blue
            circleRenderer.lineWidth = 1
            return circleRenderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
}
