//
//  DVAlbumModel.h
//  DVMediaPicker
//
//  Created by jacob on 2019/11/9.
//  Copyright © 2019 david. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    DVAssetModelMediaTypePhoto = 0,
    DVAssetModelMediaTypeLivePhoto,
    DVAssetModelMediaTypePhotoGif,
    DVAssetModelMediaTypeVideo,
    DVAssetModelMediaTypeAudio
} DVAssetModelMediaType;

@class PHFetchResult;
@interface DVAlbumModel : NSObject

@property (nonatomic, strong) NSString *name;        ///< The album name
@property (nonatomic, assign) NSInteger count;       ///< Count of photos the album contain
@property (nonatomic, strong) PHFetchResult *result;

@property (nonatomic, strong) NSArray *models;

- (void)setResult:(PHFetchResult *)result needFetchAssets:(BOOL)needFetchAssets;

@end

@class PHAsset;
@interface DVAssetModel : NSObject

@property (nonatomic, strong) PHAsset *asset;
@property (nonatomic, copy) NSString *timeLength;
@property (nonatomic, assign) DVAssetModelMediaType type;
@property (nonatomic, assign) BOOL isSelected;

/// Init a photo dataModel With a PHAsset
/// 用一个PHAsset实例，初始化一个照片模型
+ (instancetype)modelWithAsset:(PHAsset *)asset type:(DVAssetModelMediaType)type;
+ (instancetype)modelWithAsset:(PHAsset *)asset type:(DVAssetModelMediaType)type timeLength:(NSString *)timeLength;

@end


NS_ASSUME_NONNULL_END
