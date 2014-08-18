import UIKit

let ConfigurationManagerSharedInstance = ConfigurationManager()

enum DeviceType:String {
    case IPAD = "~ipad"
    case IPAD2x = "@2x~ipad"
}

class ConfigurationManager : NSObject {
    var globalDic: NSMutableDictionary = NSMutableDictionary()
    var deviceType:DeviceType!
    func setDeviceType(frameWidth:CGFloat) {
        if frameWidth==768.0 {
            deviceType = DeviceType.IPAD
        } else if frameWidth==1536.0 {
            deviceType = DeviceType.IPAD2x
        }
        
    }
    func getDeviceType()->DeviceType {
        return deviceType
    }
    
    
    class var sharedInstance:ConfigurationManager {
        return ConfigurationManagerSharedInstance
    }
        
    override init() {
        super.init()
        println ("Config Init been Initiated, this will be called only onece irrespective of many calls")
    }
}

/*

Read:
println(ConfigurationManager.sharedInstance.globalDic)


Write:
ConfigurationManager.sharedInstance.globalDic = tmpDic // tmpDict is any value that to be shared among the application

*/