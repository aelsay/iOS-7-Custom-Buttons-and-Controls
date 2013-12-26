//
//  PageIndicator.m
//  AEButton
//
//  Created by Ali ElSayed on 9/24/13.
//  Copyright (c) 2013 Aperture Mobile. All rights reserved.
//

#import "PageIndicator.h"

@implementation PageIndicator

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initialize];
    }
    return self;
}

- (void) initialize
{
	self.backgroundColor = [UIColor clearColor];
	self.userInteractionEnabled = NO;
    
    _strokeWidth = 2;
	_gapWidth = 4;
	_diameter = 10;
    
    _color = [UIColor grayColor];
    _selectedColor = [UIColor whiteColor];
}

- (void)drawRect:(CGRect)rect
{
    if (self.hidesForSinglePage && self.numberOfPages == 1)
	{
		return;
	}
	NSInteger gap = self.gapWidth;
    NSInteger diameter = self.diameter - 2 * self.strokeWidth;
	
	NSInteger totalWidth = self.numberOfPages * diameter + (self.numberOfPages - 1) * gap;
	
	if (totalWidth > self.frame.size.width) // If totalWidth exceeds the view's width, adjust dots gap/size
	{
		while (totalWidth > self.frame.size.width)
		{
			diameter -= 2;
			gap = diameter + 2;
			while (totalWidth > self.frame.size.width)
			{
				gap -= 1;
				totalWidth = self.numberOfPages * diameter + (self.numberOfPages - 1) * gap;
				if (gap == 2)
					break;
			}
			if (diameter == 2)
				break;
		}
	}
	CGContextRef context = UIGraphicsGetCurrentContext();
	for (NSInteger i = 0; i < self.numberOfPages; ++i)
	{
		NSInteger x = (self.frame.size.width - totalWidth) / 2 + i * (diameter + gap);
        if (i == self.currentPage)
        {
            CGContextSetFillColorWithColor(context, [_selectedColor CGColor]);
        }
        else
        {
            CGContextSetFillColorWithColor(context, [_color CGColor]);
        }
        CGContextFillEllipseInRect(context, CGRectMake(x, (self.frame.size.height - diameter) / 2, diameter, diameter));
    }
}

- (void) setCurrentPage:(NSInteger)currentPage
{
    _currentPage = currentPage;
    [self setNeedsDisplay];
}

- (void) setNumberOfPages:(NSInteger)numberOfPages
{
    _numberOfPages = numberOfPages;
    [self setNeedsDisplay];
}

- (void) setColor:(UIColor *)color
{
    _color = color;
    [self setNeedsDisplay];
}

- (void) setSelectedColor:(UIColor *)selectedColor
{
    _selectedColor = selectedColor;
    [self setNeedsDisplay];
}

@end
