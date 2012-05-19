//
//  FurnitureAssemblyViewControllerViewController.h
//  Ikea
//
//  Created by David Kay on 5/19/12.
//  Copyright (c) 2012 Gargoyle Software. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "isgl3d.h"

@class PODModelView;

@interface FurnitureAssemblyViewController : UIViewController

@property (nonatomic, retain) IBOutlet UIView *modelWrapper;

@property (nonatomic, retain) PODModelView *podModelView;
//@property (nonatomic, retain) Isgl3dBasic3DView *podModelView;

- (IBAction)prevButtonWasPressed:(id)sender;
- (IBAction)nextButtonWasPressed:(id)sender;
- (IBAction)infoButtonWasPressed:(id)sender;
- (IBAction)playButtonWasPressed:(id)sender;

@end
