//
//  OptionsView.h
//  AEButton
//
//  Created by Ali ElSayed on 9/20/13.
//  Copyright (c) 2013 Aperture Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageIndicator.h"

@interface OptionsView : UIControl <UIScrollViewDelegate>
{
    UIScrollView *scrollView;
    NSTimer *timer;
    UIPanGestureRecognizer *panGestureRecognizer;
    UITapGestureRecognizer *tapGestureRecognizer;
    BOOL titleLabelIsCoveringOptions;
    NSMutableArray *labels;
}

@property (strong, nonatomic) PageIndicator *pageIndicator;

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) UIColor *color;

@property (strong, nonatomic) UIColor *textColor;

@property (strong, nonatomic) UIFont *font;

@property (strong, nonatomic) NSArray *options;

@property (assign, nonatomic) NSInteger pageNumber;

@end
