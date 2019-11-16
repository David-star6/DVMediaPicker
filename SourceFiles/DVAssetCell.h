//
//  DVAssetCell.h
//  DVMediaPicker
//
//  Created by jacob on 2019/11/11.
//  Copyright © 2019 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DVMediaManager.h"
#import "DVAlbumModel.h"

typedef enum : NSInteger{
    DVAssetCellTypePhoto = 0,
    DVAssetCellTypeLivePhoto,
    DVAssetCellTypePhotoGif,
    DVAssetCellTypeVideo,
    DVAssetCellTypeAudio,
} DVAssetCellType;

@class DVAssetModel;
@interface DVAssetCell : UICollectionViewCell
@property (nonatomic, strong) DVAssetModel *model;
@property (nonatomic, assign) DVAssetCellType type;
@property (nonatomic, copy) void(^didSelectPhotoBlock)(BOOL);

@end

@interface DVAssetCameraCell : UICollectionViewCell

@end



