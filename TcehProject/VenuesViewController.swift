

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation
import SDWebImage

protocol VenuesViewControllerDelegate {
    func venuesViewController(controller: VenuesViewController, didSelectVenue venue: Venue)
}


class VenuesViewController: UITableViewController {

    // MARK: Properties

    var venues = [Venue]()
    var delegate: VenuesViewControllerDelegate?
    let locationManager = CLLocationManager()

    // MARK: Actions

    @IBAction func tapCancel(sender: UIBarButtonItem) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.refreshLocation), forControlEvents: .ValueChanged)
        self.refreshControl = refreshControl


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return venues.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Remember to unwrapp as! VenueCell
        let cell = tableView.dequeueReusableCellWithIdentifier("VenueCell", forIndexPath: indexPath) as! VenueCell

        let iconURL = NSURL(string: venues[indexPath.row].icon)

        print(iconURL)

        cell.imageCategory.sd_setImageWithURL(iconURL)
        cell.labelVenue.text = venues[indexPath.row].name
        cell.labelDistance.text = "\(venues[indexPath.row].distance) m"
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let selectedVenue = venues[indexPath.row]
        dismissViewControllerAnimated(true, completion: nil)
        delegate?.venuesViewController(self, didSelectVenue: selectedVenue)
    }


}


// MARK: CLLocationManagerDelegate Methods

extension VenuesViewController: CLLocationManagerDelegate {

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            loadNearbyVenues(location)
            manager.stopUpdatingLocation()
        }
    }

    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .AuthorizedAlways, .AuthorizedWhenInUse:
            locationManager.startUpdatingLocation()
        case .NotDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            print("Not able to determine location. Please allow the app to use the location.")
        }
    }

    func refreshLocation() {
        locationManager.startUpdatingLocation()
    }

    func loadNearbyVenues(location: CLLocation) {

        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude

        let baseAPIURL = Env.FoursquareBaseApiURL

        print("\(lat), \(lon)")

        let params = [
            "ll": "\(lat),\(lon)",
            "client_id": Env.FoursquareClientId,
            "client_secret": Env.FoursquareClientSecret,
            "v": Env.FoursquareV
        ]

        Alamofire.request(.GET, baseAPIURL, parameters: params).responseJSON { response in
            if let value = response.result.value {
                let json = JSON(value)
                let jsonArray = json["response"]["venues"].array!
                var venues = [Venue]()
                for obj in jsonArray {
                    let name = obj["name"].string!
                    let distance = obj["location"]["distance"].int!
                    let latitude = obj["location"]["lat"].double!
                    let longitude = obj["location"]["lng"].double!
                    let id = obj["id"].string!

                    var category = ""
                    var icon = ""

                    if obj["categories"].count > 0 {
                        category = obj["categories"][0]["name"].string!
                        icon = obj["categories"][0]["icon"]["prefix"].string!
                        icon += "bg_64"
                        icon += obj["categories"][0]["icon"]["suffix"].string!
                    } else {
                        category = "[unknown]"
                        icon = "https://ss3.4sqi.net/img/categories_v2/none_bg_64.png"
                    }

                    let venue = Venue(name: name,
                        latitude: latitude,
                        longitude: longitude,
                        distance: distance,
                        category: category,
                        icon: icon,
                        id: id)
                    venues.append(venue)
                }

                venues.sortInPlace() { $0.distance < $1.distance }
                self.venues = venues
                self.tableView.reloadData()
                self.refreshControl!.endRefreshing()
            }
        }
    }
}

