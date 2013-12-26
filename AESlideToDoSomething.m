//
//  AESlideToDoSomething.m
//  AEButton
//
//  Created by Ali ElSayed on 9/18/13.
//  Copyright (c) 2013 Aperture Mobile. All rights reserved.
//

#import "AESlideToDoSomething.h"

@implementation AESlideToDoSomething
{
    UIView *slidingView;
    UIPanGestureRecognizer *panGestureRecognizer;
    BOOL slidToDoSomething;
}

- (id) init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(16, 38, 320 - 32, 66); // Right where the real slide to power off will end up
        _color = [UIColor colorWithRed:220/255.0 green:86/255.0 blue:80/255.0 alpha:1.0];
        [self initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _color = [UIColor colorWithRed:220/255.0 green:86/255.0 blue:80/255.0 alpha:1.0];
        [self initialize];
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame withColor: (UIColor*) color
{
    self = [super initWithFrame:frame];
    if (self) {
        _color = color;
        [self initialize];
    }
    return self;
}

- (void) initialize
{
    self.backgroundColor = _color;
    self.layer.cornerRadius = 6.0;
    self.clipsToBounds = YES;
    // self.alpha = 0.75;
    
    slidingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    //slidingView.backgroundColor = [UIColor blueColor];
    
    [self addSubview:slidingView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(39, 0, self.frame.size.width - 50, self.frame.size.height)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [slidingView addSubview:_titleLabel];
    
    _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
    NSLog(@"x: %f y: %f w: %f h: %f", _imageView.frame.origin.x, _imageView.frame.origin.y, _imageView.frame.size.width, _imageView.frame.size.height);
    _imageView.frame = CGRectMake(15, 20, _imageView.frame.size.width, _imageView.frame.size.height);
    [slidingView addSubview:_imageView];
    
    panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                   action:@selector(panGestureHandler:)];
    [slidingView addGestureRecognizer:panGestureRecognizer];
}

- (void) animateTitleLabel
{
    CAGradientLayer *gradientMask = [CAGradientLayer layer];
    gradientMask.frame = _titleLabel.bounds;
    CGFloat gradientSize = 65 / _titleLabel.frame.size.width;
    UIColor *gradient = [UIColor colorWithWhite:1.0f alpha:0.3];
    UIView *superview = _titleLabel.superview;
    NSArray *endLocations = @[[NSNumber numberWithFloat:0.0f], [NSNumber numberWithFloat:(gradientSize / 2)], [NSNumber numberWithFloat:gradientSize]];
    NSArray *startLocations = @[[NSNumber numberWithFloat:(1.0f - gradientSize)], [NSNumber numberWithFloat:(1.0f -(gradientSize / 2))], [NSNumber numberWithFloat:1.0f]];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"locations"];
    
    gradientMask.colors = @[(id)gradient.CGColor, (id)[UIColor whiteColor].CGColor, (id)gradient.CGColor];
    gradientMask.locations = startLocations;
    gradientMask.endPoint = CGPointMake(0 - (gradientSize * 2), .5);
    gradientMask.startPoint = CGPointMake(1 + gradientSize, .5);
    
    [_titleLabel removeFromSuperview];
    _titleLabel.layer.mask = gradientMask;
    [superview addSubview:_titleLabel];
    animation.delegate = self;
    animation.fromValue = startLocations;
    animation.toValue = endLocations;
    animation.repeatCount = FLT_MAX;
    animation.duration  = 1.6f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    [gradientMask addAnimation:animation forKey:@"animateGradient"];
}

- (void) setSubviewsAlpha: (CGFloat) alpha
{
    NSArray *subviews = self.superview.subviews;
    for (int i = 0; i < subviews.count; ++i)
    {
        if (![[subviews objectAtIndex:i] isEqual:self])
        {
            [[subviews objectAtIndex:i] setAlpha: alpha];
        }
    }
}

-(void)pauseLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}

-(void)resumeLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
}

- (void) panGestureHandler: (UIPanGestureRecognizer*) panGesture
{
    CGPoint translation = [panGestureRecognizer translationInView:slidingView];
    if (slidingView.frame.origin.x + translation.x > -0.0001) {
        slidingView.frame = CGRectMake(slidingView.frame.origin.x + translation.x,
                                       slidingView.frame.origin.y,
                                       slidingView.frame.size.width,
                                       slidingView.frame.size.height);
    }
    [panGestureRecognizer setTranslation:CGPointMake(0, 0) inView:slidingView];
    // Calculate subviews alpha
    CGFloat alpha = 1.0 - slidingView.frame.origin.x * 1.5 /self.bounds.size.width;
    [self setSubviewsAlpha:alpha];
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        [self pauseLayer:_titleLabel.layer];
    }
    else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        if (slidingView.frame.origin.x < 0.75 * slidingView.frame.size.width) {
            [UIView animateWithDuration:0.15
                                  delay:0.0
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 slidingView.frame = CGRectMake(0,
                                                                0,
                                                                slidingView.frame.size.width,
                                                                slidingView.frame.size.height);
                                 [self setSubviewsAlpha:1.0];
                             }
                             completion:^(BOOL finished){ [self resumeLayer:_titleLabel.layer];  }];
        }
        else
        {
            slidToDoSomething = YES;
        }
    }
}

- (BOOL) slidToDoSomething
{
    return slidToDoSomething;
}

- (void) reset
{
    slidingView.frame = CGRectMake(0, 0, slidingView.frame.size.width, slidingView.frame.size.height);
    slidToDoSomething = NO;
}

- (void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self animateTitleLabel];
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
