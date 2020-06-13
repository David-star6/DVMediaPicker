//
//  DVMediaManager.h
//  DVMediaPicker
//
//  Created by jacob on 2019/11/9.
//  Copyright © 2019 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface DVMediaManager : UITableViewCell

@property (nonatomic, assign) BOOL shouldFixOrientation;

@property (nonatomic, assign) NSInteger columnNumber;

+ (instancetype)shareInstance;

- (BOOL)authorizationStatusAuthorized;

- (void)getAllAlbums:(BOOL)allowPickingVideo allowPickingImage:(BOOL)allowPickingImage completion:(void (^)(NSArray *arr))completion;

- (void)getAssetsFromFetchResult:(PHFetchResult *)result completion:(void (^)(NSArray*))completion;

- (void)getVideoWithAsset:(PHAsset *)asset completion:(void (^)(AVPlayerItem *, NSDictionary *))completion;

- (void)getPhotoWithAsset:(PHAsset *)asset photoWidth:(CGFloat)photoWidth networkAccessAllowed:(BOOL)networkAccessAllowed  completion:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion progressHandler:(void (^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler;

- (void)getPhotoWithAsset:(PHAsset *)asset completion:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion progressHandler:(void (^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler networkAccessAllowed:(BOOL)networkAccessAllowed;

@end

NS_ASSUME_NONNULL_END
