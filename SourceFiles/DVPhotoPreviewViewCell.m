//
//  DVPhotoPreviewViewCell.m
//  DVMediaPicker
//
//  Created by jacob on 2019/11/16.
//  Copyright © 2019 david. All rights reserved.
//

#import "DVPhotoPreviewViewCell.h"
#import "DVProgressView.h"
#import "DVMediaManager.h"
#import "DVAlbumModel.h"


@implementation DVAssetPreviewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor blackColor];
        [self configSubviews];
    }
    return self;
}

- (void)configSubviews {
    
}


@end

@implementation DVPhotoPreviewViewCell

- (void)configSubviews{
    self.previewView = [[DVPhotoPreviewView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.previewView];
}

- (void)setModel:(DVAssetModel *)model{
    [super setModel:model];
    _previewView.asset = model.asset;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.previewView.frame = self.bounds;
}


- (void)recoverSubviews {
    [_previewView recoverSubviews];
}


@end

@implementation DVPhotoPreviewView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        _imageContainerView = [[UIView alloc] init];
        _imageContainerView.clipsToBounds = true;
        _imageContainerView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_imageContainerView];
        
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        [_imageContainerView addSubview:_imageView];
        
        [self configProgressView];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    static CGFloat progressWH = 40;
    CGFloat progressX = (self.frame.size.width - progressWH) / 2;
    CGFloat progressY = (self.frame.size.height - progressWH) / 2;
    _progressView.frame = CGRectMake(progressX, progressY, progressWH, progressWH);
    
    [self recoverSubviews];
}

- (void)configProgressView {
    _progressView = [[DVProgressView alloc] init];
    _progressView.hidden = YES;
    [self addSubview:_progressView];
}

- (void)setModel:(DVAssetModel *)model{
    _model = model;
}

- (void)recoverSubviews {
    [self resizeSubviews];
}

- (void)setAsset:(PHAsset *)asset {
    _asset = asset;
    [[DVMediaManager shareInstance] getPhotoWithAsset:asset completion:^(UIImage * _Nonnull photo) {
        self.imageView.image = photo;
        self.progressView.hidden = YES;
        [self resizeSubviews];
    } progressHandler:^(double progress, NSError * _Nonnull error, BOOL * _Nonnull stop, NSDictionary * _Nonnull info) {
        self.progressView.hidden = NO;
        [self bringSubviewToFront:self.progressView];
        progress = progress > 0.02 ? progress : 0.02;
        self.progressView.progress = progress;
        if (progress >= 1) {
            self.progressView.hidden = YES;
        }
    } networkAccessAllowed:true];
}

- (void)resizeSubviews{
    _imageContainerView.frame = self.frame;
    _imageView.frame = _imageContainerView.bounds;
}


@end
