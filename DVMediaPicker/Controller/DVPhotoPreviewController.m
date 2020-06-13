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
#import "DVMediaPickerContoller.h"


@interface DVPhotoPreviewController()<UICollectionViewDataSource,UICollectionViewDelegate> {
    UICollectionView *_collectionView;
    UICollectionViewFlowLayout *_layout;
    CGFloat _offsetItemCount;
    UIButton *_selectButton;
    UIButton *_doneButton;
    UILabel *_numberLabel;
    NSArray *_photosTemp;
    UILabel *_indexLabel;
    UIImageView *_numberImageView;

}
@property (nonatomic, assign) BOOL isHideNaviBar;
@property (nonatomic, weak) UIView * navView;
@property (nonatomic, weak) UIView * toolBar;
@end

@implementation DVPhotoPreviewController

static CGFloat rgb = 34 / 255.0;

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self configCollectionView];
    [self configCustomNaviBar];
    [self configBottomToolBar];
    [self refreshNaviBarAndBottomBarState];
}


- (void)setPhotos:(NSMutableArray *)photos {
    _photos = photos;
    _photosTemp = [NSArray arrayWithArray:photos];
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

- (void)configBottomToolBar{
    _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _doneButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_doneButton addTarget:self action:@selector(doneButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [_doneButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    _numberImageView = [[UIImageView alloc] initWithImage: [UIImage imageNamedFromBundle:@"ic_image_select"]];
    _numberImageView.hidden = self.photos.count <= 0;
    _numberImageView.clipsToBounds = YES;
    _numberImageView.contentMode = UIViewContentModeScaleAspectFit;
    _numberImageView.backgroundColor = [UIColor clearColor];
    
    _numberLabel = [[UILabel alloc] init];
    _numberLabel.font = [UIFont systemFontOfSize:15];
    _numberLabel.adjustsFontSizeToFitWidth = YES;
    _numberLabel.textColor = [UIColor whiteColor];
    _numberLabel.textAlignment = NSTextAlignmentCenter;
    _numberLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.photos.count];
    _numberLabel.hidden = self.photos.count <= 0;
    _numberLabel.backgroundColor = [UIColor clearColor];
    [self.toolBar addSubview:_doneButton];
    [self.toolBar addSubview:_numberImageView];
    [self.toolBar addSubview:_numberLabel];

}

- (void)configCustomNaviBar{
    _selectButton = [[UIButton alloc] initWithFrame:CGRectZero];
    _selectButton.imageView.clipsToBounds = YES;
    _selectButton.imageEdgeInsets = UIEdgeInsetsMake(10, 0, 10, 0);
    _selectButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_selectButton setImage:[UIImage imageNamedFromBundle:@"ic_image_ normal"] forState:UIControlStateNormal];
    [_selectButton setImage:[UIImage imageNamedFromBundle:@"ic_image_select"] forState:UIControlStateSelected];
    [_selectButton addTarget:self action:@selector(select:) forControlEvents:UIControlEventTouchUpInside];
    _indexLabel = [[UILabel alloc] init];
    _indexLabel.adjustsFontSizeToFitWidth = YES;
    _indexLabel.font = [UIFont systemFontOfSize:14];
    _indexLabel.textColor = [UIColor whiteColor];
    _indexLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.navView addSubview:_selectButton];
    [self.navView addSubview:_indexLabel];

    
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
    
    CGFloat toolBarHeight = [DVCommonTools tz_isIPhoneX] ? 44 + 34 : 44;
    CGFloat toolBarTop = self.view.frame.size.height - toolBarHeight;
    _selectButton.frame = CGRectMake(self.view.frame.size.width - 56, DVCommonTools.tz_isIPhoneX ? 44:20, 44, 44);
    _indexLabel.frame = _selectButton.frame;
    self.navView.frame = CGRectMake(0, 0, self.view.frame.size.width, DVCommonTools.tz_isIPhoneX ? 88:64 );
    self.toolBar.frame = CGRectMake(0, toolBarTop,  self.view.frame.size.width,  toolBarHeight);
    [_doneButton sizeToFit];
    _doneButton.frame = CGRectMake(self.view.frame.size.width- _doneButton.frame.size.width - 12, 0, _doneButton.frame.size.width, 44);
    _numberImageView.frame = CGRectMake(_doneButton.frame.origin.x - 24 - 5, 10, 24, 24);
    _numberLabel.frame = _numberImageView.frame;
    
}


#pragma mark -- delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offSetWidth = scrollView.contentOffset.x;
    offSetWidth = offSetWidth +  ((self.view.frame.size.width + 20) * 0.5);
    
    NSInteger currentIndex = offSetWidth / (self.view.frame.size.width + 20);
    _currentIndex = currentIndex;
    [self refreshNaviBarAndBottomBarState];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DVAssetPreviewCell * cell;
    DVAssetModel *model = _models[indexPath.item];
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
    self.isHideNaviBar = !self.isHideNaviBar;
    _navView.hidden  = !_navView.hidden;
    _toolBar.hidden = !_toolBar.hidden;
}

- (void)back:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:true];
}

- (void)select:(UIButton *)sender{
    DVAssetModel * model = _models[self.currentIndex];
    DVMediaPickerContoller *imagePickerVc = (DVMediaPickerContoller *)self.navigationController;
    if (!sender.isSelected) {
        model.isSelected = true;
        [self.photos addObject:model];
        [imagePickerVc addSelectedModel:model];
    } else{
        model.isSelected = false;
        [self.photos removeObject:model];
        [imagePickerVc removeSelectedModel:model];

    }
    self.selectBlock(model,self.currentIndex);
    [self refreshNaviBarAndBottomBarState];
}

- (void)doneButtonClick:(UIButton *)sender{
    self.doneCallBack ?  self.doneCallBack() : nil;
}

#pragma mark -- Private Method

- (void)refreshNaviBarAndBottomBarState {
    DVAssetModel *model = _models[self.currentIndex];
    _selectButton.selected = model.isSelected;
    if (_selectButton.isSelected ) {
        NSString *index = [NSString stringWithFormat:@"%d", (int)(self.photos.count)];
        _indexLabel.text = index;
        _indexLabel.hidden = NO;
    } else {
        _indexLabel.hidden = YES;
    }

    _numberImageView.hidden = (_photos.count <= 0 || _isHideNaviBar);
    _numberLabel.text = [NSString stringWithFormat:@"%zd",_photos.count];
    _numberLabel.hidden = (_photos.count <= 0 || _isHideNaviBar);
}

#pragma mark -- get set

- (UIView *)navView{
    if(!_navView){
        UIView * view = [[UIView alloc] initWithFrame:CGRectZero];
        view.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:0.7];;
        UIButton * backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, DVCommonTools.tz_isIPhoneX ? 44:20, 44, 44)];
        
        [backButton setImage:[UIImage imageNamedFromBundle:@"nav_back"] forState:UIControlStateNormal];
        [backButton setImage:[UIImage imageNamedFromBundle:@"nav_back"] forState:UIControlStateHighlighted];
//        [backButton setTitle:@"返回" forState:UIControlStateNormal];
        [backButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
        [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:backButton];
        [self.view addSubview:view];
        _navView = view;
    }
    return _navView;
}

- (UIView *)toolBar{
    if(!_toolBar){
        UIView * view = [[UIView alloc] initWithFrame:CGRectZero];
        view.backgroundColor =  [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:0.7];
        [self.view addSubview:view];
        _toolBar = view;
    }
    return _toolBar;
}

@end
