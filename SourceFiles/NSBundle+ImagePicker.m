//
//  NSBundle+ImagePicker.m
//  DVMediaPicker
//
//  Created by jacob on 2019/12/4.
//  Copyright © 2019 david. All rights reserved.
//

#import "NSBundle+ImagePicker.h"
#import "DVMediaPickerContoller.h"

@implementation NSBundle (ImagePicker)

+ (NSBundle *)imagePickerBundle {
//    NSBundle *bundle = [NSBundle mainBundle];
    NSString * path = [[NSBundle mainBundle] pathForResource:@"Resources" ofType:@"bundle"];
    NSBundle *myBundle = [NSBundle bundleWithPath:path];
//    NSURL *url = [bundle URLForResource:@"Resources" withExtension:@"bundle"];
//    bundle = [NSBundle bundleWithURL:url];
    return myBundle;
}
@end
