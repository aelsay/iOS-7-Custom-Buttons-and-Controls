//
//  ViewController.h
//  AEButton
//
//  Created by Ali ElSayed on 9/16/13.
//  Copyright (c) 2013 Aperture Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AEButton.h"
#import "OptionsView.h"
#import "RoundButton.h"
#import "AESlideToDoSomething.h"
#import "UIImage+ImageEffects.h"

#import "AEPageControl.h"

@interface ViewController : UIViewController

@property (strong, nonatomic) AEButton *theButton;
@property (strong, nonatomic) OptionsView *optionsView;
@property (strong, nonatomic) RoundButton *roundButton;
@property (strong, nonatomic) AESlideToDoSomething *slideToDoSomething;

@end
