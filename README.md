# Self-sizing UICollectionViewCells in UITableView

This app demostrates how to use self-sizing `UICollectionViewCells` that contain a `UILabel`, contained in a self-sizing `UICollectionView`, embedded in a self-sizing `UITableViewCell`.

### Supported features of this setup:
- Dynamic Type
- Orientation change (portrait <-> landscape)

### Implementation notes

This setup also shows how implement a max-width restriction of self-sizing `UICollectionViewCell`s so they don't grow larger than the size that is supported by layout (in order to avoid undefined behaviour of `UICollectionViewFlowLayout`). This is implemented by a custom subclass of `UICollectionViewLayoutAttributes` which allows us to pass the maximum allowed width to the cells.

## GIF or didn't happen

![Self-sizing UICollectionViewCells in UITableView](https://github.com/tomaskraina/SelfSizing-UICollectionViewCell-in-UITableView/blob/master/self-sizing-uicollectionviewcells-in-tableview.gif?raw=true)

## Requirements

- iOS 11.0+
- Xcode 10.2.1+
- Swift 5+

## Contact
Tom Kraina, me@tomkraina.com

