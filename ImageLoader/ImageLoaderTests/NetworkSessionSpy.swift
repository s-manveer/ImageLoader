//
//  NetworkSessionSpy.swift
//  ImageLoaderTests
//
//  Created by Manveer Singh on 03/10/26.
//

import Foundation
@testable import ImageLoader

actor NetworkSessionSpy: NetworkSession {
    typealias Output = (Data, URLResponse)
    private var results: [Result<Output, Error>]
    private(set) var requestedURLs: [URL] = []

    init(results: [Result<Output, Error>]) {
        self.results = results
    }

    func data(from url: URL) async throws -> Output {
        requestedURLs.append(url)

        if results.isEmpty { throw TestDoubleError.missingScriptedResult }

        let result = results.removeFirst()

        return try result.get()
    }
}

enum TestDoubleError: Error {
    case missingScriptedResult
}
