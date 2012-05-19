//
//  FurnitureAssemblyViewControllerViewController.m
//  Ikea
//
//  Created by David Kay on 5/19/12.
//  Copyright (c) 2012 Gargoyle Software. All rights reserved.
//

#import "isgl3d.h"

#import "FurnitureAssemblyViewController.h"

@interface FurnitureAssemblyViewController ()

@end

@implementation FurnitureAssemblyViewController

#pragma mark - Initialization

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View Lifecycle

- (void)loadView
{

}

//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    // Do any additional setup after loading the view from its nib.
//}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - 3D

- (void)init3d {
  // Instantiate the Isgl3dDirector and set background color
  [Isgl3dDirector sharedInstance].backgroundColorString = @"333333ff"; 

  // Set the director to display the FPS
  //[Isgl3dDirector sharedInstance].displayFPS = YES; 

  // Create the UIViewController
  //_viewController = [[Isgl3dViewController alloc] initWithNibName:nil bundle:nil];
  //_viewController.wantsFullScreenLayout = YES;

  // Create OpenGL view (here for OpenGL ES 1.1)
  Isgl3dEAGLView * glView = [Isgl3dEAGLView viewWithFrameForES1:self.view.bounds];
  // Set view in director
  [Isgl3dDirector sharedInstance].openGLView = glView;

  // Enable retina display : uncomment if desired
  //  [[Isgl3dDirector sharedInstance] enableRetinaDisplay:YES];

  // Set the animation frame rate
  [[Isgl3dDirector sharedInstance] setAnimationInterval:1.0/60];

  // Add the OpenGL view to the view controller
  //_view = [glView retain];
  self.view = glView;

  // Creates the view(s) and adds them to the director
  [self createViews];

  // Run the director
  [[Isgl3dDirector sharedInstance] run];
}

#pragma mark - Rotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Cleanup

@end
