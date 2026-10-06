//
//  NetworkSession.swift
//  ImageLoader
//
//  Created by Manveer Singh on 03/10/26.
//

import Foundation

nonisolated protocol NetworkSession: Sendable {
    func data(from url: URL) async throws -> (Data, URLResponse)
}

extension URLSession: NetworkSession {}
