//
//  CubeView.m
//  Ikea
//
//  Created by David Kay on 5/19/12.
//  Copyright (c) 2012 EnHatch, Inc. All rights reserved.
//

#import "CubeView.h"

@implementation CubeView

#pragma mark - Camera

+ (id<Isgl3dCamera>)createDefaultSceneCameraForViewport:(CGRect)viewport {
    Isgl3dClassDebugLog(Isgl3dLogLevelInfo, @"creating default camera with perspective projection. Viewport size = %@", NSStringFromCGSize(viewport.size));
    
    CGSize viewSize = viewport.size;
    float fovyRadians = Isgl3dMathDegreesToRadians(45.0f);
    Isgl3dPerspectiveProjection *perspectiveLens = [[Isgl3dPerspectiveProjection alloc] initFromViewSize:viewSize fovyRadians:fovyRadians nearZ:1.0f farZ:10000.0f];
    
    Isgl3dVector3 cameraPosition = Isgl3dVector3Make(0.0f, 0.0f, 10.0f);
    Isgl3dVector3 cameraLookAt = Isgl3dVector3Make(0.0f, 0.0f, 0.0f);
    Isgl3dVector3 cameraLookUp = Isgl3dVector3Make(0.0f, 1.0f, 0.0f);
    Isgl3dLookAtCamera *standardCamera = [[Isgl3dLookAtCamera alloc] initWithLens:perspectiveLens
                                                                             eyeX:cameraPosition.x eyeY:cameraPosition.y eyeZ:cameraPosition.z
                                                                          centerX:cameraLookAt.x centerY:cameraLookAt.y centerZ:cameraLookAt.z
                                                                              upX:cameraLookUp.x upY:cameraLookUp.y upZ:cameraLookUp.z];
    [perspectiveLens release];
    return [standardCamera autorelease];
}

#pragma mark - Init

- (id) init {

  if ((self = [super init])) {

    // Translate the camera
    Isgl3dLookAtCamera *standardCamera = (Isgl3dLookAtCamera *)self.defaultCamera;
    standardCamera.eyePosition = Isgl3dVector3Make(0.0f, 3.0f, 8.0f);

    // Create an Isgl3dMultiMaterialCube with random colors.
    _cube = [Isgl3dMultiMaterialCube cubeWithDimensionsAndRandomColors:3 height:3 depth:3 nSegmentWidth:2 nSegmentHeight:2 nSegmentDepth:2];

    // Add the cube to the scene.
    [self.scene addChild:_cube];

    // Schedule updates
    [self schedule:@selector(tick:)];
  }

  return self;
}

#pragma mark - Cleanup

- (void) dealloc {
  [super dealloc];
}

#pragma mark - Render

- (void) tick:(float)dt {
  // Rotate the cube by 1 degree about its y-axis
  _cube.rotationY += 1;
}

@end
