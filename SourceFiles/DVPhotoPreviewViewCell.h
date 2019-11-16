//
//  DVPhotoPreviewViewCell.h
//  DVMediaPicker
//
//  Created by jacob on 2019/11/16.
//  Copyright © 2019 david. All rights reserved.
//

#import <UIKit/UIKit.h>


@class DVAssetModel;
@interface DVAssetPreviewCell : UICollectionViewCell
@property (nonatomic, strong) DVAssetModel *model;

@end

@class DVPhotoPreviewView,DVAssetModel;
@interface DVPhotoPreviewViewCell : DVAssetPreviewCell
@property (nonatomic, strong) DVPhotoPreviewView *previewView;

@end


@class DVProgressView;
@interface DVPhotoPreviewView  : UIView
@property (nonatomic, strong) DVProgressView *progressView;
@property (nonatomic, strong) DVAssetModel *model;
@property (nonatomic, strong) id asset;
@property (nonatomic, strong) UIView *imageContainerView;
@property (nonatomic, strong) UIImageView *imageView;
- (void)recoverSubviews;

@end
