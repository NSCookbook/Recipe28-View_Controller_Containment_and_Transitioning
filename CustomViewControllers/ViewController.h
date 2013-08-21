//
//  ViewController.h
//  CustomViewControllers
//
//  Copyright (c) 2013 NSCookbook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UISegmentedControl *transitionStyle;
@property (strong, nonatomic) IBOutlet UISlider *velocity;
@property (strong, nonatomic) IBOutlet UISlider *alpha;
@property (strong, nonatomic) IBOutlet UISlider *scale;
@property (strong, nonatomic) IBOutlet UISlider *animationDuration;

@end
