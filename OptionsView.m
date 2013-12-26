//
//  OptionsView.m
//  AEButton
//
//  Created by Ali ElSayed on 9/20/13.
//  Copyright (c) 2013 Aperture Mobile. All rights reserved.
//

#import "OptionsView.h"

@implementation OptionsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _font = [UIFont fontWithName:@"HelveticaNeue" size:20];
        _color = [UIColor grayColor];
        _textColor = [UIColor whiteColor];
        [self initialize];
    }
    return self;
}

- (void) initialize
{
    self.backgroundColor = _color;
    self.layer.cornerRadius = 6.0;
    self.clipsToBounds = YES;
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    scrollView.backgroundColor = _color;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.alpha = 0.0;
    [self addSubview:scrollView];
    
    CGFloat pageIndicatorHeight = self.frame.size.height / 4.0; // PageIndicator's height is 1/4th the parent view
    _pageIndicator = [[PageIndicator alloc] initWithFrame:CGRectMake(0,
                                                                     self.frame.size.height - pageIndicatorHeight,
                                                                     self.frame.size.width,
                                                                     pageIndicatorHeight)];
    _pageIndicator.color = self.superview.backgroundColor;
    _pageIndicator.selectedColor = [UIColor whiteColor];
    _pageIndicator.numberOfPages = 0;
    _pageIndicator.alpha = 0.0;
    [self addSubview:_pageIndicator];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.alpha = 1.0;
    _titleLabel.font = _font;
    _titleLabel.textColor = _textColor;
    [self addSubview:_titleLabel];
    
    titleLabelIsCoveringOptions = YES;
    
    _pageNumber = 0;
    
    timer = [[NSTimer alloc] init];
    
    labels = [[NSMutableArray alloc] init];
    
    panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                    action:@selector(panGestureHandler:)];
    [self addGestureRecognizer:panGestureRecognizer];
    
    tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                   action:@selector(tapGestureHandler:)];
    [self addGestureRecognizer:tapGestureRecognizer];
}

- (void) tapGestureHandler: (UITapGestureRecognizer*) tapGesture
{
    CGPoint location = [tapGestureRecognizer locationInView:_titleLabel];
    if (tapGesture.state == UIGestureRecognizerStateEnded)
    {
        if (titleLabelIsCoveringOptions) // If the title label is covering the options view (scroll view)
        {
            CGFloat xPos;
            if (location.x < self.frame.size.width/2.0) { // Which side of the view was the tap on (left or right)
                xPos = self.frame.size.width;
            } else {
                xPos = -self.frame.size.width;
            }
            // Move title label away and reveal options view
            [self animateTitleLabelAwayWithFrame:CGRectMake(xPos, 0,
                                                        _titleLabel.frame.size.width, _titleLabel.frame.size.height)];
        }
        else // If the options view (scroll view) is visible
        {
            // Compute next option offset in scroll view
            CGFloat offset = scrollView.contentOffset.x + scrollView.frame.size.width;
            if (offset < scrollView.contentSize.width); // If it's within the content size, then we're good.
            else // Otherwise, we should go back to first option (offset = 0)
                offset = 0;
            [scrollView scrollRectToVisible:CGRectMake(offset,
                                                       0,
                                                       scrollView.frame.size.width,
                                                       scrollView.frame.size.height)
                                   animated:YES];
        }
    }
}

- (void) panGestureHandler: (UIPanGestureRecognizer*) panGesture
{
    CGPoint translation = [panGestureRecognizer translationInView:_titleLabel];
    _titleLabel.frame = CGRectMake(_titleLabel.frame.origin.x + translation.x,
                                   _titleLabel.frame.origin.y,
                                   _titleLabel.frame.size.width,
                                   _titleLabel.frame.size.height);
    [panGestureRecognizer setTranslation:CGPointMake(0, 0) inView:_titleLabel];
    CGFloat alpha = fabsf(_titleLabel.frame.origin.x * 1.5 /self.bounds.size.width); // Compute alpha
    _titleLabel.alpha = 1 - alpha; // Fade out title label
    scrollView.alpha = alpha; // Fade in options view
    if (panGesture.state == UIGestureRecognizerStateEnded) // If pan ended
    {
        if (fabsf(_titleLabel.frame.origin.x) > self.bounds.size.width/4.0) { // If title label has been panned enough
            CGFloat xPos;
            if (_titleLabel.frame.origin.x > 0) // Figure out which direction label has been panned (left or right)
                xPos = self.frame.size.width;
            else
                xPos = -self.frame.size.width;
            // Animate it away to that side
            [self animateTitleLabelAwayWithFrame:CGRectMake(xPos, 0,
                                                        _titleLabel.frame.size.width, _titleLabel.frame.size.height)];
        }
        else // If the label hasn't been panned enough
        {
            // Animate it back to default position
            [self resetTitleLabelPosition];
        }
    }
}

