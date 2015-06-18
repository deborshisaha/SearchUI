# SearchUI

A library that presents a search UI for searching items that are location based. Which means the UI includes two critical text fields. First, text field is to enter the item you are searching for and the second text field is a location auto-complete powered by Google Geocoding API

Version 1.0

### Dependencies
 * AFNetworking - To make API call to Google's Geocoding API
 * Google's geocode API - To make location suggestion

### Installation
It is very simple to integrate this library into your project. To integrate this project, 
 * Drag & drop 'AFNetworking' folder and 'DSSearchUI' folder into your project.
 * Enable Google's Geocoding API from here. This would give you an API key. Add this API Key in "GeocodingAPIKey.h" file.
 * Pods coming soon
 
### Usage

```objective-c
@interface MasterViewController () <DSLocationBasedSearchUIDelegate>
@property (nonatomic, strong)DSLocationBasedSearchUI *searchUI;
@end
...
- (void)viewDidLoad {
...
    if (!_searchUI) {
        _searchUI = [[DSLocationBasedSearchUI alloc] initWithViewController:self];
    }
    
    self.searchUI.tintColor = [UIColor colorWithRed:196.0f/255.0f green:2.0f/255.0f blue:2.0f/255.0f alpha:1.0f];
    self.searchUI.delegate = self;
    self.searchUI.searchUIFont = [UIFont fontWithName:@"AvenirNext-Medium" size:16.0f];
...
}

#pragma mark DSLocationBasedSearchUIDelegate
- (void) didStartEditingSearchText {
    NSLog(@"%s",__PRETTY_FUNCTION__);
}

- (void) autoSuggestedLocationSelected:(DSAutoSuggestedLocation *)autoSuggestedLocationItem {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void) searchTextDidChange:(NSString *) text {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void) didSelectSearchedItemAtIndex:(NSInteger)index {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
```
### Contact
Deborshi Saha (deborshi dot saha at gmail dot com)

### License
SearchUI is available under the MIT license. See the LICENSE file for more info.
