//import Alamofire
//import UIKit
//func call(method: Alamofire.Method, url: String) -> Observable<AnyObject> {
//    return create { observer -> Disposable in
//        Alamofire.request("",
//                          method, url)
//            .response { response in
//                switch response.result {
//                case .Success(let value):
//                    observer.on(.Next(value))
//                    observer.on(.Completed)
//                case .Failure(let error):
//                    observer.on(.Error(error))
//                }
//        }
//        return AnonymousDisposable { }
//    }
//}
//func getResponse() -> Observable<AnyObject> {
//    return Observable.create { observer in
//        Alamofire.request(
//            self.baseUrl
//        )
//            .response { response in
//                switch response.result {
//                case .Success(let value):
//                    observer.onNext(value)
//                    observer.onCompleted()
//                case .Failure(let error):
//                    observer.onError(error)
//                }
//        }
//        return Disposables.create()
//    }
//}
//
//AF.request("https://httpbin.org/get",
//            method: .get
//).response { response in
//        debugPrint(response)
//}
//
//AF.request("https://api.steampowered.com/ISteamUserStats/GetUserStatsForGame/v2/",
//           method: .get,
//           parameters: [
//            "key" : self.steamKey,
//            "steamid" : self.steamID,
//            "appid" : self.dbd],
//           encoding: URLEncoding(destination: .queryString)
//
//).response { response in
//    switch response.result {
//    case .success:
//        guard let data = response.data else {
//            print("ERROR: Error with response")
//            return
//        }
//        do {
//            let decoder = JSONDecoder()
//            let result = try decoder.decode(ResultStats.self, from: data)
//            debugPrint(result)
//        }catch {
//
//        }
//    case .failure(let error):
//        print("ERROR: \(error)")
//    }
//}
///* close - getUserStats */
