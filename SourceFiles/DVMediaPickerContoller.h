//
//  DVMediaPickerContoller.h
//  DVMediaPicker
//
//  Created by jacob on 2019/11/9.
//  Copyright © 2019 david. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DVMediaPickerContoller : UINavigationController

@end

@interface DVAlbumPickerController : UIViewController
@property (nonatomic, assign) NSInteger columnNumber;

@end

@interface DVCommonTools : NSObject
+ (BOOL)tz_isIPhoneX;
+ (CGFloat)tz_statusBarHeight;
// 获得Info.plist数据字典
+ (NSDictionary *)tz_getInfoDictionary;
+ (BOOL)tz_isRightToLeftLayout;
@end

@interface UIImage (Bundle)
+ (UIImage *)imageNamedFromBundle:(NSString *)name;
@end

