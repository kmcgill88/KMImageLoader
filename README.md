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

## Licenses

All source code is licensed under the [MIT License](https://raw.github.com/rs/SDWebImage/master/LICENSE).


