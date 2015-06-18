//
//  DetailViewController.h
//  DSSearchUI-Example
//
//  Created by Deborshi Saha on 6/18/15.
//  Copyright (c) 2015 Deborshi Saha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

