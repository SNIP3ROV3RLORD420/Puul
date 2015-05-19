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
#import <BlocksKit/BlocksKit+UIKit.h>
#import "PUUtility.h"

@interface PUSignUpViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>{
    UITableView *sTableView;
    
    UITextField *usernameTextField;
    UITextField *passwordTextField;
    UITextField *emailTextField;
    UITextField *nameTextField;
    
    BOOL username;
    BOOL password;
    BOOL email;
    BOOL name;
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
            passwordTextField.secureTextEntry = YES;
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
        if (username && password && email && name) {
            cell.contentView.backgroundColor = [UIColor greenColor];
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
        else{
            cell.contentView.backgroundColor = [UIColor puulRedColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
        label.text = @"Sign Up";
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:label];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 4 && username && password && email && name) {
        //try to sign up the user
        PFUser *user = [PFUser user];
        user.username = usernameTextField.text;
        user.password = passwordTextField.text;
        user.email = emailTextField.text;
        user[@"name"] = nameTextField.text;
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                [self.navigationController popToRootViewControllerAnimated:YES];
                NSLog(@"SUCCESSS");
            }
            else{
                NSLog(@"%@", error);
            }
        }];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == usernameTextField) {
        [passwordTextField becomeFirstResponder];
        [self checkUsername];
    }
    if (textField == passwordTextField) {
        [emailTextField becomeFirstResponder];
        [self checkPassword];
    }
    if (textField == emailTextField) {
        [nameTextField becomeFirstResponder];
        [self checkEmail];
    }
    if (textField == nameTextField) {
        [nameTextField resignFirstResponder];
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == nameTextField) {
        if (nameTextField.text.length > 0) {
            name = YES;
        }
    }
    if (username && password && email && name) {
        [self reloadLastRow];
    }
    return YES;
}

#pragma mark - Helper Methods

- (void)checkUsername{
    [PUUtility usernameIsTaken:usernameTextField.text withCompletionBlock:^(BOOL taken, NSError *error) {
        if (taken) {
            username = NO;
            usernameTextField.textColor = [UIColor redColor];
            return;
        }
        else if (!error){
            BOOL length = usernameTextField.text.length > 0;
            BOOL characters = [PUUtility containsIllegalCharacters:usernameTextField.text];
            username = length && characters;
            usernameTextField.textColor = [UIColor redColor];
        }
        else{
            //handle error
            NSLog(@"%@", error);
        }
    }];
}

- (void)checkEmail{
    email = [PUUtility isValidHWEmail:emailTextField.text];
    if (!email) {
        emailTextField.textColor = [UIColor redColor];
    }
    else{
        emailTextField.textColor = [UIColor blackColor];
    }
}

- (void)checkPassword{
    BOOL chars = [PUUtility containsIllegalCharacters:passwordTextField.text];
    BOOL length = passwordTextField.text.length > 5;
    password = chars && length;
    if (!password) {
        passwordTextField.textColor = [UIColor redColor];
    }
    else{
        passwordTextField.textColor = [UIColor blackColor];
    }
}

- (void)reloadLastRow{
    [sTableView beginUpdates];
    [sTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:4 inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
    [sTableView endUpdates];
}

@end
