//
//  RoundButton.m
//  AEButton
//
//  Created by Ali ElSayed on 9/17/13.
//  Copyright (c) 2013 Aperture Mobile. All rights reserved.
//

#import "RoundButton.h"

@implementation RoundButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _color = [UIColor orangeColor];
        _highlightedColor = [UIColor purpleColor];
        [self initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withColors: (NSArray*)colors
{
    self = [super initWithFrame:frame];
    if (self) {
        NSMutableArray *colorsArray = [[NSMutableArray alloc] init];
        for (NSUInteger i = 0; i < 2; ++i) { // Number of colors that can be set are two
            if (i < colors.count) // If there are colors (or anything) in the array
            {
                if ([[colors objectAtIndex:i] isKindOfClass:[UIColor class]]) { // Make sure they are a UIColor
                    [colorsArray addObject:[colors objectAtIndex:i]]; // Add it to array
                }
            }
            else // Otherwise, use a default color
            {
                (i % 2) ? [colorsArray addObject:[UIColor orangeColor]] : [colorsArray addObject:[UIColor purpleColor]];
            }
        }
        // The new colorsArray should have three colors now. Set class vars now...
        if (colorsArray.count > 3) {
            _color = [colorsArray objectAtIndex:0];
            _highlightedColor = [colorsArray objectAtIndex:1];
        }
        [self initialize];
    }
    return self;
}

- (void) initialize
{
    self.backgroundColor = _color;
    self.layer.cornerRadius = 6.0;
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
}

- (void) setHighlighted:(BOOL)highlighted
{
    [super setHighlighted: highlighted];
    if (highlighted) {
        self.backgroundColor = _highlightedColor;
    } else {
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options:UIViewAnimationOptionAllowUserInteraction |
                                    UIViewAnimationOptionCurveEaseOut
                         animations:^{self.backgroundColor = _color;}
                         completion:^(BOOL finished) {}
         ];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
