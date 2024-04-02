//  Copyright © 2020-2022 El Machine 🤖
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//
//  Created by Alex Kozin
//

import CoreLocation.CLLocation

/**

 #Usage
 ```
     |{ (location: CLLocation) in

     }

     CLAuthorizationStatus.authorizedAlways | { (location: CLLocation) in

     }

 ```
 */


extension CLLocation: AskingWithout {

    public 
    static func ask<T>(_ ask: Ask<T>, by wand: Wand) {

        //Save ask
        guard wand.ask(for: ask) else {
            return
        }

        //Request T for a first time

        //Prepare context
        let source: CLLocationManager = wand.obtain()

        //Set the cleaner before requesting
        ask.next = .one { _ in
            source.stopUpdatingLocation()

            print("Last")
        }
        ask.next?.next = ask //Save head

        //Make request
        wand | .while { (status: CLAuthorizationStatus) -> Bool in

            guard status != .notDetermined else {
                return true
            }

            switch ask {
                case is Ask<T>.One:
                    source.requestLocation()

                default:
                    source.startUpdatingLocation()
            }

            return false
        }.optional()

    }

}