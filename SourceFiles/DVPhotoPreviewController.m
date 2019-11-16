//
//  DVPhotoPreviewController.m
//  DVMediaPicker
//
//  Created by jacob on 2019/11/16.
//  Copyright © 2019 david. All rights reserved.
//

#import "DVPhotoPreviewController.h"
#import "DVPhotoPreviewViewCell.h"

@interface DVPhotoPreviewController()<UICollectionViewDataSource,UICollectionViewDelegate> {
    UICollectionView *_collectionView;
    UICollectionViewFlowLayout *_layout;
    CGFloat _offsetItemCount;
}

@end

@implementation DVPhotoPreviewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configCollectionView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [UIApplication sharedApplication].statusBarHidden = YES;
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
}


#pragma mark -- delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DVAssetPreviewCell * cell;
    DVAssetModel *model = _models[indexPath.item];
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DVPhotoPreviewViewCell" forIndexPath:indexPath];
    cell.model = model;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
  
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
  
}

@end
