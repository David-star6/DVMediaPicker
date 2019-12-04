//
//  DVAssetCell.m
//  DVMediaPicker
//
//  Created by jacob on 2019/11/11.
//  Copyright © 2019 david. All rights reserved.
//

#import "DVAssetCell.h"
#import "DVMediaPickerContoller.h"

@interface DVAssetCell()
@property (nonatomic, weak) UIImageView * imageView;
@property (nonatomic, weak) UIImageView * videoImgView;
@property (nonatomic, weak) UIView * bottomView;

@end

@implementation DVAssetCell

- (void)setModel:(DVAssetModel *)model {
    _model = model;
    [[DVMediaManager shareInstance] getPhotoWithAsset:model.asset  photoWidth:self.frame.size.width networkAccessAllowed:true completion:^(UIImage * _Nonnull photo) {
        self.imageView.image = photo;
        self.type = (NSInteger)model.type;
    } progressHandler:^(double progress, NSError * _Nonnull error, BOOL * _Nonnull stop, NSDictionary * _Nonnull info) {
        
    }];
}

- (void)setType:(DVAssetCellType)type{
    _type = type;
    if(type == DVAssetCellTypePhoto || type == DVAssetCellTypeLivePhoto){
        _bottomView.hidden = YES;
    } else if (type == DVAssetCellTypeVideo){
        self.bottomView.hidden = NO;
        self.videoImgView.hidden = NO;
    }
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [self.contentView addSubview:imageView];
        _imageView = imageView;
    }
    return _imageView;
}

- (UIImageView *)videoImgView{
    if(_videoImgView == nil){
        UIImageView * image = [[UIImageView alloc] init];
        [image setImage:[UIImage imageNamedFromBundle:@"ic_videoSendIcon" ]];
        [self.bottomView addSubview:image];
        _videoImgView = image;
    }
    return _videoImgView;
}

- (UIView *)bottomView {
    if (_bottomView == nil) {
        UIView *bottomView = [[UIView alloc] init];
        static NSInteger rgb = 0;
        bottomView.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:0.8];
        [self.contentView addSubview:bottomView];
        _bottomView = bottomView;
    }
    return _bottomView;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    _imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _bottomView.frame = CGRectMake(0,  self.frame.size.height - 17, self.frame.size.width, 17);
    _videoImgView.frame = CGRectMake(8, 0, 17, 17);
    
    [self.contentView bringSubviewToFront:_bottomView];
    
}

@end

@implementation DVAssetCameraCell



@end
