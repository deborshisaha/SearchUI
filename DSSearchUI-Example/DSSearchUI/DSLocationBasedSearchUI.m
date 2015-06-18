//
//  DSLocationBasedSearchUI.m
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

#import "DSLocationBasedSearchUI.h"
#import "DSAutoSuggestDataSource.h"
#import "DSLocationSuggestor.h"
#import "DSAutoSuggestedLocation.h"

#define VERTICAL_PADDING 4.0f
#define HORIZONTAL_PADDING 5.0f
#define TEXTFIELD_HEIGHT 30.0f
#define STATUSBAR_HEIGHT 20.0f
#define NAVBAR_HEIGHT (CGRectGetHeight(self.targetNavigationController.navigationBar.frame))
#define TOP_PADDING (CGRectGetHeight(self.targetNavigationController.navigationBar.frame) + STATUSBAR_HEIGHT)
#define HEIGHT_SEARCHUI (STATUSBAR_HEIGHT+CGRectGetHeight(self.targetNavigationController.navigationBar.frame) + 2.0f *TEXTFIELD_HEIGHT + 3.0f * VERTICAL_PADDING)

typedef enum {
    EActiveFieldSearch = 1<<0,
    EActiveFieldLocationSuggestion = 1<<1
}EActiveField;


@interface DSLocationBasedSearchUI () <UITableViewDelegate, UITextFieldDelegate> {
    DSAutoSuggestedLocation *cachedSelectedLocationObject;
    DSAutoSuggestedLocation *currentLocationObject;
    BOOL showingSearchUI;
}

@property (nonatomic, strong) UINavigationController *targetNavigationController;
@property (nonatomic, strong) UIViewController *targetViewController;
@property (nonatomic, strong) DSAutoSuggestDataSource *autoSuggestDataSource;

@property (nonatomic, strong) UIBarButtonItem *showSearchUIButton;
@property (nonatomic, strong) UIBarButtonItem *hideSearchUIButton;

@property (nonatomic, assign) EActiveField activeField;

@property (nonatomic, strong) UITableView *suggestionTableView;
//@property (nonatomic, assign) BOOL showingSearchUI;

@end

@implementation DSLocationBasedSearchUI

- (instancetype) initWithViewController:(UIViewController *)viewcontroller {
    
    self = [super init];
    
    if (self) {
        
        if (!viewcontroller) {
            [NSException raise:@"NSViewControllerNullException" format:@"View controller cannot be nil"];
        }
        
        _targetViewController = viewcontroller;
        
        if ([viewcontroller.parentViewController isKindOfClass:[UINavigationController class]]) {
            _targetNavigationController = (UINavigationController *)viewcontroller.parentViewController;
        }
        
        if (!self.searchBox) {
            self.searchBox = [[DSSearchBox alloc] initWithFrame:CGRectMake(0.0f, -(HEIGHT_SEARCHUI+STATUSBAR_HEIGHT+NAVBAR_HEIGHT), CGRectGetWidth(self.targetNavigationController.navigationBar.frame), HEIGHT_SEARCHUI)];
            
            self.searchBox.locationTextField.delegate = self;
            self.searchBox.searchTextField.delegate = self;
            
            self.searchBox.locationTextField.font = self.searchUIFont;
            self.searchBox.searchTextField.font = self.searchUIFont;
            
            [self.searchBox.locationTextField addTarget:self
                          action:@selector(textFieldDidChange:)
                forControlEvents:UIControlEventEditingChanged];
            
            [self.searchBox.searchTextField addTarget:self
                                                 action:@selector(textFieldDidChange:)
                                       forControlEvents:UIControlEventEditingChanged];
        }
        
        if (!self.autoSuggestDataSource) {
            self.autoSuggestDataSource = [[DSAutoSuggestDataSource alloc] init];
        }
        
        // Add search box and adjust constraints
        [self.targetViewController.view addSubview:self.searchBox];
        
        // Configure Bar button items
        [self configureBarButtonItems];
        
        // Show bar button item
        if (!self.isActive) {
            self.targetNavigationController.visibleViewController.navigationItem.rightBarButtonItem = self.showSearchUIButton;
        } else {
            self.targetNavigationController.visibleViewController.navigationItem.rightBarButtonItem = self.hideSearchUIButton;
        }
        
        if (!currentLocationObject) {
            currentLocationObject = [[DSAutoSuggestedLocation alloc] initAsCurrentLocation];
        }

        // Initial value of current location
        if (!cachedSelectedLocationObject) {
            cachedSelectedLocationObject = currentLocationObject;
        }
        
        // Adding notifications
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardDidShow:)
                                                     name:UIKeyboardDidShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardDidHide:)
                                                     name:UIKeyboardDidHideNotification
                                                   object:nil];
    }
    
    return self;
}

