//
//  DSSearchBox.m
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

#import "DSSearchBox.h"

@interface DSSearchBox ()
@property (nonatomic, strong) UIImageView *searchIconImageView;
@property (nonatomic, strong) UIImageView *locationIconImageView;
@end

@implementation DSSearchBox

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self configureLocationTextField];
        
        [self configureSearchTextField];
    }
    
    return self;
}

- (void) setSearchIconImage:(UIImage *)searchIconImage {
    if (searchIconImage) {
        self.searchIconImageView.image = searchIconImage;
    }
}

- (void) setLocationTextFieldText:(NSString *)locationTextFieldText {
    
    if([locationTextFieldText isEqualToString:@"Current Location"]) {
        self.locationTextField.textColor = [UIColor colorWithRed:0.0f/255.0f green:122.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
    } else {
        self.locationTextField.textColor = [UIColor blackColor];
    }
    
    self.locationTextField.text = locationTextFieldText;
}

/***************************************************************
 *  Private
 ***************************************************************/
- (void) updateConstraints {
    [super updateConstraints];
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (CGFloat) locationTextFieldOriginY {
    return CGRectGetHeight(self.frame) - TEXTFIELD_HEIGHT - VERTICAL_PADDING;
}

- (CGFloat) searchTextFieldOriginY {
    return CGRectGetHeight(self.frame) - 2*TEXTFIELD_HEIGHT - 2*VERTICAL_PADDING;
}

- (void) configureSearchTextField {
    
    if (!self.searchTextField) {
        CGRect searchTextFieldFrame = CGRectMake(HORIZONTAL_PADDING, [self searchTextFieldOriginY] , CGRectGetWidth(self.bounds) - 2*HORIZONTAL_PADDING, TEXTFIELD_HEIGHT);
        self.searchTextField = [[UITextField alloc] initWithFrame:searchTextFieldFrame];
    }
 
    
    self.searchTextField.backgroundColor = [UIColor whiteColor];
    self.searchTextField.layer.cornerRadius = 2.0f;
    self.searchTextField.leftViewMode = UITextFieldViewModeAlways;

    _searchIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(HORIZONTAL_PADDING, 0, TEXTFIELD_HEIGHT*1.4*0.9, TEXTFIELD_HEIGHT*0.9)];
    self.searchIconImageView.bounds = CGRectInset(_searchIconImageView.frame, 7.0f, 5.0f);
    self.searchIconImageView.image = [UIImage imageNamed:@"search-100.png"];
    
    // Attaching Search Icon
    self.searchTextField.leftView = self.searchIconImageView;
    
    [self addSubview:self.searchTextField];
        
}


- (void) configureLocationTextField {
    if (!self.locationTextField) {
        CGRect locationTextFieldFrame = CGRectMake(HORIZONTAL_PADDING, [self locationTextFieldOriginY] , CGRectGetWidth(self.bounds) - 2*HORIZONTAL_PADDING, TEXTFIELD_HEIGHT);
        self.locationTextField = [[UITextField alloc] initWithFrame:locationTextFieldFrame];
    }
    
    
    self.locationTextField.backgroundColor = [UIColor whiteColor];
    self.locationTextField.layer.cornerRadius = 2.0f;
    self.locationTextField.leftViewMode = UITextFieldViewModeAlways;
    
    _locationIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(HORIZONTAL_PADDING * 2, 0, TEXTFIELD_HEIGHT*1.4*0.9, TEXTFIELD_HEIGHT*0.9)];
    self.locationIconImageView.bounds = CGRectInset(self.locationIconImageView.frame, 7.0f, 5.0f);
    self.locationIconImageView.image = [UIImage imageNamed:@"location_filled-100.png"];
    
    // Attaching Location Icon
    self.locationTextField.leftView = self.locationIconImageView;
    
    [self addSubview:self.locationTextField];
}

@end
