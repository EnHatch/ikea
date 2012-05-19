//
//  EHMasterViewController.h
//  Ikea
//
//  Created by David Kay on 5/19/12.
//  Copyright (c) 2012 Gargoyle Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EHDetailViewController;

#import <CoreData/CoreData.h>

@interface EHMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) EHDetailViewController *detailViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
