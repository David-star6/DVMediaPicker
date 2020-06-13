//
//  DVMediaListController.h
//  DVMediaPicker
//
//  Created by jacob on 2019/11/11.
//  Copyright © 2019 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DVAlbumModel;
@interface DVMediaListController : UIViewController
@property (nonatomic, strong) DVAlbumModel * model;
@property (nonatomic, assign) NSInteger columnNumber;

@end

@interface DVCollectionView : UICollectionView

@end
