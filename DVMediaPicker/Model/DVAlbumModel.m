//
//  DVAlbumModel.m
//  DVMediaPicker
//
//  Created by jacob on 2019/11/9.
//  Copyright © 2019 david. All rights reserved.
//

#import "DVAlbumModel.h"
#import "DVMediaManager.h"


@implementation DVAlbumModel

- (void)setResult:(PHFetchResult *)result needFetchAssets:(BOOL)needFetchAssets {
    _result = result;
    if (needFetchAssets) {
        [[DVMediaManager shareInstance] getAssetsFromFetchResult:result completion:^(NSArray<DVAssetModel *> *models) {
            self->_models = models;
        }];
    }
}

@end

@implementation DVAssetModel

+ (instancetype)modelWithAsset:(PHAsset *)asset type:(DVAssetModelMediaType)type timeLength:(NSString *)timeLength {
    DVAssetModel *model = [self modelWithAsset:asset type:type];
    model.timeLength = timeLength;
    return model;
}

+ (instancetype)modelWithAsset:(PHAsset *)asset type:(DVAssetModelMediaType)type{
    DVAssetModel *model = [[DVAssetModel alloc] init];
    model.asset = asset;
    model.type = type;
    return model;
}


@end
