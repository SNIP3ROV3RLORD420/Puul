//
//  PUSignUpViewController.m
//  Puul
//
//  Created by Dylan Humphrey on 3/23/15.
//  Copyright (c) 2015 Dylan Humphrey. All rights reserved.
//

#import "PUSignUpViewController.h"
#import <Parse/Parse.h>
#import "UIColor+PUColors.h"
#import "PUUtility.h"

@interface PUSignUpViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>{
    UITableView *sTableView;
    
    UITextField *usernameTextField;
    UITextField *passwordTextField;
    UITextField *emailTextField;
    UITextField *nameTextField;
}

@end

@implementation PUSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Sign Up";
    self.view.backgroundColor = [UIColor whiteColor];
    
    sTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    sTableView.contentInset = UIEdgeInsetsMake(-34, 0, 0, 0);
    sTableView.separatorColor = [UIColor puulRedColor];
    sTableView.delegate = self;
    sTableView.dataSource = self;
    [self.view addSubview:sTableView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [usernameTextField becomeFirstResponder];
}

#pragma mark - UITableView Protocols

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
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
        if (!usernameTextField) {
            usernameTextField = [[UITextField alloc]initWithFrame:cell.frame];
            usernameTextField.placeholder = @"Username";
            usernameTextField.leftView = paddingView;
            usernameTextField.leftViewMode = UITextFieldViewModeAlways;
            usernameTextField.delegate = self;
            [cell.contentView addSubview:usernameTextField];
        }
    }
    if (indexPath.row == 1) {
        if (!passwordTextField) {
            passwordTextField = [[UITextField alloc]initWithFrame:cell.frame];
            passwordTextField.placeholder = @"HW Password";
            passwordTextField.leftView = paddingView;
            passwordTextField.leftViewMode = UITextFieldViewModeAlways;
            passwordTextField.delegate = self;
            [cell.contentView addSubview:passwordTextField];
        }
    }
    if (indexPath.row == 2) {
        if (!emailTextField) {
            emailTextField = [[UITextField alloc]initWithFrame:cell.frame];
            emailTextField.placeholder = @"HW Email";
            emailTextField.leftView = paddingView;
            emailTextField.leftViewMode = UITextFieldViewModeAlways;
            emailTextField.delegate = self;
            [cell.contentView addSubview:emailTextField];
        }
    }
    if (indexPath.row == 3) {
        if (!nameTextField) {
            nameTextField = [[UITextField alloc]initWithFrame:cell.frame];
            nameTextField.placeholder = @"First Last";
            nameTextField.leftView = paddingView;
            nameTextField.leftViewMode = UITextFieldViewModeAlways;
            nameTextField.delegate = self;
            [cell.contentView addSubview:nameTextField];
        }
    }
    if (indexPath.row == 4) {
        if ([self checkTextFields]) {
            cell.contentView.backgroundColor = [UIColor greenColor];
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
        else{
            cell.contentView.backgroundColor = [UIColor redColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        UILabel *label = [[UILabel alloc]initWithFrame:cell.frame];
        label.text = @"Sign Up";
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:label];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 4 && [self checkTextFields]) {
        //try to sign up the user
    }
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == usernameTextField) {
        [passwordTextField becomeFirstResponder];
    }
    if (textField == passwordTextField) {
        [emailTextField becomeFirstResponder];
    }
    if (textField == emailTextField) {
        [nameTextField becomeFirstResponder];
    }
    [self checkTextFields];
}

#pragma mark - Helper Methods

- (BOOL)checkTextFields{
    if ([self usernameGood] && [self emailGood] && [self passwordGood]) {
        [self reloadLastRow];
        return YES;
    }
    return NO;
}

- (BOOL)usernameGood{
    if (usernameTextField.text.length == 0) {
        return NO;
    }
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:usernameTextField.text];
    if ([query getFirstObject]) {
        usernameTextField.textColor = [UIColor redColor];
        return NO;
    }
    if ([PUUtility containsIllegalCharacters:usernameTextField.text]) {
        usernameTextField.textColor = [UIColor redColor];
        return NO;
    }
    usernameTextField.textColor = [UIColor blackColor];
    return YES;
}

- (BOOL)emailGood{
    if (emailTextField.text.length == 0) {
        return NO;
    }
    PFQuery *query = [PFUser query];
    [query whereKey:@"email" equalTo:emailTextField.text];
    if ([query getFirstObject]) {
        emailTextField.textColor = [UIColor redColor];
        return NO;
    }
    if ([emailTextField.text containsString:@"@"] && [emailTextField.text containsString:@"."]){
        NSArray *substrings = [emailTextField.text componentsSeparatedByString:@"@"];
        NSArray *substrings1 = [emailTextField.text componentsSeparatedByString:@"."];
        if ([substrings[0] isEqualToString:@""]) {
            emailTextField.textColor = [UIColor redColor];
            return NO;
        }
        if ([substrings1[1] isEqualToString:@""]) {
            emailTextField.textColor = [UIColor redColor];
            return NO;
        }
        if ([substrings[1] characterAtIndex:0] == '.'){
            emailTextField.textColor = [UIColor redColor];
            return NO;
        }
        emailTextField.textColor = [UIColor whiteColor];
        return YES;
    }
    else if ([emailTextField.text isEqualToString:@""]){
        emailTextField.textColor = [UIColor whiteColor];
        return YES;
    }
    else{
        emailTextField.textColor = [UIColor redColor];
        return NO;
    }
    return NO;
}

- (BOOL)passwordGood{
    NSString *password = passwordTextField.text;
    if (password.length == 0) {
        return NO;
    }
    int count = 0;
    for (int i = 0; i < 10; i++) {
        if ([password containsString:[NSString stringWithFormat:@"%i", i]]) {
            count++;
        }
    }
    if (password.length > 5 && count > 0) {
        passwordTextField.textColor = [UIColor whiteColor];
        return YES;
    }
    if (password.length <= 5) {
        passwordTextField.textColor = [UIColor redColor];
        return NO;
    }
    if (count == 0) {
        passwordTextField.textColor = [UIColor redColor];
        return NO;
    }
    if ([PUUtility containsIllegalCharacters:password]) {
        passwordTextField.textColor = [UIColor redColor];
        return NO;
    }
    passwordTextField.textColor = [UIColor whiteColor];
    return YES;
}

- (void)reloadLastRow{
    [sTableView beginUpdates];
    [sTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:4 inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
    [sTableView endUpdates];
}

@end
