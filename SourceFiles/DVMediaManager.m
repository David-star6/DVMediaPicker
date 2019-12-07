//
//  DVMediaManager.m
//  DVMediaPicker
//
//  Created by jacob on 2019/11/9.
//  Copyright © 2019 david. All rights reserved.
//

#import "DVMediaManager.h"
#import "DVAlbumModel.h"



@implementation DVMediaManager

CGSize AssetGridThumbnailSize;
CGFloat DVScreenWidth;
CGFloat DVScreenScale;

static DVMediaManager * manger;
static dispatch_once_t onceToken;

+ (instancetype)shareInstance{
    dispatch_once(&onceToken, ^{
        manger = [[self alloc] init];
        
    });
    return manger;
}


- (void)configTZScreenWidth {
    DVScreenWidth = [UIScreen mainScreen].bounds.size.width;
    // 测试发现，如果scale在plus真机上取到3.0，内存会增大特别多。故这里写死成2.0
    DVScreenScale = 2.0;
    if (DVScreenWidth > 700) {
        DVScreenScale = 1.5;
    }
}

- (void)setColumnNumber:(NSInteger)columnNumber {
    [self configTZScreenWidth];
    
    _columnNumber = columnNumber;
    CGFloat margin = 4;
    CGFloat itemWH = (DVScreenWidth - 2 * margin - 4) / columnNumber - margin;
    AssetGridThumbnailSize = CGSizeMake(itemWH * DVScreenScale, itemWH * DVScreenScale);
}


- (BOOL)authorizationStatusAuthorized {
    NSInteger status = [PHPhotoLibrary authorizationStatus];
    if (status == 0) {
        /**
         * 当某些情况下AuthorizationStatus == AuthorizationStatusNotDetermined时，无法弹出系统首次使用的授权alertView，系统应用设置里亦没有相册的设置，此时将无法使用，故作以下操作，弹出系统首次使用的授权alertView
         */
        [self requestAuthorizationWithCompletion:nil];
    }
    
    return status == 3;
}

- (void)requestAuthorizationWithCompletion:(void(^)(void))completion{
    void (^callback)(void)=^(){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion();
            }
        });
    };
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            callback();
        }];
    });
    
}

- (void)getAllAlbums:(BOOL)allowPickingVideo allowPickingImage:(BOOL)allowPickingImage completion:(void (^)(NSArray * arr))completion{
    NSMutableArray *albumArr = [NSMutableArray array];
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    if (!allowPickingVideo) option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
    if (!allowPickingImage) option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld",
                                                PHAssetMediaTypeVideo];
 
    // 我的照片流 1.6.10重新加入..
    PHFetchResult *myPhotoStreamAlbum = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumMyPhotoStream options:nil];
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    PHFetchResult *syncedAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumSyncedAlbum options:nil];
    PHFetchResult *sharedAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumCloudShared options:nil];
    NSArray *allAlbums = @[myPhotoStreamAlbum,smartAlbums,topLevelUserCollections,syncedAlbums,sharedAlbums];
    for (PHFetchResult *fetchResult in allAlbums) {
        for (PHAssetCollection *collection in fetchResult) {
            // 有可能是PHCollectionList类的的对象，过滤掉
            if (![collection isKindOfClass:[PHAssetCollection class]]) continue;
            // 过滤空相册
            if (collection.estimatedAssetCount <= 0 ) continue;
            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:option];
            if (fetchResult.count < 1 ) continue;
            if (collection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumAllHidden) continue;
            if (collection.assetCollectionSubtype == 1000000201) continue; //『最近删除』相册
            [albumArr addObject:[self modelWithResult:fetchResult name:collection.localizedTitle]];
        }
    }
    if (completion) {
        completion(albumArr);
    }
}

- (void)getAssetsFromFetchResult:(PHFetchResult *)result completion:(void (^)(NSArray*))completion{
    NSMutableArray *photoArr = [NSMutableArray array];
    [result enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL * _Nonnull stop) {
        DVAssetModel *model = [self assetModelWithAsset:asset allowPickingVideo:true allowPickingImage:true];
        if (model) {
            [photoArr addObject:model];
        }
    }];
    if (completion) completion(photoArr);
}

- (DVAssetModel *)assetModelWithAsset:(PHAsset *)asset allowPickingVideo:(BOOL)allowPickingVideo allowPickingImage:(BOOL)allowPickingImage {
    DVAssetModel *model;
    DVAssetModelMediaType type = [self getAssetType:asset];
    if (!allowPickingVideo && type == DVAssetModelMediaTypeVideo) return nil;
    if (!allowPickingImage && type == DVAssetModelMediaTypePhoto) return nil;
    if (!allowPickingImage && type == DVAssetModelMediaTypePhotoGif) return nil;
    PHAsset *phAsset = (PHAsset *)asset;
    NSString *timeLength = type == DVAssetModelMediaTypeVideo ? [NSString stringWithFormat:@"%0.0f",phAsset.duration] : @"";
    timeLength = [self getNewTimeFromDurationSecond:timeLength.integerValue];
    model = [DVAssetModel modelWithAsset:asset type:type timeLength:timeLength];
    return model;
}

