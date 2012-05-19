//
//  EHDetailViewController.h
//  Ikea
//
//  Created by David Kay on 5/19/12.
//  Copyright (c) 2012 Gargoyle Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EHDetailViewController : UIViewController <UITableViewDataSource, UITableViewDataSource>

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UITextView *detailsTV;
@property (strong, nonatomic) IBOutlet UIImageView *productIV;

@property (strong, nonatomic) IBOutlet UIButton *assemblyButton;

- (IBAction)assemblyButtonWasPressed:(id)sender;

@end
