//
//  HuggingFaceService.swift
//  ChatMLX
//
//  Created by John Mai on 2024/11/10.
//
import Alamofire
import Foundation

struct ModelQuery {

}

struct HuggingFaceService {
    static let shared = HuggingFaceService()

    func fetchMLXCommunityModels(search: String? = nil) async -> [RemoteModel] {
        var urlComponents = URLComponents(string: "https://huggingface.co/api/models")!

        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "limit", value: "20"),
            URLQueryItem(name: "author", value: "mlx-community"),
            URLQueryItem(name: "sort", value: "downloads"),
            URLQueryItem(name: "pipeline_tag", value: "text-generation"),
        ]

        if let search, !search.isEmpty {
            queryItems.append(URLQueryItem(name: "search", value: search))
        }

        urlComponents.queryItems = queryItems

        guard let url = urlComponents.url else {
            return []
        }

        do {
            AF.request("https://huggingface.co/api/models")

            return []
        }
    }
}
