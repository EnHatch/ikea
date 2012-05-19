//
//  FurnitureAssemblyViewControllerViewController.m
//  Ikea
//
//  Created by David Kay on 5/19/12.
//  Copyright (c) 2012 Gargoyle Software. All rights reserved.
//

#import "isgl3d.h"

#import "FurnitureAssemblyViewController.h"

#import "CubeView.h"
#import "PODModelView.h"

#define GL_VIEW_TAG 1337

@interface FurnitureAssemblyViewController ()

@end

@implementation FurnitureAssemblyViewController

@synthesize modelWrapper = _modelWrapper;
@synthesize podModelView = _podModelView;

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

//- (void)loadView
//{
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self init3d];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.

    [[Isgl3dDirector sharedInstance] end];
    [[self.view viewWithTag: GL_VIEW_TAG] removeFromSuperview];
}

#pragma mark - 3D

- (void)createViews {
#if 0
  Isgl3dView *view = [CubeView view];
#else

  NSArray *modelNames = [NSArray arrayWithObjects: 
  @"step1_n.pod",
  //@"man.pod", 
  nil];

  PODModelView *view = [[PODModelView alloc] initWithModelNames:modelNames];
#endif

  view.displayFPS = YES;
  [[Isgl3dDirector sharedInstance] addView:view];
  
  self.podModelView = view;
}

- (void)init3d {
  // Instantiate the Isgl3dDirector and set background color
  [Isgl3dDirector sharedInstance].backgroundColorString = @"333333ff"; 

  // Set the director to display the FPS
  //[Isgl3dDirector sharedInstance].displayFPS = YES; 

  // Create OpenGL view (here for OpenGL ES 1.1)
  CGRect modelFrame = self.modelWrapper.frame;
  NSLog(@"3d frame: %f, %f, %f, %f",
  modelFrame.origin.x,
  modelFrame.origin.y,
  modelFrame.size.width,
  modelFrame.size.height);
  Isgl3dEAGLView * glView = [Isgl3dEAGLView viewWithFrameForES1: modelFrame];
  glView.tag = GL_VIEW_TAG;
  // Set view in director
  [Isgl3dDirector sharedInstance].openGLView = glView;

  // Enable retina display : uncomment if desired
  [[Isgl3dDirector sharedInstance] enableRetinaDisplay:YES];

  // Set the animation frame rate
  [[Isgl3dDirector sharedInstance] setAnimationInterval:1.0/60];

  // Add the OpenGL view to the view controller
  //_view = [glView retain];
  //self.view = glView;
  [self.view addSubview: glView];

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

- (void) dealloc {
  NSLog(@"FurnitureAssemblyViewController dealloc");

  //self.podModelView = nil;
  [[Isgl3dDirector sharedInstance] end];

  [super dealloc];
}


@end