- (void) showSearchUI {
    
    [self.targetNavigationController.view insertSubview:self.searchBox belowSubview:self.targetNavigationController.navigationBar];
    
    // Get the title of previously selected location
    self.searchBox.locationTextFieldText = [((id<DSAutosuggestedItemDelegate>) cachedSelectedLocationObject) getTitle];
    
    [UIView animateWithDuration:0.4f delay:0.0f usingSpringWithDamping:0.5f initialSpringVelocity:7.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.searchBox.frame = CGRectOffset(self.searchBox.frame, 0.0f, (HEIGHT_SEARCHUI+STATUSBAR_HEIGHT+NAVBAR_HEIGHT));
    } completion:^(BOOL finished) {
        if (finished) {

            showingSearchUI = YES;
            
            // Right where Search Box Y max is
            CGFloat originOfSuggestionTableViewY = CGRectGetMaxY(self.searchBox.frame) - NAVBAR_HEIGHT - STATUSBAR_HEIGHT ;
            
            CGFloat heightSuggestionTableView = CGRectGetMaxY(self.searchBox.frame) - (CGRectGetHeight(self.targetViewController.view.bounds));
            
            // What the frame should be
            CGRect suggestionTableViewFrame = CGRectMake(0.0f, originOfSuggestionTableViewY, CGRectGetWidth(self.targetViewController.view.bounds), fabs(heightSuggestionTableView));
            
            // Setup suggestion table view
            [self configureSuggestionTableViewWithFrame: suggestionTableViewFrame];
            
            // First we want to get the location
            [self.searchBox.searchTextField becomeFirstResponder];
        }
    }];
}

- (void) hideSearchUI {
    
    [UIView animateWithDuration:0.05f delay:0.0f usingSpringWithDamping:0.9f initialSpringVelocity:1.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.searchBox.frame = CGRectOffset(self.searchBox.frame, 0.0f, -(HEIGHT_SEARCHUI+STATUSBAR_HEIGHT+NAVBAR_HEIGHT));
    } completion:^(BOOL finished) {
        if (finished) {
            
            showingSearchUI = NO;
            
            [UIView animateWithDuration:0.4f animations:^{
                self.suggestionTableView.alpha = 0.0f;
            } completion:^(BOOL finished) {
                [self.suggestionTableView removeFromSuperview];
                self.suggestionTableView = nil;
            }];
            
            [self.searchBox endEditing:YES];
            
            [self.searchBox removeFromSuperview];
        }
    }];
}

- (BOOL) isSearchUIShown {
    return showingSearchUI;
}

- (void) setTintColor:(UIColor *)tintColor {
    self.searchBox.backgroundColor = tintColor;
}


- (void) setSuggestedItems:(NSArray *) array {
    
    if (self.activeField == EActiveFieldLocationSuggestion) {
        NSMutableArray *mArr = [[NSMutableArray alloc] init];
        [mArr addObject:currentLocationObject];
        
        if (array) {
            [mArr addObjectsFromArray:array];
        }
        self.autoSuggestDataSource.datasourceObjects = mArr;
    } else {
        self.autoSuggestDataSource.datasourceObjects = array;
    }
    
    if (self.suggestionTableView) {
        [self.suggestionTableView reloadData];
    }
}

- (void) setSearchUIFont:(UIFont *)searchUIFont {
    
    _searchUIFont = searchUIFont;
    
    self.searchBox.locationTextField.font = self.searchUIFont;
    self.searchBox.searchTextField.font = self.searchUIFont;
    
    self.autoSuggestDataSource.font = self.searchUIFont;
}

/***************************************************************
 * UITextFieldDelegate
 ***************************************************************/
- (void) textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.searchBox.locationTextField) {
        
        self.activeField = EActiveFieldLocationSuggestion;
        
        [self setSuggestedItems:nil];
        
    } else if (textField == self.searchBox.searchTextField) {
        
        self.activeField = EActiveFieldSearch;
        
        if (self.isActive && [self.delegate respondsToSelector:@selector(didStartEditingSearchText)]) {
            [self.delegate didStartEditingSearchText];
        }
        
        [self setSuggestedItems:nil];
    }
}

- (void) textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.searchBox.locationTextField) {
        if (self.searchBox.locationTextField.text.length == 0) {
            
            cachedSelectedLocationObject = currentLocationObject;
            
            [self doUIUpdatesAndNotificationsWithObject:cachedSelectedLocationObject];
        }
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.searchBox.locationTextField &&
        self.activeField == EActiveFieldLocationSuggestion &&
        (range.length==1 && string.length==0)) {
        
        if ([textField.text isEqualToString:@"Current Location"]) {
            textField.text = @"";
            textField.textColor = [UIColor blackColor];
        }
    }
    
    return YES;
}

