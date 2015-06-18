//
//  MasterViewController.m
//  DSSearchUI-Example
//
//  Created by Deborshi Saha on 6/18/15.
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

#import "MasterViewController.h"
#import "DSLocationBasedSearchUI.h"
#import "DSLocationSuggestor.h"
#import "DSAutoSuggestedLocation.h"

@interface MasterViewController () <DSLocationBasedSearchUIDelegate>
@property (nonatomic, strong)DSLocationBasedSearchUI *searchUI;
@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    if (!_searchUI) {
        _searchUI = [[DSLocationBasedSearchUI alloc] initWithViewController:self];
    }
    
    self.searchUI.tintColor = [UIColor colorWithRed:196.0f/255.0f green:2.0f/255.0f blue:2.0f/255.0f alpha:1.0f];
    self.searchUI.delegate = self;
    self.searchUI.searchUIFont = [UIFont fontWithName:@"AvenirNext-Medium" size:16.0f];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
