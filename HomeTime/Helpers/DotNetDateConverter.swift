//
//  Copyright (c) 2015 Tasvir Rohila. All rights reserved.
//

import Foundation


public class DotNetDateConverter: NSObject {
    public func dateFromDotNetFormattedDateString(string: NSString) -> NSDate! {
        let startPositionRange = string.rangeOfString("(")
        let endPositionRange = string.rangeOfString("+")
        if startPositionRange.location != NSNotFound && endPositionRange.location != NSNotFound {
            let startLocation = startPositionRange.location + startPositionRange.length
            let dateAsString = string.substringWithRange(NSRange(location: startLocation, length: endPositionRange.location - startLocation))
            let unixTimeInterval = (dateAsString as NSString).doubleValue / 1000
            return NSDate(timeIntervalSince1970: unixTimeInterval)
        }

        return nil
    }

    public func formattedDateFromString(string: NSString) -> NSString {
        let date = dateFromDotNetFormattedDateString(string)
        let formatter = NSDateFormatter()
        formatter.dateFormat = "HH:mm"
        //NOTE: modified the code to handle incorrect date
        if date != nil {
            return formatter.stringFromDate(date)
        }
        else {
            return "00:00"
        }
    }
}
