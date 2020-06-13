//
//  DVPhotoPreviewController.h
//  DVMediaPicker
//
//  Created by jacob on 2019/11/16.
//  Copyright © 2019 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DVAssetModel;
@interface DVPhotoPreviewController : UIViewController
@property (nonatomic, strong) NSMutableArray *photos; 
@property (nonatomic, strong) NSMutableArray *models;
@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, copy) void (^selectBlock)(DVAssetModel * model,NSInteger index);

@end

