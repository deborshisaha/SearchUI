//
//  DSAutoSuggestedLocation.m
//  DSSearchUI
//
//  Created by Deborshi Saha on 6/16/15.
//  Copyright (c) 2015 Deborshi Saha. All rights reserved.
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//	THE SOFTWARE.

#import "DSAutoSuggestedLocation.h"
#import <UIKit/UIKit.h>

@interface DSAutoSuggestedLocation(){
    
    BOOL currentLocation;
}
@end

@implementation DSAutoSuggestedLocation

- (BOOL) isCurrentLocation {
    return currentLocation;
}

- (instancetype) initAsCurrentLocation {
    self = [super init];
    if (self) {
        currentLocation = YES;
    }
    return self;
}

- (instancetype)copyWithZone:(NSZone *)zone
{
    DSAutoSuggestedLocation *copy = [super copy];
    
    copy.city = self.city;
    copy.country = self.country;
    copy.locality = self.locality;
    copy.state =self.state;
    copy.pincode = self.pincode;
    
    return copy;
}

- (instancetype) initWithDictionary: (NSDictionary *) dictionary {
    self = [super init];
    if (self) {
        
        for (int i=0; i < ((NSArray *)dictionary[@"address_components"]).count; i++) {
            
            NSDictionary *addressComponentsDict = dictionary[@"address_components"][i];
            NSArray *addressComponentTypes = addressComponentsDict[@"types"];
            
            if (addressComponentTypes.count == 0) {
                return nil;
            }
            
            if ([addressComponentTypes[0] isEqualToString:@"country"]) {
                
                _country = addressComponentsDict[@"long_name"];
                
            } else if ([addressComponentTypes[0] isEqualToString:@"locality"] ||
                       [addressComponentTypes[0] isEqualToString:@"sublocality_level_1"]) {
                
                if (!_locality) {
                    _locality = addressComponentsDict[@"long_name"];
                }
                
            } else if ([addressComponentTypes[0] isEqualToString:@"administrative_area_level_2"]) {
                _city = addressComponentsDict[@"long_name"];
            } else if ([addressComponentTypes[0] isEqualToString:@"administrative_area_level_1"]) {
                _state = addressComponentsDict[@"long_name"];
            } else if ([addressComponentTypes[0] isEqualToString:@"postal_code"]) {
                _pincode = addressComponentsDict[@"long_name"];
            }
        }
        
        if (!self.state || !self.country || !self.locality) {
            return nil;
        }
    }
    
    return self;
}

- (NSString *) getTitle {
    
    if (self.isCurrentLocation) {
        return @"Current Location";
    }
    
    return [NSString stringWithFormat:@"%@", self.locality];
}

- (NSString *) getDescriptionTitle {
    
    if (self.isCurrentLocation) {
        return @"";
    }
    
    return [NSString stringWithFormat:@"%@", self.state];;
}

- (void) getImageInBackground:(DSAutoSuggestedItemImage)block {
    
    if (self.currentLocation) {
        block([UIImage imageNamed:@"current_location-100@2x.png"], nil);
    }
}
@end
