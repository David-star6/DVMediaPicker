//
//  DVAssetCell.m
//  DVMediaPicker
//
//  Created by jacob on 2019/11/11.
//  Copyright © 2019 david. All rights reserved.
//

#import "DVAssetCell.h"
#import "DVMediaPickerContoller.h"


typedef NS_ENUM(NSUInteger, CellTpye) {
    CellTpyeVideo=0,
    CellTpyeImage=1,
};

@interface DVAssetCell()
@property (weak, nonatomic) UIImageView *selectImageView;
@property (weak, nonatomic) UILabel *indexLabel;
@property (nonatomic, weak) UIImageView * imageView;
@property (nonatomic, weak) UIImageView * videoImgView;
@property (nonatomic, weak) UIView * bottomView;
@property (nonatomic, weak) UILabel * timerLabel;
@end

@implementation DVAssetCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload:) name:@"TZ_PHOTO_PICKER_RELOAD_NOTIFICATION" object:nil];
    return self;
}

- (void)setModel:(DVAssetModel *)model {
    _model = model;
    [[DVMediaManager shareInstance] getPhotoWithAsset:model.asset  photoWidth:self.frame.size.width networkAccessAllowed:true completion:^(UIImage * _Nonnull photo, NSDictionary * _Nonnull info, BOOL isDegraded) {
        self.imageView.image = photo;
        self.type = (NSInteger)model.type;
        self.selectPhotoButton.selected = model.isSelected;
        self.selectImageView.image = self.selectPhotoButton.isSelected ? self.photoSelImage : self.photoDefImage;
        self.indexLabel.hidden = !self.selectPhotoButton.isSelected;
    } progressHandler:^(double progress, NSError * _Nonnull error, BOOL * _Nonnull stop, NSDictionary * _Nonnull info) {
        
    }];
}

- (void)setType:(DVAssetCellType)type{
    _type = type;
    if(type == DVAssetCellTypePhoto || type == DVAssetCellTypeLivePhoto){
        [self cellType:CellTpyeImage];
    } else if (type == DVAssetCellTypeVideo){
        [self cellType:CellTpyeVideo];
    }
}

- (void)cellType:(CellTpye)type{
    switch (type) {
        case CellTpyeVideo:
            self.bottomView.hidden = NO;
            self.videoImgView.hidden = NO;
            self.timerLabel.hidden = NO;
            self.selectPhotoButton.hidden = YES;
            self.selectImageView.hidden = YES;
            self.timerLabel.text = _model.timeLength;
            break;
        case CellTpyeImage:
            self.bottomView.hidden = YES;
            self.videoImgView.hidden = YES;
            self.timerLabel.hidden = YES;
            self.selectPhotoButton.hidden = NO;
            self.selectImageView.hidden = NO;
            break;
        default:
            break;
    }
    
}



- (void)selectPhotoButtonClick:(UIButton *)sender {
    if (self.didSelectPhotoBlock) {
        self.didSelectPhotoBlock(sender.isSelected);
    }
    self.indexLabel.hidden = !sender.isSelected;
    self.selectImageView.image = sender.isSelected ? self.photoSelImage : self.photoDefImage;
   
}

- (void)cancelBigImageRequest {
//    if (_bigImageRequestID) {
//        [[PHImageManager defaultManager] cancelImageRequest:_bigImageRequestID];
//    }
//    [self hideProgressView];
}

- (void)setIndex:(NSInteger)index {
    _index = index;
    self.indexLabel.text = [NSString stringWithFormat:@"%zd", index];
    [self.contentView bringSubviewToFront:self.indexLabel];
}

- (void)reload:(NSNotification *)noti {
    DVMediaPickerContoller *imagePickerVc = (DVMediaPickerContoller *)noti.object;
    if (self.model.isSelected) {
        self.index = [imagePickerVc.selectedAssetIds indexOfObject:self.model.asset.localIdentifier] + 1;
    }
    self.indexLabel.hidden = !self.selectPhotoButton.isSelected;
}



#pragma mark - Lazy load

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

- (UILabel *)timerLabel{
    if(_timerLabel == nil){
        UILabel * label = [[UILabel alloc] init];
        label.textColor = [UIColor whiteColor];
        label.font =  [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentRight;
        [label sizeToFit];
        [self.bottomView addSubview:label];
        _timerLabel = label;
    }
    return _timerLabel;
}

- (UILabel *)indexLabel {
    if (_indexLabel == nil) {
        UILabel *indexLabel = [[UILabel alloc] init];
        indexLabel.font = [UIFont systemFontOfSize:14];
        indexLabel.adjustsFontSizeToFitWidth = YES;
        indexLabel.textColor = [UIColor whiteColor];
        indexLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:indexLabel];
        _indexLabel = indexLabel;
    }
    return _indexLabel;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    _cannotSelectLayerButton.frame = self.bounds;
    
    _selectPhotoButton.frame = CGRectMake(self.frame.size.width - 44, 0, 44, 44);

    _selectImageView.frame = CGRectMake(self.frame.size.width - 27, 3, 24, 24);
    if (_selectImageView.image.size.width <= 27) {
        _selectImageView.contentMode = UIViewContentModeCenter;
    } else {
        _selectImageView.contentMode = UIViewContentModeScaleAspectFit;
    }

    _indexLabel.frame = _selectImageView.frame;
    _imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _bottomView.frame = CGRectMake(0,  self.frame.size.height - 17, self.frame.size.width, 17);
    _videoImgView.frame = CGRectMake(8, 0, 17, 17);
    _timerLabel.frame = CGRectMake(self.frame.size.width-54-5, 0, 54, 17);
}

- (UIButton *)selectPhotoButton {
    if (_selectPhotoButton == nil) {
        UIButton *selectPhotoButton = [[UIButton alloc] init];
        [selectPhotoButton addTarget:self action:@selector(selectPhotoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:selectPhotoButton];
        _selectPhotoButton = selectPhotoButton;
    }
    return _selectPhotoButton;
}

- (UIButton *)cannotSelectLayerButton {
    if (_cannotSelectLayerButton == nil) {
        UIButton *cannotSelectLayerButton = [[UIButton alloc] init];
        [self.contentView addSubview:cannotSelectLayerButton];
        _cannotSelectLayerButton = cannotSelectLayerButton;
    }
    return _cannotSelectLayerButton;
}

- (UIImageView *)selectImageView {
    if (_selectImageView == nil) {
        UIImageView *selectImageView = [[UIImageView alloc] init];
        selectImageView.contentMode = UIViewContentModeCenter;
        selectImageView.clipsToBounds = YES;
        [self.contentView addSubview:selectImageView];
        _selectImageView = selectImageView;
    }
    return _selectImageView;
}


@end

@implementation DVAssetCameraCell



@end
