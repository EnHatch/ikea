//
//  EHPickListViewController.m
//  Ikea
//
//  Created by David Kay on 5/20/12.
//  Copyright (c) 2012 Gargoyle Software. All rights reserved.
//

#import "MBProgressHUD.h"

#import "EHPickListViewController.h"

#import "Constants.h"
#import "FurnitureAssemblyViewController.h"

@interface EHPickListViewController ()

@end

@implementation EHPickListViewController

@synthesize shoppingCart = _shoppingCart;
@synthesize pickList = _pickList;
@synthesize tableView = _tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSDictionary *pickPlist = [NSDictionary dictionaryWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"Picklist"ofType:@"plist"]];
        self.pickList = [pickPlist objectForKey: @"Items"];
        self.shoppingCart = [NSMutableSet set];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = @"Pick List";


  UIBarButtonItem *skipButton = [[UIBarButtonItem alloc] initWithTitle:@"Instructions" style:UIBarButtonItemStyleBordered target:self action:@selector(skipWasPressed:)];
    self.navigationItem.rightBarButtonItem = skipButton;
  [skipButton release];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Cart Management

- (BOOL)isItemInCart:(NSDictionary *)furniture {
    return [self.shoppingCart containsObject: furniture];
}

- (void)addItemToCart:(NSDictionary *)furniture {
    NSLog(@"addItemToCart: %@", furniture);

    [self.shoppingCart addObject: furniture];
    NSIndexSet *sections = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(
            0,
            1
    )];
    [self.tableView reloadSections:sections
                  withRowAnimation:UITableViewRowAnimationFade];

    [self checkForFullCart];
}

- (void)checkForFullCart {
    if (self.shoppingCart.count == self.pickList.count) {
	[self cartWasFilled];
    }
}

- (void)cartWasFilled {
    // Show spinner
#if 0
    if (!self.progressHUD) {
        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView: self.view];
        [self.view addSubview:HUD];
        HUD.dimBackground = YES;
        HUD.labelText = @"Inviting...";

        self.progressHUD = HUD;
        [HUD release];
    }
    [self.progressHUD show: YES];
#else
    // No need to retain (just a local variable)
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"Downloading";

    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
      // Do a taks in the background
      sleep(2);
      // Hide the HUD in the main tread
      dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
	// Load 3d
	[self pushAssemblyController];
      });
    });

#endif
}

#pragma mark - Navigation

- (void)pushAssemblyController {
    // Load 3d
    FurnitureAssemblyViewController *fvc = [[FurnitureAssemblyViewController alloc] init];
    [self.navigationController pushViewController: fvc
                                      animated: YES];
    [fvc release];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.pickList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PickListTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    UIImageView *checkImageView = nil;
    UILabel *productLabel = nil;
    UILabel *detailLabel = nil;

    if (cell == nil) {
      //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"PickListTableCell" owner:self options:nil];
	cell = (UITableViewCell *) [objects objectAtIndex: 0];
    }
    
    if (!productLabel) { productLabel = (UILabel*)[cell viewWithTag:1]; }
    if (!detailLabel) { detailLabel = (UILabel*)[cell viewWithTag:2]; }
    if (!checkImageView) {checkImageView = (UIImageView*)[cell viewWithTag:3]; }

    NSDictionary *item = [self.pickList objectAtIndex:indexPath.row];

    NSLog(@"cell for item: %@", item);

    productLabel.text = [item objectForKey: KEY_NAME];
    detailLabel.text  = [item objectForKey: KEY_BARCODE];

    if ([self isItemInCart: item]) {
	NSLog(@"ITEM IN CART! %@", item);
	checkImageView.image = [UIImage imageNamed: @"checked"];
    } else {
	checkImageView.image = [UIImage imageNamed: @"unchecked"];
    }

    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

#pragma mark - Alerts

- (void)showInvalidBarcodeAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Unknown Barcode"
                                                  message: @"We don't know this barcode!"
                                                 delegate: nil
                                        cancelButtonTitle: @"OK"
                                        otherButtonTitles: nil];
    [alert show];
    [alert release];
}

#pragma mark - UI Callbacks

- (IBAction)skipWasPressed:(id)sender
{

    [self cartWasFilled];
}

- (IBAction)loadModalBarCodeScanner:(id)sender
{
    ZBarReaderViewController *vc = [ZBarReaderViewController new];
    vc.readerDelegate = self;

    [vc.scanner setSymbology:ZBAR_QRCODE config:ZBAR_CFG_ENABLE to:0];
    vc.readerView.zoom = 1.0;

    [self presentModalViewController:vc animated:YES];
}


#pragma mark - Barcode Reading

- (void)barcodeWasScanned:(NSString *)barcode
                 withType:(NSString *)barcodeType
{
    NSString *concatenatedBarcode = [NSString stringWithFormat: @"%@:%@",
             barcodeType,
             barcode
             ];
    NSLog(@"barcodeWasScanned:: %@", concatenatedBarcode);

    for (NSDictionary *furniture in self.pickList) {
        if ([[furniture objectForKey: KEY_BARCODE] isEqualToString: concatenatedBarcode]) {
            [self addItemToCart: furniture];
            return;
        }
    }
    [self showInvalidBarcodeAlert];
    NSLog(@"Error. barcode not captured.");
}

#pragma mark - ZBarReaderDelegate

- (void) imagePickerController: (UIImagePickerController*)reader didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    id<NSFastEnumeration> results = [info objectForKey:ZBarReaderControllerResults];
    //UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];

    NSLog(@"Results: %@", results);

    NSString *barcode = nil;
    NSString *barcodeType = nil;

    for(ZBarSymbol *symbol in results) {
        // process result
        NSLog(@"symbol type: %@", symbol.typeName);
        NSLog(@"symbol data: %@", symbol.data);

        barcode = symbol.data;
        barcodeType = symbol.typeName;
    }

    [reader dismissModalViewControllerAnimated:YES];

    if (barcode && barcodeType) {
        [self barcodeWasScanned: barcode
                       withType: barcodeType];
    } else {
        NSLog(@"Error. barcode not captured.");
    }
}

@end
