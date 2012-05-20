// //  PODModelView.h //  Ikea
//
//  Created by David Kay on 5/19/12.
//  Copyright (c) 2012 EnHatch, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "isgl3d.h"

@class Isgl3dIkeaCameraController;

@interface PODModelView : Isgl3dBasic3DView {

  @private
      NSInteger _currentIndex;

} 

@property (nonatomic, retain) Isgl3dIkeaCameraController * cameraController;
@property (nonatomic, retain) NSArray *modelNames;
@property NSInteger modelIndex;

- (id)initWithModelNames:(NSArray *)modelNames;

- (void)loadNext;
- (void)loadPrev;

- (void)toggleCaption;

- (void)pauseAnimation;
- (void)startAnimation;
- (void)rewindAnimation;

@end
