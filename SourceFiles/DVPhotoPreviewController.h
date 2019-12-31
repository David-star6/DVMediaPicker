//
//  DVPhotoPreviewController.h
//  DVMediaPicker
//
//  Created by jacob on 2019/11/16.
//  Copyright © 2019 david. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DVPhotoPreviewController : UIViewController
@property (nonatomic, strong) NSMutableArray *photos; 
@property (nonatomic, strong) NSMutableArray *models;
@property (nonatomic, assign) NSInteger currentIndex;
@end

