# KMImageLoader
A Swift way to load and resize images.

Features:
1. Async download image from remote URL.
2. Cache images for specified amount of time (in seconds) to disk and memory.
3. Set max size to resize images once downloaded.
4. Round image corners.


Usage:

ImageLoader.sharedLoader.imageForUrl("http://example.com/img.png", completionHandler:{(image: UIImage!, url: String) in
    cell.imageView!.image = image
})