- (void) textFieldDidChange:(UITextField *)textField {
    
    if (textField == self.searchBox.locationTextField) {
        [self locationTextDidChange:textField.text];
    } else if (textField == self.searchBox.searchTextField) {
        if ([self.delegate respondsToSelector:@selector(searchTextDidChange:)]) {
            [self.delegate searchTextDidChange:textField.text];
        }
    }
    
}

/***************************************************************
 * UITableViewDelegate
 ***************************************************************/
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    id obj = [self.autoSuggestDataSource.datasourceObjects objectAtIndex:indexPath.row];
    
    if( (self.activeField == EActiveFieldLocationSuggestion) && [obj respondsToSelector:@selector(getTitle)]) {
        
        // Save this for next time
        cachedSelectedLocationObject = obj;
        
        [self doUIUpdatesAndNotificationsWithObject:cachedSelectedLocationObject];
        
        if ([self.searchBox.locationTextField isFirstResponder]) {
            [self.searchBox.searchTextField becomeFirstResponder];
        }
        
    } else if (self.activeField == EActiveFieldSearch) {
        if ([self.delegate respondsToSelector:@selector(didSelectSearchedItemAtIndex:)]) {
            [self.delegate didSelectSearchedItemAtIndex:indexPath.row];
        }
    }
}

/***************************************************************
 *  Private
 ***************************************************************/
- (void) locationTextDidChange:(NSString *) text {
    
    [DSLocationSuggestor fetchAutoCompletedResultsForText:text inBackground:^(id suggestedLocations, NSError *err) {
        if (!err) {
            [self setSuggestedItems: suggestedLocations];
        }
    }];
}

- (void) doUIUpdatesAndNotificationsWithObject: (id<DSAutosuggestedItemDelegate>) object {
    
    if ([object respondsToSelector:@selector(getTitle)]) {
        self.searchBox.locationTextFieldText = [NSString stringWithFormat:@"%@", [((id<DSAutosuggestedItemDelegate>)object) getTitle]];
    }
    
    if ([self.delegate respondsToSelector:@selector(autoSuggestedLocationSelected:)]) {
        [self.delegate autoSuggestedLocationSelected:cachedSelectedLocationObject];
    }
}

- (void) configureSuggestionTableViewWithFrame: (CGRect) frame {
    
    if (!self.suggestionTableView) {
        self.suggestionTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        self.suggestionTableView.alpha = 0.0f;
        
        self.suggestionTableView.dataSource = self.autoSuggestDataSource;
        self.suggestionTableView.delegate = self;
        
        [self.targetViewController.view addSubview:self.suggestionTableView];
        
        // Animate fade in of suggestion table view
        [UIView animateWithDuration:0.4f animations:^{
            self.suggestionTableView.alpha = 1.0f;
        }];
        
    } else {
        self.suggestionTableView.frame = frame;
    }
}

- (void) configureBarButtonItems {
    
    self.showSearchUIButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(hideAndShowSearchUI:)];
    
    self.hideSearchUIButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(hideAndShowSearchUI:)];
    
}

- (void) hideAndShowSearchUI:(id)sender {
    
    if (self.isActive) {
        
        [self hideSearchUI];
        
        self.targetNavigationController.visibleViewController.navigationItem.rightBarButtonItem = self.showSearchUIButton;
    
    } else {
        [self showSearchUI];
       
        self.targetNavigationController.visibleViewController.navigationItem.rightBarButtonItem = self.hideSearchUIButton;
    }
}

- (void)keyboardDidShow: (NSNotification *) notification{
    
    NSValue* keyboardFrameEnd = [[notification userInfo] valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrameEndRect = [keyboardFrameEnd CGRectValue];
    
    [self configureSuggestionTableViewWithFrame: [self constructSuggestionTableFrame:keyboardFrameEndRect]];
}

- (void)keyboardDidHide: (NSNotification *) notification{
    
    NSValue* keyboardFrameEnd = [[notification userInfo] valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrameEndRect = [keyboardFrameEnd CGRectValue];
    
    [self configureSuggestionTableViewWithFrame: [self constructSuggestionTableFrame:keyboardFrameEndRect]];

}

- (CGRect) constructSuggestionTableFrame: (CGRect) frame {
    
    // Right where Search Box Y max is
    CGFloat originOfSuggestionTableViewY = CGRectGetMaxY(self.searchBox.frame) - NAVBAR_HEIGHT - STATUSBAR_HEIGHT ;
    CGFloat heightSuggestionTableView = CGRectGetMaxY(self.searchBox.frame) - (CGRectGetHeight(self.targetViewController.view.bounds)-CGRectGetHeight(frame));
    
    // What the frame should be
    CGRect suggestionTableViewFrame = CGRectMake(0.0f, originOfSuggestionTableViewY, CGRectGetWidth(self.targetViewController.view.bounds), fabs(heightSuggestionTableView));
    
    return suggestionTableViewFrame;
}

@end
