@objc(LocationTrackPlugin) class LocationTrackPlugin : CDVPlugin{
// MARK: Properties
var pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR)

 var locationManager: CLLocationManager?
 let udid = UIDevice.current.identifierForVendor?.uuidString ?? ""
 var empID = ""
@objc(add:) func add(_ command: CDVInvokedUrlCommand) {
var pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR)
let param1 = (command.arguments[0] as? NSObject)?.value(forKey: "param1") as? Int
let param2 = (command.arguments[0] as? NSObject)?.value(forKey: "param2") as? Int
if let p1 = param1 , let p2 = param2 {
if p1 >= 0 && p1 >= 0{
 let total = String(p1 + p2)
pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: total)
}else {
pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Something wrong")
}
}
self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
}

@objc(trackLocation:) func trackLocation(_ command: CDVInvokedUrlCommand) {
empID = (command.arguments[0] as? NSObject)?.value(forKey: "empID") as? String

 locationManager = CLLocationManager()
 locationManager?.delegate = self
 locationManager?.requestAlwaysAuthorization()
 startTracking()
}
@objc(stopTracking:) func stopTracking(_ command: CDVInvokedUrlCommand) {
        var pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR)
        locationManager?.stopUpdatingLocation()
        pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "Success.")
        }

 func startTracking() {
        locationManager?.startUpdatingLocation()
        locationManager?.startMonitoringSignificantLocationChanges()
        locationManager?.allowsBackgroundLocationUpdates = true
    }

 func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            // you're good to go!
        } else {

        }

    }
     func passLocationToServer(latitude: String, longitude: String) {
            let formFields = ["latitude": latitude, "longitude": longitude , "deviceId": udid, "employeeId": empID]
            let boundary = "Boundary-\(UUID().uuidString)"
            var request = URLRequest(url: URL(string: "https://app.sascolive.com/APIScripts/API/saveLocationCordinates")!)
            request.httpMethod = "POST"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

            let httpBody = NSMutableData()
            for (key, value) in formFields {
              httpBody.appendString(convertFormField(named: key, value: value, using: boundary))
            }
            request.httpBody = httpBody as Data
            print(String(data: httpBody as Data, encoding: .utf8)!)
            URLSession.shared.dataTask(with: request) { data, response, error in
                 var pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR)
                 if error != nil {
                pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Something wrong")
                 } else {
                pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "API success.")
                }
              // handle the response here
            }.resume()
        }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            // Hit api to update location
            passLocationToServer(latitude: "\(location.coordinate.latitude)", longitude: "\(location.coordinate.longitude)")
        }
    }
}