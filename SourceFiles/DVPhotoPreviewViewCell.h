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
@property (nonatomic, copy) void(^singleTapGestureBlock)(void);

@end

@class DVPhotoPreviewView,DVAssetModel;
@interface DVPhotoPreviewViewCell : DVAssetPreviewCell
@property (nonatomic, strong) DVPhotoPreviewView *previewView;
- (void)recoverSubviews;

@end


@class DVProgressView;
@interface DVPhotoPreviewView  : UIView
@property (nonatomic, strong) DVProgressView *progressView;
@property (nonatomic, strong) DVAssetModel *model;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) id asset;
@property (nonatomic, strong) UIView *imageContainerView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, copy) void(^singleTapGestureBlock)(void);
- (void)recoverSubviews;

@end
