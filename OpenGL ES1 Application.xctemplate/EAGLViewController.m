//
//  ___FILENAME___
//  ___PACKAGENAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//___COPYRIGHT___
//

#import "EAGLViewController.h"

@interface EAGLViewController ()

@property (strong, nonatomic) id didEnterBackgroundObserver;
@property (strong, nonatomic) id willEnterForegroundObserver;

@end

@implementation EAGLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    __weak EAGLView *_eaGlView = self.eaGlView;
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    _didEnterBackgroundObserver = [nc addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        [_eaGlView stopAnimation];
    }];
    _willEnterForegroundObserver = [nc addObserverForName:UIApplicationWillEnterForegroundNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        [_eaGlView startAnimation];
    }];
}

- (void)dealloc
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    if (_didEnterBackgroundObserver) {
        [nc removeObserver:_didEnterBackgroundObserver];
    }
    if (_willEnterForegroundObserver) {
        [nc removeObserver:_willEnterForegroundObserver];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.eaGlView startAnimation];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.eaGlView stopAnimation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (EAGLView *)eaGlView
{
    return (EAGLView *)(self.view);
}

@end
