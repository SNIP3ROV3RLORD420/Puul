//
//  PUStartViewController.m
//  Puul
//
//  Created by Dylan Humphrey on 3/23/15.
//  Copyright (c) 2015 Dylan Humphrey. All rights reserved.
//

#import "PUStartViewController.h"
#import "PULoginViewController.h"
#import "PUSignUpViewController.h"

@interface PUStartViewController (){
    UIButton *loginButton;
    UIButton *signUpButton;
    UILabel *titleLabel;
}

@end

@implementation PUStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    //allocating and initializing the title label
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, 100)];
    titleLabel.font = [UIFont boldSystemFontOfSize:50];
    titleLabel.text = @"Puul";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    
    [self.view addSubview:titleLabel];
    
    //allocating and initializing the sign up button, then adding it to the view
    signUpButton = [[UIButton alloc]initWithFrame:CGRectMake(10, self.view.bounds.size.height - 110, self.view.bounds.size.width - 20, 45)];
    [signUpButton setTitle:@"Register with HW Email" forState:UIControlStateNormal];
    [signUpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    signUpButton.layer.cornerRadius = 4.0;
    signUpButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [signUpButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:signUpButton];
    
    //allocating and initializing the sign in button, then adding it to the view
    loginButton = [[UIButton alloc]initWithFrame:CGRectMake(10, self.view.bounds.size.height - 55, self.view.bounds.size.width - 20, 45)];
    [loginButton setTitle:@"Log In" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginButton.layer.cornerRadius = 4.0;
    loginButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [loginButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:loginButton];
}

#pragma mark - Button Methods

- (void)buttonPressed:(id)sender{
    if (sender == loginButton) {
        PULoginViewController *l = [[PULoginViewController alloc]init];
        [self.navigationController pushViewController:l animated:YES];
    }
    else{
        PUSignUpViewController *p = [[PUSignUpViewController alloc]init];
        [self.navigationController pushViewController:p animated:YES];
    }
}

@end
