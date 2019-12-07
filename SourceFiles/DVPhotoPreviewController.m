//
//  DVPhotoPreviewController.m
//  DVMediaPicker
//
//  Created by jacob on 2019/11/16.
//  Copyright © 2019 david. All rights reserved.
//

#import "DVPhotoPreviewController.h"
#import "DVPhotoPreviewViewCell.h"
#import "DVMediaPickerContoller.h"
#import "DVAlbumModel.h"

@interface DVPhotoPreviewController()<UICollectionViewDataSource,UICollectionViewDelegate> {
    UICollectionView *_collectionView;
    UICollectionViewFlowLayout *_layout;
    CGFloat _offsetItemCount;
}

@property (nonatomic, weak) UIView * navView;

@end

@implementation DVPhotoPreviewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self configCollectionView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [UIApplication sharedApplication].statusBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)configCollectionView{
    _layout = [[UICollectionViewFlowLayout alloc] init];
    _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_layout];
    _collectionView.backgroundColor = [UIColor blackColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.scrollsToTop = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.contentOffset = CGPointMake(0, 0);
    _collectionView.contentSize = CGSizeMake(self.models.count * (self.view.frame.size.width + 20), 0);
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[DVPhotoPreviewViewCell class] forCellWithReuseIdentifier:@"DVPhotoPreviewViewCell"];
    [_collectionView registerClass:[DVVideoPreviewCell class] forCellWithReuseIdentifier:@"DVVideoPreviewCell"];
    [_collectionView setContentOffset:CGPointMake((self.view.frame.size.width+20)*self.currentIndex, 0) animated:false];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _layout.itemSize = CGSizeMake(self.view.frame.size.width  + 20, self.view.frame.size.height);
    _layout.minimumInteritemSpacing = 0;
    _layout.minimumLineSpacing = 0;
    _collectionView.frame = CGRectMake(-10, 0, self.view.frame.size.width + 20, self.view.frame.size.height);
    [_collectionView setCollectionViewLayout:_layout];
    if (_offsetItemCount > 0) {
        CGFloat offsetX = _offsetItemCount * _layout.itemSize.width;
        [_collectionView setContentOffset:CGPointMake(offsetX, 0)];
    }
    
    self.navView.frame = CGRectMake(0, 0, self.view.frame.size.width, DVCommonTools.tz_isIPhoneX ? 88:64 );
}


#pragma mark -- delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DVAssetPreviewCell * cell;
    DVAssetModel *model = _models[indexPath.item];
//    DVAssetModelMediaType type =
    if(model.type == DVAssetModelMediaTypePhoto ||  model.type == DVAssetModelMediaTypeLivePhoto){
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DVPhotoPreviewViewCell" forIndexPath:indexPath];
    } else if(model.type == DVAssetModelMediaTypeVideo){
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DVVideoPreviewCell" forIndexPath:indexPath];
    }
    cell.model = model;
    __weak typeof(self) weakSelf = self;
    [cell setSingleTapGestureBlock:^{
        [weakSelf didTapPreviewCell];
    }];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if([cell isKindOfClass:[DVPhotoPreviewViewCell class]]){
        [(DVPhotoPreviewViewCell *)cell recoverSubviews];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[DVPhotoPreviewViewCell class]]) {
        [(DVPhotoPreviewViewCell *)cell recoverSubviews];
    }
//    else if ([cell isKindOfClass:[TZVideoPreviewCell class]]) {
//        TZVideoPreviewCell *videoCell = (TZVideoPreviewCell *)cell;
//        if (videoCell.player && videoCell.player.rate != 0.0) {
//            [videoCell pausePlayerAndShowNaviBar];
//        }
//    }
}

#pragma mark -- respon
- (void)didTapPreviewCell {
    _navView.hidden  = !_navView.hidden;
}

- (void)back:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark -- get set

- (UIView *)navView{
    if(!_navView){
        UIView * view = [[UIView alloc] initWithFrame:CGRectZero];
        view.backgroundColor = [UIColor grayColor];
        UIButton * backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, DVCommonTools.tz_isIPhoneX ? 44:20, 44, 44)];
        [backButton setTitle:@"返回" forState:UIControlStateNormal];
        [backButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
        [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:backButton];
        [self.view addSubview:view];
        _navView = view;
    }
    return _navView;
}

@end
