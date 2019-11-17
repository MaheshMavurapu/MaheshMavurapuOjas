//
//  DisplayParse.swift
//  DownloadSample
//
//  Created by ojas on 17/11/19.
//  Copyright © 2019 ojas. All rights reserved.
//

import Foundation

// Json - parse - Hits
struct DisplayParse: Decodable {
    var hits: [Hits]
    
    private enum CodingKeys: String, CodingKey {
        case hits = "hits"
    }
}

// Json - Each Hit
struct Hits: Decodable {
    var title: String
    var created_At: String
    var points: Int
    
    private enum CodingKeys: String, CodingKey {
        case title = "title"
        case created_At = "created_at"
        case points = "points"
    }
}

// Json - Parse - Results
struct JsonParse {
    static let parse = JsonParse()
    private init() { }
    
    func parse(completion: @escaping (Result<Bool, Error>) -> ()) {
        guard let url = URL(string: "https://hn.algolia.com/api/v1/search_by_date?tags=story&page=1") else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do {
                //here dataResponse received from a network request
                let decoder = JSONDecoder()
                let posts = try decoder.decode(DisplayParse.self, from:
                    dataResponse) //Decode JSON Response Data
                CoreDataManager.sharedManager.savePosts(posts)
                completion(.success(true))
                print(posts)
            } catch let parsingError {
                print("Error", parsingError)
                completion(.failure(parsingError))
            }
        }
        task.resume()
    }
}
