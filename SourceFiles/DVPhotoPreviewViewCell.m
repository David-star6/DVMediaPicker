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
    __weak typeof(self)weakSelf = self;
    [self.previewView setSingleTapGestureBlock:^{
        if(weakSelf.singleTapGestureBlock){
            weakSelf.singleTapGestureBlock();
        }
    }];
    
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



@interface DVPhotoPreviewView ()<UIScrollViewDelegate>

@end

@implementation DVPhotoPreviewView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        _imageContainerView = [[UIView alloc] init];
        _imageContainerView.clipsToBounds = true;
        _imageContainerView.contentMode = UIViewContentModeScaleAspectFill;
        [self.scrollView addSubview:_imageContainerView];
        
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        [_imageContainerView addSubview:_imageView];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        [self addGestureRecognizer:tap];
        UITapGestureRecognizer *pan = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        pan.numberOfTapsRequired = 2;
        [tap requireGestureRecognizerToFail:pan];
        [self addGestureRecognizer:pan];
        [self configProgressView];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _scrollView.frame = CGRectMake(10, 0, self.frame.size.width - 20, self.frame.size.height);
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
    [_scrollView setZoomScale:1.0 animated:NO];
}

- (void)recoverSubviews {
    [_scrollView setZoomScale:_scrollView.minimumZoomScale animated:NO];
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


#pragma mark -- delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageContainerView;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    scrollView.contentInset = UIEdgeInsetsZero;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self refreshImageContainerViewCenter];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
}

#pragma mark -- repson
- (void)singleTap:(UITapGestureRecognizer *)tap{
    if (self.singleTapGestureBlock) {
        self.singleTapGestureBlock();
    }
}

- (void)doubleTap:(UITapGestureRecognizer *)tap {
    if (_scrollView.zoomScale > _scrollView.minimumZoomScale) {
        _scrollView.contentInset = UIEdgeInsetsZero;
        [_scrollView setZoomScale:_scrollView.minimumZoomScale animated:YES];
    } else {
        CGPoint touchPoint = [tap locationInView:self.imageView];
        CGFloat newZoomScale = _scrollView.maximumZoomScale;
        CGFloat xsize = self.frame.size.width / newZoomScale;
        CGFloat ysize = self.frame.size.height / newZoomScale;
        [_scrollView zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
    }
}


#pragma mark -- private

- (void)refreshImageContainerViewCenter {
    CGFloat offsetX = (_scrollView.frame.size.width > _scrollView.contentSize.width) ? ((_scrollView.frame.size.width - _scrollView.contentSize.width) * 0.5) : 0.0;
    CGFloat offsetY = (_scrollView.frame.size.height > _scrollView.contentSize.height) ? ((_scrollView.frame.size.height - _scrollView.contentSize.height) * 0.5) : 0.0;
    self.imageContainerView.center = CGPointMake(_scrollView.contentSize.width * 0.5 + offsetX, _scrollView.contentSize.height * 0.5 + offsetY);
}



#pragma mark -- git
- (UIScrollView *)scrollView{
    if(!_scrollView){
        UIScrollView * scrollView = [[UIScrollView alloc] init];
        scrollView.bouncesZoom = YES;
        scrollView.maximumZoomScale = 2.5;
        scrollView.minimumZoomScale = 1.0;
        scrollView.multipleTouchEnabled = YES;
        scrollView.delegate = self;
        scrollView.scrollsToTop = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.autoresizingMask =  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        scrollView.delaysContentTouches = NO;
        scrollView.canCancelContentTouches = YES;
        scrollView.alwaysBounceVertical = NO;
        if (@available(iOS 11, *)) {
            scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [self addSubview:scrollView];
        _scrollView = scrollView;
    }
    return _scrollView;
}

@end
