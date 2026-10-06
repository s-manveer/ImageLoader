# ImageLoader

A small Swift concurrency example for downloading and caching images in an iOS app.

## Features

- Actor-isolated state for thread-safe image loading
- In-memory caching with `NSCache`
- Coalescing of concurrent requests for the same URL
- HTTP status and image-data validation
- Injectable networking for focused unit tests

## Run locally

1. Open `ImageLoader/ImageLoader.xcodeproj` in Xcode.
2. Select the **ImageLoader** scheme and an iOS simulator.
3. Press **Run** (`⌘R`) or **Test** (`⌘U`).

The main implementation is in `ImageLoader/ImageLoader/ImageLoader.swift`.
