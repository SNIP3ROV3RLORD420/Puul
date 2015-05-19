//
//  PULoginViewController.m
//  Pool
//
//  Created by Dylan Humphrey on 3/17/15.
//  Copyright (c) 2015 Dylan Humphrey. All rights reserved.
//

#import <Parse/Parse.h>
#import "AppDelegate.h"
#import "PULoginViewController.h"
#import "UIColor+PUColors.h"
#import "PUHomeViewController.h"
#import "PUProfileViewController.h"
#import "PUSettingsViewController.h"

@interface PULoginViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>{
    UITextField *usernameField;
    UITextField *passwordField;
    
    UITableView *tableView;
    
    UIActivityIndicatorView *indicatorView;
    
    BOOL username;
    BOOL password;
}

@end

@implementation PULoginViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Login";
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Do any additional setup after loading the view.
    tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 150) style:UITableViewStyleGrouped];
    tableView.contentInset = UIEdgeInsetsMake(-34, 0, 0, 0);
    tableView.separatorColor = [UIColor puulRedColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [usernameField becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - Button Methods

- (void)login{
    [PFUser logOut];
    [PFUser logInWithUsernameInBackground:usernameField.text password:passwordField.text block:^(PFUser *user, NSError *error) {
        if (!error) {
            //user logged in
            [self loggedIn];
        }
        else{
            //handle error
        }
    }];
}

#pragma mark - TableViewProtocols

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, cell.frame.size.height)];

    if (indexPath.row == 0) {
        usernameField = [[UITextField alloc]initWithFrame:cell.frame];
        usernameField.placeholder = @"Username";
        usernameField.leftView = paddingView;
        usernameField.leftViewMode = UITextFieldViewModeAlways;
        usernameField.delegate = self;
        [cell.contentView addSubview:usernameField];
    }
    if (indexPath.row == 1) {
        passwordField = [[UITextField alloc]initWithFrame:cell.frame];
        passwordField.placeholder = @"Password";
        passwordField.leftView = paddingView;
        passwordField.leftViewMode = UITextFieldViewModeAlways;
        passwordField.secureTextEntry = YES;
        passwordField.delegate = self;
        [cell.contentView addSubview:passwordField];
    }
    if (indexPath.row == 2) {
        if (username && password) {
            cell.contentView.backgroundColor = [UIColor greenColor];
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
        else{
            cell.contentView.backgroundColor = [UIColor puulRedColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
        label.text = @"Login";
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:label];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 2 && username && password) {
        NSLog(@"logging in");
        [self login];
    }
}

#pragma mark - Text Field Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == usernameField) {
        [passwordField becomeFirstResponder];
    }
    if (textField == passwordField) {
        [self login];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (usernameField.text.length > 0) {
        username = YES;
    }
    else{
        username = NO;
    }
    if (passwordField.text.length > 0){
        password = YES;
    }
    else{
        password = NO;
    }
    
    if (username && password) {
        [self reloadLastRow];
        if (passwordField.text.length < 2) {
            [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
        };

    }
    
    return YES;
}

#pragma mark - Helper methods

- (void)loggedIn{
    PUHomeViewController *home = [[PUHomeViewController alloc]init];
    UINavigationController *controller = [[UINavigationController alloc]initWithRootViewController:home];
    controller.navigationBar.tintColor = [UIColor whiteColor];
    controller.navigationBar.barTintColor = [UIColor puulRedColor];
    controller.navigationBar.translucent = NO;
    controller.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Feed" image:[UIImage imageNamed:@"feed"] tag:0];

    PUSettingsViewController *settings = [[PUSettingsViewController alloc]init];
    UINavigationController *controller1 = [[UINavigationController alloc]initWithRootViewController:settings];
    controller1.navigationBar.tintColor = [UIColor whiteColor];
    controller1.navigationBar.barTintColor = [UIColor puulRedColor];
    controller1.navigationBar.translucent = NO;
    controller1.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Settings" image:[UIImage imageNamed:@"settings"] tag:0];

    PUProfileViewController *profile = [[PUProfileViewController alloc]init];
    UINavigationController *controller2 = [[UINavigationController alloc]initWithRootViewController:profile];
    controller2.navigationBar.tintColor = [UIColor whiteColor];
    controller2.navigationBar.barTintColor = [UIColor puulRedColor];
    controller2.navigationBar.translucent = NO;
    controller2.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Profile" image:[UIImage imageNamed:@"profile"] tag:0];
    
    
    
    UITabBarController *tab = [[UITabBarController alloc]init];
    [tab setViewControllers:@[controller, controller2, controller1]];

    
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    delegate.window.rootViewController = tab;
}

- (void)reloadLastRow{
    [tableView beginUpdates];
    [tableView endUpdates];
}

@end
