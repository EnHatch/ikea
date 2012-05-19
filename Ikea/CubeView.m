//
//  CubeView.m
//  Ikea
//
//  Created by David Kay on 5/19/12.
//  Copyright (c) 2012 EnHatch, Inc. All rights reserved.
//

#import "CubeView.h"

@implementation CubeView

- (id) init {

  if ((self = [super init])) {

    // Translate the camera
    self.camera.position = iv3(0, 3, 8);

    // Create an Isgl3dMultiMaterialCube with random colors.
    _cube = [Isgl3dMultiMaterialCube cubeWithDimensionsAndRandomColors:3 height:3 depth:3 nSegmentWidth:2 nSegmentHeight:2 nSegmentDepth:2];

    // Add the cube to the scene.
    [self.scene addChild:_cube];

    // Schedule updates
    [self schedule:@selector(tick:)];
  }

  return self;
}

- (void) dealloc {
  [super dealloc];
}

- (void) tick:(float)dt {
  // Rotate the cube by 1 degree about its y-axis
  _cube.rotationY += 1;
}

@end
