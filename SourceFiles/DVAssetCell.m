//
//  DVAssetCell.m
//  DVMediaPicker
//
//  Created by jacob on 2019/11/11.
//  Copyright © 2019 david. All rights reserved.
//

#import "DVAssetCell.h"


@interface DVAssetCell()
@property (nonatomic, weak) UIImageView * imageView;
@property (nonatomic, weak) UIImageView *videoImgView;

@end

@implementation DVAssetCell

- (void)setModel:(DVAssetModel *)model {
    _model = model;
    [[DVMediaManager shareInstance] getPhotoWithAsset:model.asset  photoWidth:self.frame.size.width networkAccessAllowed:true completion:^(UIImage * _Nonnull photo) {
        self.imageView.image = photo;
    } progressHandler:^(double progress, NSError * _Nonnull error, BOOL * _Nonnull stop, NSDictionary * _Nonnull info) {
        
    }];
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


- (void)layoutSubviews{
    [super layoutSubviews];
    _imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
}

@end

@implementation DVAssetCameraCell



@end
