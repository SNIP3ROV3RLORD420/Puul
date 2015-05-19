//
//  PUUtility.h
//  Puul
//
//  Created by Dylan Humphrey on 3/25/15.
//  Copyright (c) 2015 Dylan Humphrey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

typedef void (^PUUtilityBlock)(BOOL taken, NSError* error);

@interface PUUtility : NSObject

+ (BOOL)containsIllegalCharacters:(NSString *)string;

+ (BOOL)isValidHWEmail:(NSString *)checkString;

+ (void)usernameIsTaken:(NSString*)string withCompletionBlock:(PUUtilityBlock)block;

@end
