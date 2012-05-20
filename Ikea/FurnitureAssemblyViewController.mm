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

#define HIDE_NAVBAR_DELAY 2.0

@interface FurnitureAssemblyViewController ()

@end

@implementation FurnitureAssemblyViewController

@synthesize glView = _glView;

@synthesize modelWrapper = _modelWrapper;
@synthesize podModelView = _podModelView;
@synthesize animating = _animating;

@synthesize nextButton = _nextButton;
@synthesize prevButton = _prevButton;
@synthesize playButton = _playButton;
@synthesize navTitle = _navTitle;

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
    [self initGestures];
    
    [self init3d];

    self.navigationItem.title = self.navTitle;
}

- (void)viewDidUnload
{
    NSLog(@"FurnitureAssemblyViewController viewDidUnload");
    // Release any retained subviews of the main view.

    [[Isgl3dDirector sharedInstance] end];
    [[self.view viewWithTag: GL_VIEW_TAG] removeFromSuperview];
    
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];

    //[self hideNavbarWithDelay];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];

    //[self hideNavbar];
    [self hideNavbarWithDelay];
  
    NSLog(@"FurnitureAssemblyViewController view: %f, %f, %f, %f",
            self.view.frame.origin.x,
            self.view.frame.origin.y,
            self.view.frame.size.width,
            self.view.frame.size.height
         );
}

#pragma mark - View Manipulation

- (void)hideNavbarWithDelay {
    //if (withDelay) {
    //    int parameter1 = 12;
    //    float parameter2 = 144.1
    //    // Delay execution of my block for 10 seconds.
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC), dispatch_get_current_queue(), ^{
    //        NSLog(@"parameter1: %d parameter2: %f", parameter1, parameter2);
    //        [self.navigationController setNavigationBarHidden:YES animated:YES];
    //    });
    //} else {
    //    [self.navigationController setNavigationBarHidden:YES animated:YES];
    //}

    [self performSelector: @selector(hideNavbar) withObject: nil afterDelay: HIDE_NAVBAR_DELAY];

}

- (void)hideNavbar {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
   //  [[UIApplication sharedApplication] setStatusBarHidden:NO animated:NO];
}

#pragma mark - UI Callbacks

- (IBAction)prevButtonWasPressed:(id)sender {
    [self.podModelView loadPrev];
    
    if (self.podModelView.modelIndex < 1) 
    {
        self.prevButton.hidden = YES;
        self.playButton.hidden = YES;
    }
    else 
    {
        self.prevButton.hidden = NO;
    }
    
    self.nextButton.hidden = NO;
}

- (IBAction)nextButtonWasPressed:(id)sender {
    [self.podModelView loadNext];
        if (self.podModelView.modelIndex == 11) 
    {
        self.nextButton.hidden = YES;
    }
    else 
    {
        self.nextButton.hidden = NO;
    }
    
    self.prevButton.hidden = NO;
    self.playButton.hidden = NO;
    
}

- (IBAction)playButtonWasPressed:(id)sender {
    //[self toggleAnimation];
    [self.podModelView startAnimation];
}

#pragma mark - Animation

- (void)toggleAnimation {
    if (self.isAnimating) {
        [self.podModelView pauseAnimation];
    } else {
        [self.podModelView startAnimation];
    }
    self.animating = !self.isAnimating;
}

#pragma mark - 3D

- (void)createViews {
#if 0
  Isgl3dView *view = [CubeView view];
#else

  NSArray *modelNames = [NSArray arrayWithObjects:
    //@"step1_n.pod",
    //@"step3_n.pod",
   //@"step2_n.pod",
    @"start_good.pod",
    @"step1_good.pod",
    @"step2_good.pod",
    @"step3_good.pod",
    @"step4_good.pod",
    @"step5_good.pod",
    @"step6_good.pod",
    @"step7_good.pod",
    @"step8_good.pod",
    @"step9_good.pod",
    @"step10_good.pod",
    @"step11_good.pod",
    //@"testikea.pod",
    //@"ikeatest2.pod",
    //@"man.pod",
  nil];

  PODModelView *view = [[PODModelView alloc] initWithModelNames:modelNames];
#endif

  //view.displayFPS = YES;
  [[Isgl3dDirector sharedInstance] addView:view];

  self.podModelView = view;
}

- (void)init3d {
    // Instantiate the Isgl3dDirector and set background color
    [Isgl3dDirector sharedInstance].backgroundColorString = @"ffffff";

    // Set the director to display the FPS
    //[Isgl3dDirector sharedInstance].displayFPS = YES;

    // Create OpenGL view (here for OpenGL ES 1.1)
    //CGRect modelFrame = self.modelWrapper.frame;
    CGRect modelFrame = self.view.bounds;
    NSLog(@"3d frame: %f, %f, %f, %f",
    modelFrame.origin.x,
    modelFrame.origin.y,
    modelFrame.size.width,
    modelFrame.size.height);
    Isgl3dEAGLView * glView = [Isgl3dEAGLView viewWithFrameForES1: modelFrame];
    glView.tag = GL_VIEW_TAG;

    [glView addSubview:self.nextButton];
    [glView addSubview:self.prevButton];
    [glView addSubview:self.playButton];
    
    self.prevButton.hidden = YES;
    self.playButton.hidden = YES;
    
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
    self.glView = glView;

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

#pragma mark - Gestures

-(void)initGestures
{
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singleTap.numberOfTapsRequired = 2;
    singleTap.delegate = self;
    [self.view addGestureRecognizer:singleTap];
    [singleTap release];
    
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if([touch.view isKindOfClass:[UIButton class]])
    {
        return NO;
    }
    
    return YES;
}

- (IBAction)singleTap:(id)sender
{
    
    [self.navigationController setNavigationBarHidden:NO animated:YES]; 
    
    [self performSelector:@selector(hideNavigationBar:) withObject:nil afterDelay: HIDE_NAVBAR_DELAY];
}

- (IBAction)hideNavigationBar:(id)sender
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - Cleanup

- (void) dealloc {
  NSLog(@"FurnitureAssemblyViewController dealloc");

  //self.podModelView = nil;
  self.nextButton = nil;
  self.prevButton = nil;
  self.playButton = nil;
  
  self.glView = nil;

  [[Isgl3dDirector sharedInstance] end];

  [super dealloc];
}


@end
