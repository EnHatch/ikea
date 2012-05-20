//
//  PODModelView.m
//  Ikea
//
//  Created by David Kay on 5/19/12.
//  Copyright (c) 2012 EnHatch, Inc. All rights reserved.
//

#import "Isgl3dPODImporter.h"

#import "PODModelView.h"

#import "Isgl3dIkeaCameraController.h"
#import "EHAnimationController.h"

@interface PODModelView ()

//@property (nonatomic, retain) Isgl3dAnimationController * animationController;
@property (nonatomic, retain) EHAnimationController *animationController;

@end

@implementation PODModelView

@synthesize modelNames = _modelNames;
@synthesize cameraController = _cameraController;
@synthesize animationController = _animationController;
@synthesize modelIndex = _modelIndex;

#pragma mark - Initialization 

- (id) initWithModelNames:(NSArray *)modelNames {
  if ((self = [super init])) {

    self.modelNames = modelNames;

    //[self enableShadows];
    [self createCameraController];

    if (self.modelNames.count) {
      [self loadModelWithIndex: 0];
    }
  }

  return self;
}

#pragma mark - Public Methods

- (void)toggleCaption {
    NSLog(@"toggleCaption");
}

- (void)pauseAnimation {
    [_animationController pause];
}

- (void)startAnimation {
    [_animationController start];
}

- (void)rewindAnimation {
    [_animationController stop];
}

#pragma mark - First Run

- (Isgl3dIkeaCameraController *)createCameraController {
  if (_cameraController) {
    [_cameraController release];
    _cameraController = nil;
  }
  // Create and configure touch-screen camera controller
#if 0
  CGSize viewSize = self.viewport.size;
  float fovyRadians = Isgl3dMathDegreesToRadians(45.0f);
  Isgl3dPerspectiveProjection *perspectiveLens = [[Isgl3dPerspectiveProjection alloc] initFromViewSize:viewSize fovyRadians:fovyRadians nearZ:1.0f farZ:10000.0f];
  Isgl3dLookAtCamera *cam = [[Isgl3dLookAtCamera alloc] initWithLens:perspectiveLens eyeX:0.0f eyeY:0.0f eyeZ:20.0f centerX:0.0f centerY:0.0f centerZ:0.0f upX:0.0f upY:1.0f upZ:0.0f];
  [perspectiveLens release];

#else
  Isgl3dNodeCamera *cam = (Isgl3dNodeCamera *)self.defaultCamera;
#endif

  self.activeCamera = cam;

  _cameraController = [[Isgl3dIkeaCameraController alloc] initWithNodeCamera:cam andView:self];
  [cam release];
  _cameraController.doubleTapEnabled = NO;

  _cameraController.orbit = 120;
  _cameraController.theta = 30;
  _cameraController.phi = 30;

  return _cameraController;
}

#pragma mark - Mesh persistence

- (void)clearScene {
  @synchronized (self.scene) {
    [self.scene clearAll];
  }
}

#pragma mark - Model Loading

- (void)loadPrev {
  NSLog(@"loadPrev called");
  if (_currentIndex > 0) {
    NSLog(@"loadPrev");
    //[self zeroEverything];
    _currentIndex--;
    [self loadModelWithIndex: _currentIndex];
  }
  
  self.modelIndex = _currentIndex;
}

- (void)loadNext {
  NSLog(@"loadNext called");
  if (_currentIndex < self.modelNames.count - 1) {
    NSLog(@"loadNext");
    //[self zeroEverything];
    _currentIndex++;
    [self loadModelWithIndex: _currentIndex];
  }
  
  self.modelIndex = _currentIndex;
}

- (void)loadModelWithName:(NSString *)modelName {
    NSLog(@"loading model with filename: %@", modelName);
    [self unschedule];
    [self clearScene];

    //Isgl3dPODImporter * podImporter = [Isgl3dPODImporter podImporterWithFile:modelName];
    Isgl3dPODImporter * podImporter = [Isgl3dPODImporter podImporterWithResource:modelName];

    Isgl3dSkeletonNode *skel = [self.scene createSkeletonNode];
    [podImporter addMeshesToScene: skel];
    [podImporter printPODInfo];

    NSLog(@"number of frames = %d", [podImporter numberOfFrames]);
    if([podImporter numberOfFrames] > 0) {

        if (_animationController) {
            self.animationController = nil;
        }
        _animationController = [[EHAnimationController alloc]
            initWithSkeleton:skel
            andNumberOfFrames:[podImporter numberOfFrames]];
        _animationController.repeat = NO;
    } else {
        // No animation
        if (_animationController) {
            self.animationController = nil;
        }
    }
  
  NSLog(@"viewPort: %f, %f, %f, %f",
      self.viewport.origin.x,
      self.viewport.origin.y,
      self.viewport.size.width,
      self.viewport.size.height
  );

  Isgl3dNodeCamera *cam = (Isgl3dNodeCamera *)self.defaultCamera;
  Isgl3dMatrix4 viewMatrix = cam.viewMatrix;
  NSLog(@"viewMatrix:    \
         %f, %f, %f, %f, \
         %f, %f, %f, %f, \
         %f, %f, %f, %f, \
         %f, %f, %f, %f", \
        viewMatrix.m00, viewMatrix.m01, viewMatrix.m02, viewMatrix.m03,
        viewMatrix.m10, viewMatrix.m11, viewMatrix.m12, viewMatrix.m13,
        viewMatrix.m20, viewMatrix.m21, viewMatrix.m22, viewMatrix.m23,
        viewMatrix.m30, viewMatrix.m31, viewMatrix.m32, viewMatrix.m33);

    [self setupLight];
    //[self zeroCamera];

    // Schedule updates
    [self schedule:@selector(tick:)];
}

- (void)loadModelWithIndex:(NSUInteger)index {
  [self loadModelWithName: [self.modelNames objectAtIndex: index]];
}

#pragma mark - Events

- (void) onActivated {
  // Add camera controller to touch-screen manager
  [[Isgl3dTouchScreen sharedInstance] addResponder:_cameraController];
}

- (void) onDeactivated {
  // Remove camera controller from touch-screen manager
  [[Isgl3dTouchScreen sharedInstance] removeResponder:_cameraController];
}

- (void) tick:(float)dt {
  [_cameraController update];
}

- (void) setupLight
{
    Isgl3dShadowCastingLight * light  = [Isgl3dShadowCastingLight lightWithHexColor:@"FFFFFF" diffuseColor:@"FFFFFF" specularColor:@"FFFFFF" attenuation:0.00];
    light.position = self.activeCamera.eyePosition;
    [light setLightType:DirectionalLight];
    [self.scene addChild:light];
    self.cameraController.light = light;
}

#pragma mark - Cleanup

- (void) dealloc {
  [self clearScene];
  
  self.animationController = nil;

  [super dealloc];
}


@end
