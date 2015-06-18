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
I have added comments in the code.

```objective-c
@interface MasterViewController () <DSLocationBasedSearchUIDelegate>
@property (nonatomic, strong)DSLocationBasedSearchUI *searchUI;
@end

@implementation MasterViewController

- (void)viewDidLoad {
...
    if (!_searchUI) {
        _searchUI = [[DSLocationBasedSearchUI alloc] initWithViewController:self];
        // target view controller should have a NavigationController as rootViewController
        // It is the navigation bar where buttons for will appear.
    }
    
    // Set color of Search box
    self.searchUI.tintColor = [UIColor colorWithRed:196.0f/255.0f green:2.0f/255.0f blue:2.0f/255.0f alpha:1.0f];
    
    // MasterViewController here implements the protocol 'DSLocationBasedSearchUIDelegate'
    self.searchUI.delegate = self;
    
    // Set the font of search ui
    self.searchUI.searchUIFont = [UIFont fontWithName:@"AvenirNext-Medium" size:16.0f];
...
}

#pragma mark DSLocationBasedSearchUIDelegate
- (void) didStartEditingSearchText {
    // Called when the user starts searching for the item that is location based. For e.g. Businesses, Restaurants etc.
}

- (void) autoSuggestedLocationSelected:(DSAutoSuggestedLocation *)autoSuggestedLocationItem {
    // Called when a location gets selected. This object contains information like city, state, country, pincode.
    // We can subclass CLPlacemark to fill more details
}

- (void) searchTextDidChange:(NSString *) text {
    // This is a callback whenever the text for searched item changes.
    
    // Add code here to fetch results from the backend. 
    
    // If you are using objects (which you created after parsing JSON or XML), please note that objects
    // must implement 'DSAutosuggestedItemDelegate' protocol.
    
    // Now to list results in auto suggest, you need to do the following
    [self setSuggestedItems: <array_of_resulting_objects>];
}

- (void) didSelectSearchedItemAtIndex:(NSInteger)index {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
@end
```

### Room for improvement
* Requests to Google Geocoding API is for locations in India. There should be a way to pick country/countries.

### Contact
Deborshi Saha (deborshi dot saha at gmail dot com)

### License
SearchUI is available under the MIT license. See the LICENSE file for more info.
