# KMImageLoader

A Swift way to load and resize images.
--------------------------------------

Features:
- Async download image from remote URL.
- Cache images for specified amount of time (in seconds) to disk and memory.
- Set max size to resize images once downloaded.
- Round image corners.


How To Use
----------

### Using KMImageLoader.swift with UITableView

Just add KMImageLoader.swift to your project and configure these three properties if you like.

```swift
let errorImage = UIImage(named: "error-image.png")
let MAX_SIZE:CGFloat = 400
let SECONDS_SINCE_DISK_CACHE_CLEAN = 60
```

Then use it like so...


```swift
override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

let cell = tableView.dequeueReusableCellWithIdentifier("testCell", forIndexPath: indexPath) as! KMTableViewCell

var url = urls[indexPath.row]

ImageLoader.sharedLoader.imageForUrl(url, completionHandler:{(image: UIImage!, url: String) in
    cell.imageView!.image = image
})

cell.titleLabel?.text = "\(indexPath.row)"

return cell
}
```

## License

The MIT License (MIT)

Copyright (c) 2015 Kevin McGill - McGill DevTech, LLC

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.


