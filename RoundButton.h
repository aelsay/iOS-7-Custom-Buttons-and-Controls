//
//  RoundButton.h
//  AEButton
//
//  Created by Ali ElSayed on 9/17/13.
//  Copyright (c) 2013 Aperture Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface RoundButton : UIControl

- (id)initWithFrame:(CGRect)frame withColors: (NSArray*)colors;

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) UIColor *color;
@property (strong, nonatomic) UIColor *highlightedColor;

@end
