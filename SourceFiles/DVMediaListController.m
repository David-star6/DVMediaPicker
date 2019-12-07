//
//  DVMediaListController.m
//  DVMediaPicker
//
//  Created by jacob on 2019/11/11.
//  Copyright © 2019 david. All rights reserved.
//

#import "DVMediaListController.h"
#import "DVAssetCell.h"
#import "DVAlbumModel.h"
#import "DVPhotoPreviewController.h"

@interface DVMediaListController ()<UICollectionViewDataSource,UICollectionViewDelegate>{
    NSMutableArray *_models;
}
@property (nonatomic, strong) DVCollectionView *collectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *layout;

@end

static CGFloat itemMargin = 5;

@implementation DVMediaListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = _model.name;
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!_models) {
        [self fetchAssetModels];
    }
}

- (void)viewDidLayoutSubviews {
    CGFloat top = 0;
    CGFloat collectionViewHeight = 0;
    collectionViewHeight = self.view.frame.size.height;
    _collectionView.frame = CGRectMake(0, top, self.view.frame.size.width, collectionViewHeight);
    CGFloat itemWH = (self.view.frame.size.width - (self.columnNumber + 1) * itemMargin) / self.columnNumber;
    _layout.itemSize = CGSizeMake(itemWH, itemWH);
    _layout.minimumInteritemSpacing = itemMargin;
    _layout.minimumLineSpacing = itemMargin;
    [_collectionView setCollectionViewLayout:_layout];
}

- (void)fetchAssetModels {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self->_models = [NSMutableArray arrayWithArray:self->_model.models];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self initSubviews];
        });
    });
}
- (void)initSubviews {
    [self configCollectionView];
    if(self.model.models.count > 1){
        _collectionView.hidden = YES;
    };
}

- (void)configCollectionView {
    _layout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[DVCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.alwaysBounceHorizontal = NO;
    _collectionView.contentInset = UIEdgeInsetsMake(itemMargin, itemMargin, itemMargin, itemMargin);
    
  
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[DVAssetCell class] forCellWithReuseIdentifier:@"DVAssetCell"];
    [_collectionView registerClass:[DVAssetCameraCell class] forCellWithReuseIdentifier:@"DVAssetCameraCell"];
    __weak typeof(self) weakSelf = self;
    if(self.model.models.count <= 1){
        return;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:weakSelf.model.models.count-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:false];
        weakSelf.collectionView.hidden = false;
    });
}

#pragma mark -- delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DVAssetCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DVAssetCell" forIndexPath:indexPath];
    DVAssetModel * model = _models[indexPath.row];
    cell.model = model;
    __weak typeof(cell) weakCell = cell;
    __weak typeof(self) weakSelf = self;
    cell.didSelectPhotoBlock = ^(BOOL isSelected){
        [weakSelf selectButtonRespond];
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DVPhotoPreviewController * photoVc = [[DVPhotoPreviewController alloc] init];
    photoVc.models = _models;
    photoVc.currentIndex = indexPath.row;
    [self.navigationController pushViewController:photoVc animated:true];
}

#pragma mark -- Click event

- (void)selectButtonRespond{
    
}


#pragma mark -- Private Method

@end



@implementation DVCollectionView



@end

