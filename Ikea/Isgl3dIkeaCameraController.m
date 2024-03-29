/*
 * iSGL3D: http://isgl3d.com
 *
 * Copyright (c) 2010-2012 Stuart Caunt
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#import "Isgl3dIkeaCameraController.h"

#define DAMPING_FACTOR .785


@interface Isgl3dIkeaCameraController () {
    @private
    Isgl3dNodeCamera *_camera;
    Isgl3dView * _view;

    Isgl3dNode * _target;

    float _orbit;
    float _orbitMin;
    float _vTheta;
    float _vPhi;
    float _theta;
    float _phi;
    float _damping;
    BOOL _doubleTapEnabled;
}
- (void)reset;
- (float)distanceBetweenPoint1:(CGPoint)point1 andPoint2:(CGPoint)point2;
@end

/**
 * A Simple camera controller: the camera orbits around the origin or a target node (if one has been set). Single touch
 * movement adds rotation to the camera in altitude and azimuth directions. Double touch will modify the orbital
 * radius of the camera.
 *
 * This camera controller will only modify the camera if the touches begain in the specified view
 */
@implementation Isgl3dIkeaCameraController

@synthesize target = _target;
@synthesize orbit = _orbit;
@synthesize orbitMin = _orbitMin;
@synthesize theta = _theta;
@synthesize phi = _phi;
@synthesize damping = _damping;
@synthesize doubleTapEnabled = _doubleTapEnabled;
@synthesize light = _light;

- (id)initWithNodeCamera:(Isgl3dNodeCamera *)camera andView:(Isgl3dView *)view {

    if ((self = [super init])) {

        _camera = [camera retain];
        _view = [view retain];

        // Initialise the controller
        [self reset];
    }

    return self;
}

- (void)dealloc {
    [_camera release];
    [_view release];

    if (_target) {
        [_target release];
    }

    [super dealloc];
}

- (void)reset {

    // Reset all variables to their defaults
    _orbit = 10;
    _orbitMin = 3;
    _theta = 0;
    _phi = 0;
    _vTheta = 0;
    _vPhi = 0;
    _damping = 0.99;
    _doubleTapEnabled = YES;

    // Release the target if it exists and reset camera look-at
    if (_target) {
        [_target release];
        _target = nil;

        _camera.lookAtTarget = Isgl3dVector3Make(0.0f, 0.0f, 0.0f);
    }

}

- (void)update {
    // Update and limit the camera angles
    _theta -= _vTheta;
    _phi -= _vPhi;
    if (_phi >= 90.0) {
        _phi = 89.9;
    }
    if (_phi <= -90.0) {
        _phi = -89.9;
    }

    if (_orbit < _orbitMin) {
        _orbit = _orbitMin;
    }

    // Convert camera angles to positions
    float y = _orbit * sin(_phi * M_PI / 180);
    float l = _orbit * cos(_phi * M_PI / 180);
    float x = l * sin(_theta * M_PI / 180);
    float z = l * cos(_theta * M_PI / 180);

    // Take target into account if it exists

    if (_target) {
        Isgl3dVector3 targetPosition = _target.worldPosition;

        x += targetPosition.x;
        y += targetPosition.y;
        z += targetPosition.z;

        _camera.lookAtTarget = targetPosition;
    }

    // Translate camera
    //_camera.initialPosition = Isgl3dVector3Make(x, y, z);
    _camera.position = Isgl3dVector3Make(x, y, z);
    //_camera.eyePosition = Isgl3dVector3Make(x, y, z);
    //[_camera setEyePosition: Isgl3dVector3Make(x, y, z)];

    self.light.position = _camera.eyePosition;



    // Add damping to camera velocities
    _vTheta *= DAMPING_FACTOR;
    _vPhi   *= DAMPING_FACTOR;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    // Test for touches if no 3D object has been touched
    if (![Isgl3dDirector sharedInstance].objectTouched && ![Isgl3dDirector sharedInstance].isPaused) {

        NSEnumerator * enumerator = [touches objectEnumerator];
        UITouch * touch1 = [enumerator nextObject];

        // Test for single touch only
        if ([touches count] == 1) {

            // Reset camera controller on double tap (if enabled)...
            if ([touch1 tapCount] >= 2 && _doubleTapEnabled)	{
                [self reset];

                // ... otherwise stop the movement
            } else {
                _vTheta = 0;
                _vPhi = 0;
            }
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    // Do nothing
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![Isgl3dDirector sharedInstance].isPaused) {
        NSEnumerator * enumerator = [touches objectEnumerator];
        UITouch * touch1 = [enumerator nextObject];

        // For single touch event: set the camera velocities...
        if ([touches count] == 1) {
            CGPoint location = [_view convertUIPointToView:[touch1 locationInView:touch1.view]];
            CGPoint previousLocation = [_view convertUIPointToView:[touch1 previousLocationInView:touch1.view]];

            _vPhi = (location.y - previousLocation.y) / 4;
            _vTheta = (location.x - previousLocation.x) / 4;

            // ... for double touch, modify the orbital distance of the camera
        } else if ([touches count] == 2) {
            UITouch * touch2 = [enumerator nextObject];

            CGPoint location1         = [_view convertUIPointToView:[touch1 locationInView:touch1.view]];
            CGPoint previousLocation1 = [_view convertUIPointToView:[touch1 previousLocationInView:touch1.view]];
            CGPoint location2         = [_view convertUIPointToView:[touch2 locationInView:touch2.view]];
            CGPoint previousLocation2 = [_view convertUIPointToView:[touch2 previousLocationInView:touch2.view]];

            float previousDistance = [self distanceBetweenPoint1:previousLocation1 andPoint2:previousLocation2];
            float currentDistance = [self distanceBetweenPoint1:location1 andPoint2:location2];

            float changeInDistance = currentDistance - previousDistance;
            //_orbit += changeInDistance * 0.1;
            _orbit -= changeInDistance * 0.2;
        }
    }
}

/**
 * Calculate the distance between two CGPoints
 */
- (float)distanceBetweenPoint1:(CGPoint)point1 andPoint2:(CGPoint)point2 {
    float dx = point1.x - point2.x;
    float dy = point1.y - point2.y;

    return sqrt(dx*dx + dy*dy);
}

@end
