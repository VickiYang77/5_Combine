//
//  AnimalService.swift
//

import Foundation

class AnimalService {
    
    static func fetchData(count: UInt = 20, for page: UInt = 0, completion: @escaping (Result<[Animal], Error>) -> Void) {
        
        let urlString = "https://data.coa.gov.tw/Service/OpenData/TransService.aspx?UnitId=QcbUEzN6E6DL&$top=\(count)&$skip=\(page * count)&animal_kind=狗"
        
        guard let urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error!))
                return
            }
            do {
                let animalDatas = try JSONDecoder().decode([Animal].self, from: data)
                completion(.success(animalDatas))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
