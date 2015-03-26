//
//  PUUtility.m
//  Puul
//
//  Created by Dylan Humphrey on 3/25/15.
//  Copyright (c) 2015 Dylan Humphrey. All rights reserved.
//

#import "PUUtility.h"

@implementation PUUtility

+ (BOOL)containsIllegalCharacters:(NSString *)string{
    NSCharacterSet *s = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890_"];
    s = [s invertedSet];
    NSRange r = [string rangeOfCharacterFromSet:s];
    if (r.location != NSNotFound) {
        return YES;
    }
    return NO;
}

@end
