//
//  DSLocationBasedSearchUI.h
//  DSSearchUI
//
//  Created by Deborshi Saha on 5/20/15.
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

#import <UIKit/UIKit.h>
#import "DSSearchBox.h"
#import "DSAutosuggestedItemDelegate.h"
#import "DSAutoSuggestedLocation.h"

@protocol DSLocationBasedSearchUIDelegate <NSObject>

- (void) searchTextDidChange:(NSString *) text;

// When the user tapped on a text field to begin typing
- (void) didStartEditingSearchText;

// When the selection happens through the table view
- (void) didSelectSearchedItemAtIndex: (NSInteger) index;

// When the user selects a suggested location
- (void) autoSuggestedLocationSelected:(DSAutoSuggestedLocation *) autoSuggestedLocationItem;

@end

@interface DSLocationBasedSearchUI : NSObject

@property (nonatomic, strong) UIFont *searchUIFont;
@property (nonatomic, assign) id<DSLocationBasedSearchUIDelegate> delegate;

// UI
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *tintColor;

// UI Elements
@property (nonatomic, strong) DSSearchBox *searchBox;
@property (nonatomic, readonly, getter=isSearchUIShown) BOOL isActive;

- (instancetype) initWithViewController: (UIViewController *) viewcontroller;
- (void) setSuggestedItems:(NSArray *)suggestedItems;

@end
