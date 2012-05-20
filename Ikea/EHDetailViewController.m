//
//  EHDetailViewController.m
//  Ikea
//
//  Created by David Kay on 5/19/12.
//  Copyright (c) 2012 Gargoyle Software. All rights reserved.
//

#import "EHDetailViewController.h"

#import "FurnitureAssemblyViewController.h"

#import "UIImageView+AFNetworking.h"

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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];

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

#pragma Mark - TableView methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
       // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

@end
