//
//  AESlideToDoSomething.h
//  AEButton
//
//  Created by Ali ElSayed on 9/18/13.
//  Copyright (c) 2013 Aperture Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AESlideToDoSomething : UIControl

- (id) initWithFrame:(CGRect)frame withColor: (UIColor*) color;

- (void) animateTitleLabel;

- (BOOL) slidToDoSomething;

- (void) reset;

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) UIImageView *imageView;

@property (strong, nonatomic) UIColor *color;

@end
