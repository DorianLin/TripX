import UIKit

var greeting = "Hello, playground"

let events = ["a", "b"]
var waypoints = ""
if events.count > 2 {//waypoints > 0
    for event in events[1..<events.count-1] {
        print(event)
    }
}
