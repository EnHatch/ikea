//
//  EHMasterViewController.m
//  Ikea
//
//  Created by David Kay on 5/19/12.
//  Copyright (c) 2012 Gargoyle Software. All rights reserved.
//

#import "UIImageView+AFNetworking.h"

#import "EHMasterViewController.h"

#import "Constants.h"
#import "EHDetailViewController.h"
#import "EHBarCodeViewController.h"

@interface EHMasterViewController ()

@end

@implementation EHMasterViewController

@synthesize detailViewController = _detailViewController;
@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize furnitureList = _furnitureList;
@synthesize tableView = _tableView;

#pragma mark - Initialization

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSDictionary *furniturePlist = [NSDictionary dictionaryWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"Furniture"ofType:@"plist"]];        
        self.furnitureList = [furniturePlist objectForKey: @"items"];
    }
    return self;
}

#pragma mark - Cleanup
							
- (void)dealloc
{
    [_detailViewController release];
    [__fetchedResultsController release];
    [__managedObjectContext release];
    [super dealloc];
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Products";
    

    //self.tableView.separatorColor = [UIColor yellowColor];
    self.tableView.rowHeight = 110;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"ikeanavbar.png"] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.furnitureList count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EHCustomTableCell";
    
    UIImageView *productIV = nil;
    UILabel *productLabel = nil;
    UILabel *priceLabel = nil;
    UILabel *timeLabel = nil;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"EHCustomTableCell" owner:self options:nil];
        cell = (UITableViewCell *) [objects objectAtIndex: 0];
    }
    
    if (!productIV) {productIV = (UIImageView*)[cell viewWithTag:1]; }
    if (!productLabel) { productLabel = (UILabel*)[cell viewWithTag:2]; }
    if (!priceLabel) { priceLabel = (UILabel*)[cell viewWithTag:3]; }
    if (!timeLabel) { timeLabel = (UILabel*)[cell viewWithTag:4]; }
    
   // productLabel.font = [UIFont fontWithName:@"Gravur-Condensed" size:24];
    
    NSDictionary *item = [self.furnitureList objectAtIndex:indexPath.row];

    [productIV setImageWithURL:[NSURL URLWithString:[item objectForKey:@"Image"]] placeholderImage:[UIImage imageNamed:@"44-26.jpg"]];
    productLabel.text = [item objectForKey:@"Name"];
    priceLabel.text = [NSString stringWithFormat:@"$%@", [item objectForKey:@"Price"]];
    timeLabel.text = [item objectForKey:@"Time"];
    
    return cell;
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //if (!self.detailViewController) {
    //    self.detailViewController = [[[EHDetailViewController alloc] initWithNibName:@"EHDetailViewController" bundle:nil] autorelease];
    //}
    
    [self navToProductDetail: [self.furnitureList objectAtIndex:indexPath.row]];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Navigation

- (void)navToProductDetail:(NSDictionary *)product {
    self.detailViewController = [[[EHDetailViewController alloc] initWithNibName:@"EHDetailViewController" bundle:nil] autorelease];

    self.detailViewController.product = product;

    [self.navigationController pushViewController:self.detailViewController animated:YES];
}

@end
