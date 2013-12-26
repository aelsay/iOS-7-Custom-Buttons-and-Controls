//
//  AEPageControl.m
//  AEButton
//
//  Created by Ali ElSayed on 9/22/13.
//  Copyright (c) 2013 Aperture Mobile. All rights reserved.
//

#import "AEPageControl.h"

@implementation AEPageControl

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
	_strokeWidth = 2;
	_gapWidth = 4;
	_diameter = 10;
    
    _color = [UIColor grayColor];
    _selectedColor = [UIColor whiteColor];
    
	//UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
    //                                                                                       action:@selector(onTapped:)];
	//[self addGestureRecognizer:tapGestureRecognizer];
}
/*
- (void)onTapped:(UITapGestureRecognizer*)gesture
{
    CGPoint touchPoint = [gesture locationInView:[gesture view]];
    if (touchPoint.x < self.frame.size.width / 2)
    {
        // move left
        if (self.currentPage > 0)
        {
            if (touchPoint.x <= 22)
            {
                self.currentPage = 0;
            }
            else
            {
                self.currentPage -= 1;
            }
        }
        
    }
    else
    {
        // move right
        if (self.currentPage < self.numberOfPages - 1)
        {
            if (touchPoint.x >= (CGRectGetWidth(self.bounds) - 22))
            {
                self.currentPage = self.numberOfPages - 1;
            }
            else
            {
                self.currentPage += 1;
            }
        }
    }
    [self setNeedsDisplay];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}*/




- (void)drawRect:(CGRect)rect
{
    if (self.hidesForSinglePage && self.numberOfPages == 1)
	{
		return;
	}
	NSInteger gap = self.gapWidth;
    CGFloat diameter = self.diameter - 2 * self.strokeWidth;
	
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
			if (diameter < 2.00001)
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
