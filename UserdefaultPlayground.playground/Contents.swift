import UIKit

let defaults = UserDefaults.standard


defaults.set("KennethSidibe", forKey: "UserName")
defaults.set(true, forKey: "Evil")
let array = [1,2,5]
defaults.set(array, forKey: "FavNumber")




let personality = defaults.bool(forKey: "Evil")
let test = defaults.array(forKey: "FavNumber")
