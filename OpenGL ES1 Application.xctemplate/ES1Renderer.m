//
//  ___FILENAME___
//  ___PACKAGENAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//___COPYRIGHT___
//

#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import "ES1Renderer.h"

@implementation ES1Renderer

- (void)setupGL
{
    _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
    if (!_context || ![EAGLContext setCurrentContext:_context]) {
        NSLog(@"Failed to initialize OpenGLES1 API");
        abort();
    }
    
    [EAGLContext setCurrentContext:_context];
    
    glGenFramebuffersOES(1, &_defaultFramebuffer);
    glGenRenderbuffersOES(1, &_colorRenderbuffer);
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, _defaultFramebuffer);
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, _colorRenderbuffer);
    glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, _colorRenderbuffer);
}

- (void)tearDownGL
{
    // Tear down GL
    if (_defaultFramebuffer) {
        glDeleteFramebuffersOES(1, &_defaultFramebuffer);
        _defaultFramebuffer = 0;
    }
    
    if (_colorRenderbuffer) {
        glDeleteRenderbuffersOES(1, &_colorRenderbuffer);
        _colorRenderbuffer = 0;
    }
    
    // Tear down context
    if ([EAGLContext currentContext] == _context) {
        [EAGLContext setCurrentContext:nil];
    }
    _context = nil;
}

- (BOOL)resizeFromLayer:(CAEAGLLayer *)layer;
{
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, _colorRenderbuffer);
    [_context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:layer];
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &_backingWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &_backingHeight);
    
    if (glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES) {
        NSLog(@"Failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
        return NO;
    }
    return YES;
}

- (void)render
{
    // Replace the implementation of this method to do your own custom drawing
#ifndef DELETE_THIS
    GLfloat scaleX = 1.0f, scaleY = 1.0f;
    if (_backingWidth > _backingHeight) {
        scaleX = (GLfloat)_backingWidth / (GLfloat)_backingHeight;
    } else if (_backingHeight > _backingWidth) {
        scaleY = (GLfloat)_backingHeight / (GLfloat)_backingWidth;
    }
    const GLfloat squareVertices[] = {
        -0.5f / scaleX, -0.5f / scaleY,
        0.5f / scaleX, -0.5f / scaleY,
        -0.5f / scaleX, 0.5f / scaleY,
        0.5f / scaleX, 0.5f / scaleY,
    };
    static const GLubyte squareColors[] = {
        255, 255, 0, 255,
        0, 255, 255, 255,
        0, 0, 0, 0,
        255, 0, 255, 255,
    };
    static float transY = 0.0f;
#endif
    
    // This application only creates a single context which is already set current at this point.
    // This call is redundant, but needed if dealing with multiple contexts.
    [EAGLContext setCurrentContext:_context];
    
    // This application only creates a single default framebuffer which is already bound at this point.
    // This call is redundant, but needed if dealing with multiple framebuffers.
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, _defaultFramebuffer);
    glViewport(0, 0, _backingWidth, _backingHeight);
    
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
#ifndef DELETE_THIS
    glTranslatef(0.0f, (GLfloat)(sinf(transY)/2.0f), 0.0f);
    transY += 0.075f;
#endif
    
    glClearColor(0.5f, 0.5f, 0.5f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
#ifndef DELETE_THIS
    glVertexPointer(2, GL_FLOAT, 0, squareVertices);
    glEnableClientState(GL_VERTEX_ARRAY);
    glColorPointer(4, GL_UNSIGNED_BYTE, 0, squareColors);
    glEnableClientState(GL_COLOR_ARRAY);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
#endif
    
    // This application only creates a single color renderbuffer which is already bound at this point.
    // This call is redundant, but needed if dealing with multiple renderbuffers.
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, _colorRenderbuffer);
    [_context presentRenderbuffer:GL_RENDERBUFFER_OES];
}

@end
