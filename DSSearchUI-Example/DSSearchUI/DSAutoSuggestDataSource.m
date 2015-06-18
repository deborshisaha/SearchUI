//
//  DSAutoSuggestDataSource.m
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

#import "DSAutoSuggestDataSource.h"
#import "DSAutosuggestedItemDelegate.h"

@implementation DSAutoSuggestDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (self.datasourceObjects? self.datasourceObjects.count: 0);
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    
    // Clear previous data, incase the cell is being re-used
    cell.imageView.image = nil;
    
    cell.textLabel.font = self.font;
    cell.detailTextLabel.font = [UIFont fontWithName:self.font.fontName size:12.0f];
    
    id<DSAutosuggestedItemDelegate> object;
    
    if (self.datasourceObjects.count > indexPath.row) {
        object = self.datasourceObjects[indexPath.row];
    }
    
    if ([object respondsToSelector:@selector(getTitle)]) {
        // Very hacky way
        if ([((id<DSAutosuggestedItemDelegate>)object).getTitle isEqualToString:@"Current Location"]) {
            
            cell.textLabel.textColor = [UIColor colorWithRed:0 green:122.0f/255.0f blue:1.0f alpha:1.0f];
            [((id<DSAutosuggestedItemDelegate>)object) getImageInBackground:^(UIImage *image, NSError *err) {
                if (!err) {
                    cell.imageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
                    cell.separatorInset = UIEdgeInsetsZero;
                    cell.imageView.frame = CGRectMake(0, 0, 50, 50);
                    cell.imageView.image = image;
                }
            }];
            
        } else {
            cell.textLabel.textColor = [UIColor blackColor];
        }
        
        cell.textLabel.text = ((id<DSAutosuggestedItemDelegate>)object).getTitle;
    }
    
    if ([object respondsToSelector:@selector(getDescriptionTitle)]) {
        cell.detailTextLabel.text = ((id<DSAutosuggestedItemDelegate>)object).getDescriptionTitle;
    }
    
    return cell;
}

//- (void) setDatasourceObjects:(NSArray *)dso {
//    _datasourceObjects = [[NSArray alloc] initWithArray:dso];
//}

@end
