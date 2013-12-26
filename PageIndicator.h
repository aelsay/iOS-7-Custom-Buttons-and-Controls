//
//  PageIndicator.h
//  AEButton
//
//  Created by Ali ElSayed on 9/24/13.
//  Copyright (c) 2013 Aperture Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageIndicator : UIControl

@property (nonatomic, assign) NSInteger diameter;
@property (nonatomic, assign) NSInteger gapWidth;
@property (nonatomic, assign) NSInteger strokeWidth;

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger numberOfPages;
@property (nonatomic, assign) BOOL hidesForSinglePage;

@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) UIColor *selectedColor;

@end
