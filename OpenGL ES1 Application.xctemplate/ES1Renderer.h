//
//  ___FILENAME___
//  ___PACKAGENAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//___COPYRIGHT___
//

#import "ESRenderer.h"

@interface ES1Renderer : NSObject <ESRenderer> {
    EAGLContext *_context;
    GLuint _defaultFramebuffer;
    GLuint _colorRenderbuffer;
    GLint _backingWidth;
    GLint _backingHeight;
}

- (void)setupGL;
- (void)tearDownGL;

@end
