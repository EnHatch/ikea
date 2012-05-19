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

@interface EHMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate, ZBarReaderDelegate>

@property (strong, nonatomic) EHDetailViewController *detailViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

-(IBAction)pushBarCodeScanner:(id)sender;
-(void) pushDetailView;

@end
