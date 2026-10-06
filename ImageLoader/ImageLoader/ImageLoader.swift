//
//  ImageLoader.swift
//  ImageLoader
//
//  Created by Manveer Singh on 03/10/26.
//

import Foundation
import UIKit

actor ImageLoader {
    static let shared = ImageLoader(session: URLSession.shared)
    private let session: any NetworkSession
    private let cache = NSCache<NSURL, UIImage>()
    private var inFlightTasks: [URL: Task<UIImage, Error>] = [:]

    init(session: any NetworkSession) {
        self.session = session
    }

    func loadImage(from url: URL) async throws -> UIImage {
        if let cacheImage = cache.object(forKey: url as NSURL) {
            return cacheImage
        }

        if let task = inFlightTasks[url] {
            return try await task.value
        }

        let newTask = Task {
            try await downloadImage(from: url)
        }

        inFlightTasks[url] = newTask

        defer {
            inFlightTasks.removeValue(forKey: url)
        }

        let image = try await newTask.value
        cache.setObject(image, forKey: url as NSURL)

        return image
    }

    private func downloadImage(from url: URL) async throws -> UIImage {
        let (data, response) = try await session.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw ImageLoaderError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw ImageLoaderError.unsuccessfulStatusCode(httpResponse.statusCode)
        }

        guard let image = UIImage(data: data) else {
            throw ImageLoaderError.invalidImageData
        }

        return image
    }
}

enum ImageLoaderError: Error, Equatable {
    case invalidResponse
    case unsuccessfulStatusCode(Int)
    case invalidImageData
}
