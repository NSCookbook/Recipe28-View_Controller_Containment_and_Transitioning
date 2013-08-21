//
//  ViewController.m
//  CustomViewControllers
//
//  Copyright (c) 2013 NSCookbook. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ViewController.h"

typedef NS_ENUM(NSInteger, ViewControllerTransition) {
    ViewControllerTransitionSlideFromTop   = 0,
    ViewControllerTransitionSlideFromLeft,
    ViewControllerTransitionSlideFromBottom,
    ViewControllerTransitionSlideFromRight,
    ViewControllerTransitionRotateFromRight
};

// https://gist.github.com/kylefox/1689973
UIColor* color()
{
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

@interface ViewController ()

@property (nonatomic, weak) UIViewController *currentChildViewController;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Add an initial contained viewController
    UIViewController *viewController = [self nextViewController];
    
    // Contain the view controller
    [self addChildViewController:viewController];
    [self.view addSubview:viewController.view];
    [viewController didMoveToParentViewController:self];
    self.currentChildViewController = viewController;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.currentChildViewController.view.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.currentChildViewController.view.bounds cornerRadius:8].CGPath;
}

#pragma mark - Private

- (CGAffineTransform)startingTransformForViewControllerTransition:(ViewControllerTransition)transition
{
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat height = CGRectGetHeight(self.view.bounds);
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (transition)
    {
        case ViewControllerTransitionSlideFromTop:
            transform = CGAffineTransformMakeTranslation(0, -height);
            break;
        case ViewControllerTransitionSlideFromLeft:
            transform = CGAffineTransformMakeTranslation(-width, 0);
            break;
        case ViewControllerTransitionSlideFromRight:
            transform = CGAffineTransformMakeTranslation(width, 0);
            break;
        case ViewControllerTransitionSlideFromBottom:
            transform = CGAffineTransformMakeTranslation(0, height);
            break;
        case ViewControllerTransitionRotateFromRight:
            transform = CGAffineTransformMakeTranslation(width, 0);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        default:
            break;
    }
    
    return transform;
}

- (void)transitionToNextViewController
{
    UIViewController *nextViewController = [self nextViewController];
    
    // Containment
    [self addChildViewController:nextViewController];
    [self.currentChildViewController willMoveToParentViewController:nil];
    
    nextViewController.view.transform = [self startingTransformForViewControllerTransition:self.transitionStyle.selectedSegmentIndex];
    
    [self transitionFromViewController:self.currentChildViewController toViewController:nextViewController duration:_animationDuration.value options:0 animations:^{
        self.currentChildViewController.view.alpha = _alpha.value;
        CGAffineTransform transform = CGAffineTransformMakeTranslation(-nextViewController.view.transform.tx * _velocity.value, -nextViewController.view.transform.ty * _velocity.value);
        transform = CGAffineTransformRotate(transform, acosf(nextViewController.view.transform.a));
        self.currentChildViewController.view.transform = CGAffineTransformScale(transform, _scale.value, _scale.value);
        
        nextViewController.view.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [nextViewController didMoveToParentViewController:self];
        [self.currentChildViewController removeFromParentViewController];
        self.currentChildViewController = nextViewController;
    }];
}

- (UIViewController *)nextViewController
{
    UIViewController *viewController = [UIViewController new];
    viewController.view.frame = CGRectInset(self.view.bounds, 0, 200);
    UILabel *label = [[UILabel alloc] initWithFrame:viewController.view.bounds];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.text = @"Contained View Controller's View\n\nClick To Transition";
    [viewController.view addSubview:label];
    
    viewController.view.backgroundColor = color();
    viewController.view.layer.borderWidth = 6;
    viewController.view.layer.cornerRadius = 8;
    viewController.view.layer.borderColor = color().CGColor;
    viewController.view.layer.shadowColor = [UIColor blackColor].CGColor;
    viewController.view.layer.shadowOffset = CGSizeZero;
    viewController.view.layer.shadowOpacity = 0.5;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [viewController.view addGestureRecognizer:tap];
    
    return viewController;
}

- (void)tap:(UIGestureRecognizer *)gr
{
    if (gr.state == UIGestureRecognizerStateEnded)
        [self transitionToNextViewController];
}

@end
