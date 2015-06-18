//
//  DSLocationSuggestor.m
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

#import "DSLocationSuggestor.h"
#import "AFNetworking.h"
#import "DSAutoSuggestedLocation.h"
#import "GeocodingAPIKey.h"

static NSString * const BaseURLString = @"https://maps.googleapis.com/maps/api/geocode/json?";

@implementation DSLocationSuggestor

+ (void) fetchAutoCompletedResultsForText:(NSString *) searchText inBackground:(DSLocationSuggestorBlock) block {
    
    if (!APIKey || APIKey.length == 0) {
        [NSException raise:@"GoogleAPIKeyMissingException" format:@"Google Geocoding API Key is missing. You may include the key \"GeocodingAPIKey.h\""];
    }
    
    if (!searchText || (searchText && searchText.length <= 3)) {
        return;
    }
    
    NSString *newSearchText = [searchText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *URLString = [NSString stringWithFormat:@"%@address=%@&components=country:IN&sensor=true&key=%@", BaseURLString, newSearchText, APIKey];
    
    NSURL *url = [NSURL URLWithString:URLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 2
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]] && [responseObject[@"status"] isEqualToString:@"OK"]) {
            
            NSMutableArray *mArray = [NSMutableArray array] ;
            
            for (int i=0; i<((NSArray *)responseObject[@"results"]).count; i++) {
                DSAutoSuggestedLocation *lr = [[DSAutoSuggestedLocation alloc] initWithDictionary:(responseObject[@"results"][i])];
                if (lr) {
                    [mArray addObject:lr];
                }
            }
            
            block(mArray, nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSError *err = [NSError errorWithDomain:@"Hello" code:404 userInfo:nil];
        block(nil,  err);
    }];
    
    // 5
    [operation start];
    
}

@end
