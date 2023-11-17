//
//  MatchesInfoManager.swift
//  ESportsTracker
//
//  Created by f1nch on 15.11.23.
//

import Foundation

class MatchesInfoManager {
    static let shared = MatchesInfoManager()
    var liveMatchesInfo: LiveMatches?
    var selectedLiveMatch: Event?
    
    private init(){
        //self.updateAllCurrentLiveMatches()
    }
    
    func updateAllCurrentLiveMatches() {
        //должен делать запрос к апи за текущими матчами
        
        let headers = [
            "X-RapidAPI-Key": "af06df5541msh49a64a9df42bb9cp153137jsn4398a4d33471",
            "X-RapidAPI-Host": "esportapi1.p.rapidapi.com"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://esportapi1.p.rapidapi.com/api/esport/matches/live")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error as Any)
            } else {
                do {
                    self.liveMatchesInfo = try JSONDecoder().decode(LiveMatches.self, from: data!)
                } catch let parsingError as NSError {
                    print(parsingError.localizedDescription)
                }
            }
        })

        dataTask.resume()
    }
    
    func getLiveCSMatches(from matches: [Event]) -> [Event] {
        matches.filter{$0.tournament?.category?.flag == Flag.csgo}
    }
}
