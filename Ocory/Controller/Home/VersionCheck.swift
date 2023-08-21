//
//  VersionCheck.swift
//  Ocory
//
//  Created by malika on 06/02/23.
//

import Foundation
import Alamofire

enum VersionError: Error {
    case invalidResponse, invalidBundleInfo
}

class VersionCheck {
    
    public static let shared = VersionCheck()
    
    func isUpdateAvailable(completion: @escaping (Bool?, Error?) -> Void) throws -> URLSessionDataTask {
        guard let info = Bundle.main.infoDictionary,
              let currentVersion = info["CFBundleShortVersionString"] as? String,
              let identifier = info["CFBundleIdentifier"] as? String,
              let url = URL(string: "https://itunes.apple.com/lookup?bundleId=\(identifier)") else {
            throw VersionError.invalidBundleInfo
        }
        print("currentVersion",currentVersion)
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                if let error = error { throw error }
                guard let data = data else { throw VersionError.invalidResponse }
                let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any]
                guard let result = (json?["results"] as? [Any])?.first as? [String: Any], let appStore = result["version"] as? String else {
                    throw VersionError.invalidResponse
                }
                let versionCompare = currentVersion.compare(appStore, options: .numeric)
                if versionCompare == .orderedSame {
                    print("same version")
                    completion(false, nil)
                } else if versionCompare == .orderedAscending {
                    // will execute the code here
                    print("ask user to update")
                    completion(true, nil)
                } else if versionCompare == .orderedDescending {
                    // execute if current > appStore
                    print("don't expect happen...")
                    completion(false, nil)
                }
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
        return task
    }
}
