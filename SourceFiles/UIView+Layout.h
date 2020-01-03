//
//  UIView+Layout.h
//  DVMediaPicker
//
//  Created by jacob on 2020/1/3.
//  Copyright © 2020 david. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Layout)

@property (nonatomic) CGFloat dv_left;        ///< Shortcut for frame.origin.x.
@property (nonatomic) CGFloat dv_top;         ///< Shortcut for frame.origin.y
@property (nonatomic) CGFloat dv_right;       ///< Shortcut for frame.origin.x + frame.size.width
@property (nonatomic) CGFloat dv_bottom;      ///< Shortcut for frame.origin.y + frame.size.height
@property (nonatomic) CGFloat dv_width;       ///< Shortcut for frame.size.width.
@property (nonatomic) CGFloat dv_height;      ///< Shortcut for frame.size.height.
@property (nonatomic) CGFloat dv_centerX;     ///< Shortcut for center.x
@property (nonatomic) CGFloat dv_centerY;     ///< Shortcut for center.y
@property (nonatomic) CGPoint dv_origin;      ///< Shortcut for frame.origin.
@property (nonatomic) CGSize  dv_size;        ///< Shortcut for frame.size.

@end

NS_ASSUME_NONNULL_END
