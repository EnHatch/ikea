//
//  EHDetailViewController.m
//  Ikea
//
//  Created by David Kay on 5/19/12.
//  Copyright (c) 2012 Gargoyle Software. All rights reserved.
//

#import "EHDetailViewController.h"

#import "FurnitureAssemblyViewController.h"

@interface EHDetailViewController ()
- (void)configureView;
@end

@implementation EHDetailViewController

@synthesize detailItem = _detailItem;
@synthesize detailDescriptionLabel = _detailDescriptionLabel;
@synthesize assemblyButton = _assemblyButton;

#pragma mark - Cleanup

- (void)dealloc
{
  [_detailItem release];
  [_detailDescriptionLabel release];
  [super dealloc];
}

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
  if (_detailItem != newDetailItem) {
    [_detailItem release];
    _detailItem = [newDetailItem retain];

    // Update the view.
    [self configureView];
  }
}

- (void)configureView
{
  // Update the user interface for the detail item.

  if (self.detailItem) {
    self.detailDescriptionLabel.text = [[self.detailItem valueForKey:@"timeStamp"] description];
  }
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  [self configureView];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  self.detailDescriptionLabel = nil;
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

#pragma mark - Initialization

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    self.title = NSLocalizedString(@"Detail", @"Detail");
  }
  return self;
}

@end
