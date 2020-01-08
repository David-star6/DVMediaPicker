//
//  DVMediaPickerContoller.h
//  DVMediaPicker
//
//  Created by jacob on 2019/11/9.
//  Copyright © 2019 david. All rights reserved.
//

#import <UIKit/UIKit.h>


@class DVAssetModel;
@interface DVMediaPickerContoller : UINavigationController
@property (nonatomic, assign) NSInteger maxImagesCount;

/// 超时时间，默认为15秒，当取图片时间超过15秒还没有取成功时，会自动dismiss HUD；
@property (nonatomic, assign) NSInteger timeout;

/// 用户选中过的图片数组
@property (nonatomic, strong) NSMutableArray<DVAssetModel *> *selectedModels;
@property (nonatomic, strong) NSMutableArray *selectedAssetIds;

- (void)addSelectedModel:(DVAssetModel *)model;
- (void)removeSelectedModel:(DVAssetModel *)model;

- (void)showProgressHUD;
- (void)hideProgressHUD;


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

