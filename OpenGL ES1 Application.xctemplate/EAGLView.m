//
//  ___FILENAME___
//  ___PACKAGENAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//___COPYRIGHT___
//

#import "EAGLView.h"

@implementation EAGLView {
    BOOL _animating;
}

- (void)_setup
{
    _animating = NO;
    _animationFrameInterval = 1;
    
    CAEAGLLayer *layer = (CAEAGLLayer *)(self.layer);
    layer.opaque = YES;
    layer.drawableProperties = @{kEAGLDrawablePropertyRetainedBacking:@NO,
                                 kEAGLDrawablePropertyColorFormat:kEAGLColorFormatRGBA8};
    
    _renderer = [[ES1Renderer alloc] init];
    [_renderer setupGL];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _setup];
    }
    return self;
}

- (void)dealloc
{
    [self stopAnimation];
    [_renderer tearDownGL];
    _renderer = nil;
}

+ (Class)layerClass
{
    return [CAEAGLLayer class];
}

- (BOOL)animating
{
    return _animating;
}

- (void)setAnimationFrameInterval:(NSInteger)animationFrameInterval
{
    if (animationFrameInterval >= 1)	{
		_animationFrameInterval = animationFrameInterval;
		
		if (_animating) {
			[self stopAnimation];
			[self startAnimation];
		}
	}
}

- (void)startAnimation
{
    if (!_animating) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(drawView:)];
        [_displayLink setFrameInterval:_animationFrameInterval];
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        _animating = YES;
    }
}

- (void)stopAnimation
{
	if (_animating) {
        [_displayLink invalidate];
        _displayLink = nil;
        _animating = FALSE;
    }
}

- (void)drawView:(id)sender
{
    [_renderer render];
}

- (void)layoutSubviews
{
	[_renderer resizeFromLayer:(CAEAGLLayer *)self.layer];
    [self drawView:nil];
}

@end