- (NSString *)getNewTimeFromDurationSecond:(NSInteger)duration {
    NSString *newTime;
    if (duration < 10) {
        newTime = [NSString stringWithFormat:@"0:0%zd",duration];
    } else if (duration < 60) {
        newTime = [NSString stringWithFormat:@"0:%zd",duration];
    } else {
        NSInteger min = duration / 60;
        NSInteger sec = duration - (min * 60);
        if (sec < 10) {
            newTime = [NSString stringWithFormat:@"%zd:0%zd",min,sec];
        } else {
            newTime = [NSString stringWithFormat:@"%zd:%zd",min,sec];
        }
    }
    return newTime;
}

- (DVAssetModelMediaType)getAssetType:(PHAsset *)asset {
    DVAssetModelMediaType type = DVAssetModelMediaTypePhoto;
    PHAsset *phAsset = (PHAsset *)asset;
    if (phAsset.mediaType == PHAssetMediaTypeVideo)      type = DVAssetModelMediaTypeVideo;
    else if (phAsset.mediaType == PHAssetMediaTypeAudio) type = DVAssetModelMediaTypeAudio;
    else if (phAsset.mediaType == PHAssetMediaTypeImage) {
        if (@available(iOS 9.1, *)) {
            // if (asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive) type = TZAssetModelMediaTypeLivePhoto;
        }
        // Gif
        if ([[phAsset valueForKey:@"filename"] hasSuffix:@"GIF"]) {
            type = DVAssetModelMediaTypePhotoGif;
        }
    }
    return type;
}

- (void)getPhotoWithAsset:(PHAsset *)asset completion:(void(^)(UIImage *photo))completion progressHandler:(void (^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler networkAccessAllowed:(BOOL)networkAccessAllowed{
    CGFloat fullScreenWidth = DVScreenWidth;
    return [self getPhotoWithAsset:asset photoWidth:fullScreenWidth networkAccessAllowed:true completion:completion progressHandler:progressHandler];
}

- (void)getPhotoWithAsset:(PHAsset *)asset photoWidth:(CGFloat)photoWidth networkAccessAllowed:(BOOL)networkAccessAllowed  completion:(void(^)(UIImage *photo))completion progressHandler:(void (^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler{
    CGSize imageSize;
    if (photoWidth < DVScreenWidth && photoWidth < 600) {
        imageSize = AssetGridThumbnailSize;
    } else {
        PHAsset *phAsset = (PHAsset *)asset;
        CGFloat aspectRatio = phAsset.pixelWidth / (CGFloat)phAsset.pixelHeight;
        CGFloat pixelWidth = photoWidth * DVScreenScale;
        // 超宽图片
        if (aspectRatio > 1.8) {
            pixelWidth = pixelWidth * aspectRatio;
        }
        // 超高图片
        if (aspectRatio < 0.2) {
            pixelWidth = pixelWidth * 0.5;
        }
        CGFloat pixelHeight = pixelWidth / aspectRatio;
        imageSize = CGSizeMake(pixelWidth, pixelHeight);
    }
    
    __block UIImage *image;
    
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    int32_t imageRequestID = [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:imageSize contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage *result, NSDictionary *info) {
        if (result) {
            image = result;
        }
        BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
        if (downloadFinined && result) {
            result = [self fixOrientation:result];
            if (completion) completion(result);
        }
        // Download image from iCloud / 从iCloud下载图片
        if ([info objectForKey:PHImageResultIsInCloudKey] && !result && networkAccessAllowed) {
            PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
            options.progressHandler = ^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (progressHandler) {
                        progressHandler(progress, error, stop, info);
                    }
                });
            };
            options.networkAccessAllowed = YES;
            options.resizeMode = PHImageRequestOptionsResizeModeFast;
            [[PHImageManager defaultManager] requestImageDataForAsset:asset options:options resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
                UIImage *resultImage = [UIImage imageWithData:imageData];
                if (!resultImage) {
                    resultImage = image;
                }
                resultImage = [self fixOrientation:resultImage];
                if (completion) completion(resultImage);
            }];
        }
    }];
}

- (void)getVideoWithAsset:(PHAsset *)asset completion:(void (^)(AVPlayerItem *, NSDictionary *))completion {
    [self getVideoWithAsset:asset progressHandler:nil completion:completion];
}

- (void)getVideoWithAsset:(PHAsset *)asset progressHandler:(void (^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler completion:(void (^)(AVPlayerItem *, NSDictionary *))completion {
    PHVideoRequestOptions *option = [[PHVideoRequestOptions alloc] init];
    option.networkAccessAllowed = YES;
    option.progressHandler = ^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (progressHandler) {
                progressHandler(progress, error, stop, info);
            }
        });
    };
    [[PHImageManager defaultManager] requestPlayerItemForVideo:asset options:option resultHandler:^(AVPlayerItem *playerItem, NSDictionary *info) {
        if (completion) completion(playerItem,info);
    }];
}


/// 修正图片转向
- (UIImage *)fixOrientation:(UIImage *)aImage {
    if (!self.shouldFixOrientation) return aImage;
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}


#pragma mark -- Private

- (DVAlbumModel *)modelWithResult:(PHFetchResult *)result name:(NSString *)name {
    DVAlbumModel *model = [[DVAlbumModel alloc] init];
    [model setResult:result needFetchAssets:true];
    model.name = name;
    model.count = result.count;
    model.result = result;
    return model;
}

@end
