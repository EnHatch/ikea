

#import "Isgl3dSkeletonNode.h"
#import "EHAnimationController.h"

@implementation EHAnimationController

@synthesize repeat = _repeat;
@synthesize frameRate = _frameRate;

+ (id)controllerWithSkeleton:(Isgl3dSkeletonNode *)skeleton andNumberOfFrames:(unsigned int)numberOfFrames {
	return [[[self alloc] initWithSkeleton:skeleton andNumberOfFrames:numberOfFrames] autorelease];
}

- (id)initWithSkeleton:(Isgl3dSkeletonNode *)skeleton andNumberOfFrames:(unsigned int)numberOfFrames {
    if ((self = [super init])) {
		_skeleton = [skeleton retain];
		_numberOfFrames = numberOfFrames;
		_currentFrame = 0;
		
		_frameRate = 30;
		_repeat = YES;
		_animating = NO;
		_animationTimer = nil;
    }
	
    return self;
}

- (void)dealloc {
	[_skeleton release];
	if (_animating) {
		[self pause];
	}
	
	[super dealloc];
}

- (void)setFrame:(unsigned int)frame {
	if (frame < _numberOfFrames) {
		_currentFrame = frame;
		[_skeleton setFrame:_currentFrame];
	}
}

- (void)nextFrame {
	_currentFrame++;
	if (_currentFrame == _numberOfFrames) {
		
		if (_repeat) {
			_currentFrame = 0;
			[_skeleton setFrame:_currentFrame];
            
		} else {
			_currentFrame = _numberOfFrames - 1;
			[self pause];
		}
	} else {
		[_skeleton setFrame:_currentFrame];
	}
	
}

- (void)start {
	if (!_animating) {
        if(_currentFrame == _numberOfFrames -1)
        {
            _currentFrame = 0;
        }
		_animating = YES;
        
		_animationTimer = [NSTimer scheduledTimerWithTimeInterval:(NSTimeInterval)(1.0 / _frameRate) target:self selector:@selector(updateAnimation:) userInfo:nil repeats:TRUE];
	}
}

- (void)stop {
	if (_animating) {
		[_animationTimer invalidate];
        
		_animationTimer = nil;
		_animating = NO;
		
		_currentFrame = 0;
	}
	
}

- (void)pause {
	if (_animating) {
		[_animationTimer invalidate];
        
		_animationTimer = nil;
		_animating = NO;
	}
}

- (void)updateAnimation:(id)sender {
	[self nextFrame];
}

@end

