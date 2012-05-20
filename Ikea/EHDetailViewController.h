//
//  EHDetailViewController.h
//  Ikea
//
//  Created by David Kay on 5/19/12.
//  Copyright (c) 2012 Gargoyle Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EHDetailViewController : UIViewController <UITableViewDataSource, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITextView *detailsTV;
@property (strong, nonatomic) IBOutlet UIImageView *productIV;

@property (strong, nonatomic) IBOutlet UIButton *assemblyButton;

@property (strong, nonatomic) NSDictionary *product;
@property (nonatomic, readonly) NSArray *reviews;

- (IBAction)assemblyButtonWasPressed:(id)sender;

@end
