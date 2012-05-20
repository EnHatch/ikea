//
//  EHPickListViewController.h
//  Ikea
//
//  Created by David Kay on 5/20/12.
//  Copyright (c) 2012 Gargoyle Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"

@interface EHPickListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ZBarReaderDelegate>

@property (strong, nonatomic) NSArray *pickList;
@property (strong, nonatomic) NSMutableSet *shoppingCart;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)loadModalBarCodeScanner:(id)sender;

@end
