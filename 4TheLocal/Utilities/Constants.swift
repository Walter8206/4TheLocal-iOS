

//import Foundation
//
//class Constant{
//
//    static let shared = Constant()
//
//    //static let baseUrl = "http://4thelocal.com"//Prod
//    //static let baseSchoolUrl = "https://4thelocalschools.com"//Prod
//
//    static let consmrKey = "ck_cac6e5bd159ce78d4c9939da5987d15576444007"
//    static let consmrKey_scl = "ck_ffa0079b6e0fc22cdaef78cdd04f43198d5e28e0"
//    static let consmrSecret = "cs_357fd9c41936191b74c61048a270e059f28283a7"
//    static let consmrSecret_scl = "cs_067817f1f7efb239414007a52867f2e3975a16c1"
//
//    static let stripeBearer = "Bearer sk_test_51GvrVzKFV5GDVcmXabLephK8SBQ1Os2fyQi6dygoOt3XeDPqxTwm8sv5jIR2gffquSEHa4oBT2kvcumuR8dKrVup00Tk3ZZ9XX"
//
//    //Items for Account tab
//    static let accItems = [ "Orders", "Addresses", "Charity", "Business Setup", "Log Out"]
//    static let sclAccItems = [ "Orders", "Addresses", "School Setup", "Business Setup", "Log Out"]
//
//    static let subtotal = "Subtotal"
//    static let total = "Total"
//    static let filterBusinessTitle = "All Business types"
//    static let filterCharityTitle = "All Charity types"
//    static let filterCityTitle = "All Cities"
//    static var OrderItemList = [OrderItem]()
//
//    // Links
//    static let facebookLink = "https://www.facebook.com/4TheLocal/"
//    static let instagramLink = "https://www.instagram.com/4thelocal/"
//    var benefits:String{getBaseUrl() + "/business-signup-info-page/"}
//    var businessSignupLink:String{getBaseUrl() + "/signup-your-business/"}
//    var schoolSignupLink:String{getBaseUrl() + "/school-signup/"}
//    var uploadImageLink:String{getBaseUrl() + "/wp-json/wp/v2/media"}
//    var faq:String{getBaseUrl() + "/faq-page/"}
//    var supportLink:String{getBaseUrl() + "/support/"}
//    var privacyLink: String{getBaseUrl() + "/privacy-policy/"}
//
//
//    var consumerKey: String{
//        if MyUserDefaults.shared.getBool(key: MyUserDefaults.isSchoolKey) {
//            return Constant.consmrKey_scl
//        }
//        return Constant.consmrKey
//    }
//
//    var consumerSecret: String{
//        if MyUserDefaults.shared.getBool(key: MyUserDefaults.isSchoolKey) {
//            return Constant.consmrSecret_scl
//        }
//        return Constant.consmrSecret
//    }
//
//    func getBaseUrl()-> String{
//        if MyUserDefaults.shared.getBool(key: MyUserDefaults.isSchoolKey) {
//            return "https://4thelocalschools.rifat-ahmed.com"
//        }
//        return "https://4thelocal.rifat-ahmed.com"
//    }
//
//    func getAdminUser()-> String{
//        if MyUserDefaults.shared.getBool(key: MyUserDefaults.isSchoolKey) {
//            return "rifat.nsu@gmail.com"
//        }
//        return "addmin_4tl"
//    }
//
//    func getAdminPass()-> String{
//        if MyUserDefaults.shared.getBool(key: MyUserDefaults.isSchoolKey) {
//            return "Dhaka@123456"
//        }
//        return "msTB9s12akrf7vSBtbVQV3Vi"
//    }
//
//}


import Foundation

class Constant{
    
    static let shared = Constant()
    
    
    static let processingFeeAmount = 1.5

    static let consmrKey = "ck_3368dad2e5efcaf3e21ece7475a4da0a27a78a0c"
    static let consmrKey_scl = "ck_7c5d6233eb917fe09fb4feadfd47b1891d3ea456"
    static let consmrSecret = "cs_23746813cb6e1f4ade90b9007bcc30b2210d8e21"
    static let consmrSecret_scl = "cs_24c6843a7d8d97b9c32f57659ce50e56bc2f55c2"
    
    static let stripeBearer = "Bearer sk_test_51GvrVzKFV5GDVcmXabLephK8SBQ1Os2fyQi6dygoOt3XeDPqxTwm8sv5jIR2gffquSEHa4oBT2kvcumuR8dKrVup00Tk3ZZ9XX"
    
    //Items for Account tab
    static let accItems = [ "Orders", "Addresses", "Charity", "Business Setup", "Log Out"]
    static let sclAccItems = [ "Orders", "Addresses", "Business Setup", "Log Out"]
    
    static let subtotal = "Subtotal"
    static let total = "Total"
    static let processingFee = "Processing Fee"
    static let filterBusinessTitle = "All Business types"
    static let filterCharityTitle = "All Charity types"
    static let filterCityTitle = "All Cities"
    static var OrderItemList = [OrderItem]()
    
    // Links
    static let facebookLink = "https://www.facebook.com/4TheLocal/"
    static let instagramLink = "https://www.instagram.com/4thelocal/"
    var benefits:String{getBaseUrl() + "/business-signup-info-page/"}
    var businessSignupLink:String{getBaseUrl() + "/signup-your-business/"}
    var schoolSignupLink:String{getBaseUrl() + "/school-signup/"}
    var uploadImageLink:String{getBaseUrl() + "/wp-json/wp/v2/media"}
    var faq:String{getBaseUrl() + "/faq-page/"}
    var supportLink:String{getBaseUrl() + "/support/"}
    var privacyLink: String{getBaseUrl() + "/privacy-policy/"}

    
    var consumerKey: String{
        if MyUserDefaults.shared.getBool(key: MyUserDefaults.isSchoolKey) {
            return Constant.consmrKey_scl
        }
        return Constant.consmrKey
    }
    
    var consumerSecret: String{
        if MyUserDefaults.shared.getBool(key: MyUserDefaults.isSchoolKey) {
            return Constant.consmrSecret_scl
        }
        return Constant.consmrSecret
    }
    
    func getBaseUrl()-> String{
        if MyUserDefaults.shared.getBool(key: MyUserDefaults.isSchoolKey) {
            return "https://4thelocalschools.com"
        }
        return "https://4thelocal.com"
    }
    
    func getAdminUser()-> String{
        if MyUserDefaults.shared.getBool(key: MyUserDefaults.isSchoolKey) {
            return "rifat.nsu@gmail.com"
        }
        return "rifat.nsu@gmail.com"
    }
    
    func getAdminPass()-> String{
        if MyUserDefaults.shared.getBool(key: MyUserDefaults.isSchoolKey) {
            return "Dhaka@123456"
        }
        return "is7Nim&j(oig^a4(o!rK^E@c"
    }
    
}


