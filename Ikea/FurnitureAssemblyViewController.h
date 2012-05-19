//
//  FurnitureAssemblyViewControllerViewController.h
//  Ikea
//
//  Created by David Kay on 5/19/12.
//  Copyright (c) 2012 Gargoyle Software. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "isgl3d.h"

@interface FurnitureAssemblyViewController : UIViewController

@property (nonatomic, retain) IBOutlet UIView *modelWrapper;

//@property (nonatomic, retain) PODModelView *podModelView;
@property (nonatomic, retain) Isgl3dBasic3DView *podModelView;

@end
