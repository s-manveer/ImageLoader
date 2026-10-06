//
//  ImageLoaderTests.swift
//  ImageLoaderTests
//
//  Created by Manveer Singh on 03/10/26.
//

import Foundation
import UIKit
import XCTest
@testable import ImageLoader

final class ImageLoaderTests: XCTestCase {

    func testLoadImageWithSuccessfulResponseReturnsImage() async throws {
        // Arrange
        let url = try XCTUnwrap(URL(string: "https://example.com/image.png"))
        let imageData = try XCTUnwrap(
            Data(
                base64Encoded:
                    "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII="
            )
        )
        let response = try XCTUnwrap(
            HTTPURLResponse(
                url: url,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )
        )
        let sessionSpy = NetworkSessionSpy(
            results: [.success((imageData, response))]
        )
        let sut = ImageLoader(session: sessionSpy)

        // Act
        let image = try await sut.loadImage(from: url)

        // Assert
        XCTAssertEqual(image.size, CGSize(width: 1, height: 1))
        let requestedURLs = await sessionSpy.requestedURLs
        XCTAssertEqual(requestedURLs, [url])
    }

}
