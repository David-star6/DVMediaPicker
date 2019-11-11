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
}

#pragma mark -- delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DVAssetCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DVAssetCell" forIndexPath:indexPath];
    DVAssetModel * model = _models[indexPath.row];
    cell.backgroundColor = [UIColor grayColor];
    cell.model = model;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark -- Private Method

@end



@implementation DVCollectionView



@end
