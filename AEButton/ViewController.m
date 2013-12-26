//
//  ViewController.m
//  AEButton
//
//  Created by Ali ElSayed on 9/16/13.
//  Copyright (c) 2013 Aperture Mobile. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
	// Do any additional setup after loading the view, typically from a nib.
    _theButton = [[AEButton alloc] initWithFrame:CGRectMake(15, [UIScreen mainScreen].bounds.size.height - 60 - 65, [UIScreen mainScreen].bounds.size.width - 30, 65)];
    _theButton.color = [UIColor grayColor];
    _theButton.titleLabel.text = @"Cancel";
    _theButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:24.0];
    _theButton.titleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:_theButton];
    
    _roundButton = [[RoundButton alloc] initWithFrame:CGRectMake(15, [UIScreen mainScreen].bounds.size.height - 200 - 65, [UIScreen mainScreen].bounds.size.width - 30, 65)];
    _roundButton.titleLabel.text = @"Call";
    _roundButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:24.0];
    _roundButton.titleLabel.textColor = [UIColor whiteColor];
    [_roundButton addTarget:self action:@selector(pressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_roundButton];
    
    _slideToDoSomething = [[AESlideToDoSomething alloc] initWithFrame:CGRectMake(16, 38 + 66, [UIScreen mainScreen].bounds.size.width - 32, 66)];
    _slideToDoSomething.titleLabel.text = @"slide to power off";
    _slideToDoSomething.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:24.0];
    _slideToDoSomething.titleLabel.textColor = [UIColor whiteColor];
    [_slideToDoSomething animateTitleLabel];
    [self.view addSubview:_slideToDoSomething];
    
    _optionsView = [[OptionsView alloc] initWithFrame:CGRectMake(16, 200, 160 - 16, 66)];
    _optionsView.titleLabel.text = @"Snooze";
    [_optionsView setOptions:@[@"Off", @"5 mins", @"10 mins", @"15 mins", @"20 mins", @"25 mins", @"30 mins"]];
    _optionsView.pageNumber = -3;
    [self.view addSubview:_optionsView];
}

- (void) pressed
{
    NSLog(@"Button pressed!");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle) preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

/*
- (void) tranparentBackground
{
    //First make the view transparent (self.view is actually a collection view)
    self.view.backgroundColor = [UIColor clearColor];
    
    //Create screenshot
    UIGraphicsBeginImageContextWithOptions(self.view.frame.size, NULL, 0); //Not sure about "NULL". This line is from a wwdc video
    [self.view drawViewHierarchyInRect:self.view.frame afterScreenUpdates:NO];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    //Blur screenshot and make it dark. Try other "apply.." effects
    UIImage *darkImage = [newImage applyDarkEffect];
    
    //Finally set the blurred image as the new background
    // self.contentView.backgroundView = [[UIImageView alloc] initWithImage:darkImage];
    //UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:darkImage];
    //[self.view addSubview:backgroundImageView];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:darkImage];
}*/

@end
