//
//  ___FILENAME___
//  ___PACKAGENAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//___COPYRIGHT___
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import "ES1Renderer.h"

@interface EAGLView : UIView

@property (strong, nonatomic) ES1Renderer *renderer;

@property (strong, nonatomic) CADisplayLink *displayLink;
@property (nonatomic, readonly) BOOL animating;
@property (nonatomic) NSInteger animationFrameInterval;

- (void)startAnimation;
- (void)stopAnimation;

@end
