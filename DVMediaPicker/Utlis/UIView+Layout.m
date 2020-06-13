//
//  UIView+Layout.m
//  DVMediaPicker
//
//  Created by jacob on 2020/1/3.
//  Copyright © 2020 david. All rights reserved.
//

#import "UIView+Layout.h"
#import <objc/runtime.h>


@implementation UIView (Layout)

- (CGFloat)dv_left {
    return self.frame.origin.x;
}

- (void)setDv_left:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)dv_top {
    return self.frame.origin.y;
}

- (void)setDv_top:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)dv_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setDv_right:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)dv_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setDv_bottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)dv_width {
    return self.frame.size.width;
}

- (void)setDv_width:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)dv_height {
    return self.frame.size.height;
}

- (void)setDv_height:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)dv_centerX {
    return self.center.x;
}

- (void)setDv_centerX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)dv_centerY {
    return self.center.y;
}

- (void)setDv_centerY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGPoint)dv_origin {
    return self.frame.origin;
}

- (void)setDv_origin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)dv_size {
    return self.frame.size;
}

- (void)setDv_size:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}
@end
