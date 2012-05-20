//
//  EHMasterViewController.h
//  Ikea
//
//  Created by David Kay on 5/19/12.
//  Copyright (c) 2012 Gargoyle Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ZBarSDK.h"

@class EHDetailViewController;

@interface EHMasterViewController : UIViewController <NSFetchedResultsControllerDelegate, ZBarReaderDelegate, UITableViewDataSource, UITableViewDataSource>

@property (strong, nonatomic) EHDetailViewController *detailViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *furnitureList;

- (IBAction)loadModalBarCodeScanner;

@end
