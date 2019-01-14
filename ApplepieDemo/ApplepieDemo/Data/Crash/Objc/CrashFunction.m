//
//  CrashFunction.m
//  ApplepieDemo
//
//  Created by 山天大畜 on 2019/1/14.
//  Copyright © 2019 山天大畜. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CrashFunction.h"

@implementation CrashFunction

+ (void) invokeGenericException {
    NSMutableArray *mArray = [NSMutableArray arrayWithArray:@[@0, @1, @2]];
    for (NSNumber *num in mArray) {
        [mArray addObject:@3];
        printf("%ld", (long)num.integerValue);
    }
}

@end