- (void) setOptions:(NSArray *)options
{
    _options = options;
    scrollView.contentSize = CGSizeMake(self.frame.size.width * options.count, self.frame.size.height);
    for (NSUInteger i = 0; i < options.count; ++i) // Add every option in array to scroll view as a label
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = _textColor;
        label.font = _font;
        if ([[_options objectAtIndex:i] isKindOfClass:[NSString class]]) {
            label.text = [_options objectAtIndex:i];
        }
        else
        {
            label.text = @"Invalid Format";
        }
        [scrollView addSubview:label];
        [labels addObject:label]; // Add label to labels array
    }
    _pageIndicator.numberOfPages = options.count;
}

- (void) setPageNumber:(NSInteger)pageNumber
{
    
    CGFloat offset = scrollView.frame.size.width * pageNumber;
    if (offset < scrollView.contentSize.width); // If it's within the content size, then we're good.
    else
    {
        offset = 0;
        pageNumber = 0;
    }
    [scrollView scrollRectToVisible:CGRectMake(offset,
                                               0,
                                               scrollView.frame.size.width,
                                               scrollView.frame.size.height)
                           animated:YES];
    _pageNumber = pageNumber;
}

- (void) setColor:(UIColor *)color
{
    _color = color;
    self.backgroundColor = _color;
    scrollView.backgroundColor = _color;
}

- (void) resetTimer // When called it sets a timer to move/animate the title label back to its original position
{
    [timer invalidate];
    timer = [NSTimer scheduledTimerWithTimeInterval:2.5
                                             target:self
                                           selector:@selector(resetTitleLabelPosition)
                                           userInfo:nil
                                            repeats:NO];
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)view
{
    _pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width; // Update page number variable
    _pageIndicator.currentPage = _pageNumber; // Update page indicator
    [self resetTimer]; // Reset timer (which sets a timer for title label to animate back to original position)
}

- (void) scrollViewDidEndScrollingAnimation:(UIScrollView *)view
{
    _pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width;
    _pageIndicator.currentPage = _pageNumber;
    [self resetTimer];
}

- (void) resetTitleLabelPosition
{
    [UIView animateWithDuration:0.35
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _titleLabel.frame = CGRectMake(0, 0, _titleLabel.frame.size.width, _titleLabel.frame.size.height);
                         _titleLabel.alpha = 1.0;
                         scrollView.alpha = 0.0;
                         _pageIndicator.alpha = 0.0;
                     }
                     completion:^(BOOL finished) {
                         titleLabelIsCoveringOptions = YES;
                     }
     ];
}

- (void) animateTitleLabelAwayWithFrame: (CGRect) frame
{
    [UIView animateWithDuration:0.35
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _titleLabel.frame = frame;
                         _titleLabel.alpha = 0.0;
                         scrollView.alpha = 1.0;
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.2
                                               delay:0
                                             options:UIViewAnimationOptionAllowUserInteraction |
                                                     UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              _pageIndicator.alpha = 1.0;
                                          }
                                          completion:^(BOOL finished){ }];
                         [self resetTimer];
                         titleLabelIsCoveringOptions = NO;
                     }
     ];
}


- (void) setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    _titleLabel.textColor = textColor;
    for(NSInteger i = 0; i < labels.count; ++i)
    {
        if (labels.count > 0)
        {
            if ([[labels objectAtIndex:i] isKindOfClass:[UILabel class]]) {
                UILabel *label = [labels objectAtIndex:i];
                label.textColor = textColor;
            }
        }
    }
}

@end
