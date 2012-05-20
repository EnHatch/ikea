//
//  EHDetailViewController.m
//  Ikea
//
//  Created by David Kay on 5/19/12.
//  Copyright (c) 2012 Gargoyle Software. All rights reserved.
//

#import "EHDetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "DLStarRatingControl.h"

#import "FurnitureAssemblyViewController.h"

#import "Constants.h"

@interface EHDetailViewController ()
@end

@implementation EHDetailViewController

@synthesize detailsTV = _detailsTV;
@synthesize productIV = _productIV;
@synthesize assemblyButton = _assemblyButton;
@synthesize product = _product;

#pragma mark - Initialization

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    self.title = NSLocalizedString(@"Detail", @"Detail");
  }
  return self;
}

#pragma mark - Cleanup

- (void)dealloc
{
    [super dealloc];
}

#pragma mark - Managing the detail item


#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.navigationItem.title = @"Product Name";

    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"44x26.jpg"] style:UIBarButtonItemStylePlain target:self action:@selector(assemblyButtonWasPressed:)];
    self.navigationItem.rightBarButtonItem = rightButton;
    [rightButton release];

    self.navigationItem.title = [self.product objectForKey:@"Name"];

    NSLog(@"loaded detail with product: %@", self.product);
    NSString *detail = [self.product objectForKey:@"Detail"];

    NSArray *details = [detail componentsSeparatedByString:@"~"];

    NSString *description = @"";
    for (NSString *string in details)
    {
        string = [string stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        description = [NSString stringWithFormat:@"%@%@\n", description, string];
    }

    self.detailsTV.text = description;

    [self.productIV setImageWithURL:[NSURL URLWithString:[self.product objectForKey:@"Image"]] placeholderImage:[UIImage imageNamed:@"44-26.jpg"]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
}


- (void)viewDidUnload
{
  [super viewDidUnload];
  // Release any retained subviews of the main view.
}

#pragma mark - UI Callbacks

- (IBAction)assemblyButtonWasPressed:(id)sender {
  FurnitureAssemblyViewController *fvc = [[FurnitureAssemblyViewController alloc] init];
  [self.navigationController pushViewController: fvc
                                      animated: YES];
  [fvc release];
}

#pragma mark - Rotate

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma Mark - Data Helpers

- (NSArray *)reviews
{
    NSArray *reviews = [self.product objectForKey: KEY_REVIEWS];
    return reviews;
}

#pragma Mark - UITableViewDataSource Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *reviews = [self reviews];
    return reviews.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSDictionary *review = [self.reviews objectAtIndex:indexPath.row];

    //NSString *text = [review objectForKey: KEY_REVIEW];
    //CGFloat height = [text sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(240,300) lineBreakMode:UILineBreakModeWordWrap].height;

    //return height + 40; 
    return 200; 
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RatingTableCell";

    DLStarRatingControl *ratingBar = nil;
    UILabel *ratingLabel = nil;
    UILabel *reviewerLabel = nil;

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"RatingTableCell" owner:self options:nil];
        cell = (UITableViewCell *) [objects objectAtIndex: 0];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (!ratingBar) {ratingBar = (DLStarRatingControl*)[cell viewWithTag:1]; }
    if (!ratingLabel) { ratingLabel = (UILabel*)[cell viewWithTag:2]; }
    if (!reviewerLabel) { reviewerLabel = (UILabel*)[cell viewWithTag:1337]; }

    NSDictionary *review = [[self reviews] objectAtIndex: indexPath.row];

    ratingBar.rating = [[review objectForKey: KEY_STARS] floatValue];
    ratingLabel.text = [review objectForKey: KEY_REVIEW];

    NSString *reviewerName = [review objectForKey: KEY_NAME];
    reviewerLabel.text = [NSString stringWithFormat: @"%@:", 
        reviewerName
            ];
    //NSLog(@"reviewerLabel: %@", reviewerLabel.text);
    //reviewerLabel.text = [review objectForKey: KEY_NAME];

    return cell;
}

#pragma Mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

@end
