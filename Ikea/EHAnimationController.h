//
//  EHAnimationController.h
//  Ikea
//
//  Created by Peter Verrillo on 5/19/12.
//  Copyright (c) 2012 Gargoyle Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "isgl3d.h"
@class Isgl3dSkeletonNode;

@interface EHAnimationController : NSObject {

@private
    Isgl3dSkeletonNode * _skeleton;
    unsigned int _currentFrame;
    unsigned int _numberOfFrames;

    BOOL _repeat;
    float _frameRate;
    BOOL _animating;

    NSTimer * _animationTimer;

}


/**
 * Specifies whether the animation should be repeated or not. 
 * The default value is true.
 */
@property (nonatomic) BOOL repeat;

/**
 * Specifies the desired frame rate for the animation. 
 * The default value is 30fps. 
 */
@property (nonatomic) float frameRate;


/**
 * Allocates and initialises (autorelease) animation controller with a given skeleton and specifies the number of frames.
 * @param skeleton The skeleton to be animated (containing Isgl3dBoneNodes and/or Isgl3dAnimatedMeshes).
 * @param numberOfFrames The number of frames contained in the animation sequence.
 */
+ (id)controllerWithSkeleton:(Isgl3dSkeletonNode *)skeleton andNumberOfFrames:(unsigned int)numberOfFrames;

/**
 * Initialises the animation controller with a given skeleton and specifies the number of frames.
 * @param skeleton The skeleton to be animated (containing Isgl3dBoneNodes and/or Isgl3dAnimatedMeshes).
 * @param numberOfFrames The number of frames contained in the animation sequence.
 */
- (id)initWithSkeleton:(Isgl3dSkeletonNode *)skeleton andNumberOfFrames:(unsigned int)numberOfFrames;

/**
 * Explicitly sets the current frame number and updates the skeleton.
 * If the frame number is greater or equal to the number of frames (0 being the first frame) then
 * the value is ignored.
 * @param frame The desired frame number (between 0 and numberOfFrames - 1)
 */
- (void)setFrame:(unsigned int)frame;

/**
 * Increments the current frame number.
 * If the next frame number is equal to the number of frames (ie at the end of the animation) then either
 * the frame number is set to zero (if repeating animation has been chosen) or it stays at the last frame
 * and the animation stops.
 */
- (void)nextFrame;

/**
 * Starts the animation (if it is not already started). 
 * An NSTimer automatically calls nextFrame for the desired frame rate. 
 */
- (void)start;

/**
 * Stops the animation.
 * The NSTimer (used for automatic animation) is destroyed and the current frame is set to zero.
 */
- (void)stop;

/**
 * Pauses the animation.
 * The NSTimer (used for automatic animation) is destroyed but the current frame number is retained.
 */
- (void)pause;

@end