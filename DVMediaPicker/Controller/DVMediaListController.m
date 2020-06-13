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
#import "DVMediaPickerContoller.h"
#import "DVRequestOperation.h"
#import "UIView+Layout.h"

@interface DVMediaListController ()<UICollectionViewDataSource,UICollectionViewDelegate>{
    NSMutableArray *_models;
    UIButton *_doneButton;
    UIView *_bottomToolBar;
    UILabel *_numberLabel;
    UIImageView *_numberImageView;
}

@property (nonatomic, strong) DVCollectionView *collectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) NSOperationQueue *operationQueue;

@end

static CGFloat itemMargin = 5;

@implementation DVMediaListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = _model.name;
    
    [self configOperation];
}

- (void)configOperation{
    self.operationQueue = [[NSOperationQueue alloc] init];
    self.operationQueue.maxConcurrentOperationCount = 3;
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
    CGFloat toolBarHeight = [DVCommonTools tz_isIPhoneX] ? 83 : 50;
    collectionViewHeight = self.view.frame.size.height - toolBarHeight;

    _collectionView.frame = CGRectMake(0, top, self.view.frame.size.width, collectionViewHeight);
    CGFloat itemWH = (self.view.frame.size.width - (self.columnNumber + 1) * itemMargin) / self.columnNumber;
    _layout.itemSize = CGSizeMake(itemWH, itemWH);
    _layout.minimumInteritemSpacing = itemMargin;
    _layout.minimumLineSpacing = itemMargin;
    

    CGFloat toolBarTop = 0;
    toolBarTop = self.view.frame.size.height - toolBarHeight;
    _bottomToolBar.frame = CGRectMake(0, toolBarTop, self.view.frame.size.width, toolBarHeight);
    [_doneButton sizeToFit];
    _doneButton.frame = CGRectMake(self.view.frame.size.width - _doneButton.frame.size.width - 12, 0, _doneButton.frame.size.width, 50);
    _numberImageView.frame = CGRectMake(_doneButton.dv_left - 24 - 5, 13, 24, 24);
    _numberLabel.frame = _numberImageView.frame;

    
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
    [self configBottomToolBar];
}

- (void)configBottomToolBar {
    DVMediaPickerContoller *imagePickerVc = (DVMediaPickerContoller *)self.navigationController;
//    if (!tzImagePickerVc.showSelectBtn) return;
    
    _bottomToolBar = [[UIView alloc] initWithFrame:CGRectZero];
    CGFloat rgb = 253 / 255.0;
    _bottomToolBar.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1.0];
    

    _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _doneButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_doneButton addTarget:self action:@selector(doneButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_doneButton setTitle:@"done" forState:UIControlStateNormal];
    [_doneButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//
//    [_doneButton setTitle:tzImagePickerVc.doneBtnTitleStr forState:UIControlStateNormal];
//    [_doneButton setTitle:tzImagePickerVc.doneBtnTitleStr forState:UIControlStateDisabled];
//    [_doneButton setTitleColor:tzImagePickerVc.oKButtonTitleColorNormal forState:UIControlStateNormal];
//    [_doneButton setTitleColor:tzImagePickerVc.oKButtonTitleColorDisabled forState:UIControlStateDisabled];
//    _doneButton.enabled = tzImagePickerVc.selectedModels.count || tzImagePickerVc.alwaysEnableDoneBtn;
//
    _numberImageView = [[UIImageView alloc] initWithImage: [UIImage imageNamedFromBundle:@"ic_image_select"]];
    _numberImageView.hidden = imagePickerVc.selectedModels.count <= 0;
    _numberImageView.clipsToBounds = YES;
    _numberImageView.contentMode = UIViewContentModeScaleAspectFit;
    _numberImageView.backgroundColor = [UIColor clearColor];
    
    _numberLabel = [[UILabel alloc] init];
    _numberLabel.font = [UIFont systemFontOfSize:15];
    _numberLabel.adjustsFontSizeToFitWidth = YES;
    _numberLabel.textColor = [UIColor whiteColor];
    _numberLabel.textAlignment = NSTextAlignmentCenter;
    _numberLabel.text = [NSString stringWithFormat:@"%zd",imagePickerVc.selectedModels.count];
    _numberLabel.hidden = imagePickerVc.selectedModels.count <= 0;
    _numberLabel.backgroundColor = [UIColor clearColor];
    

    [_bottomToolBar addSubview:_numberImageView];
    [_bottomToolBar addSubview:_doneButton];
    [_bottomToolBar addSubview:_numberLabel];
    [self.view addSubview:_bottomToolBar];
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
    DVMediaPickerContoller *imagePickerVc = (DVMediaPickerContoller *)self.navigationController;
    DVAssetCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DVAssetCell" forIndexPath:indexPath];
    DVAssetModel * model = _models[indexPath.row];
    cell.photoDefImage = [UIImage imageNamedFromBundle:@"ic_image_ normal"];
    cell.photoSelImage = [UIImage imageNamedFromBundle:@"ic_image_select"];
    cell.model = model;
    if (model.isSelected) {
        cell.index =  [imagePickerVc.selectedAssetIds indexOfObject:model.asset.localIdentifier] + 1;
    }
    __strong typeof(cell) strongCell = cell;
    __weak typeof(self) weakSelf = self;
    cell.didSelectPhotoBlock = ^(BOOL isSelected){
        __strong typeof (weakSelf) strongSelf = weakSelf;
        DVMediaPickerContoller *imagePickerVc = (DVMediaPickerContoller *)weakSelf.navigationController;
        if(isSelected){
            strongCell.selectPhotoButton.selected = NO;
            model.isSelected = NO;
            NSArray *selectedModels = [NSArray arrayWithArray:imagePickerVc.selectedModels];
            for (DVAssetModel *model_item in selectedModels) {
                if ([model.asset.localIdentifier isEqualToString:model_item.asset.localIdentifier]) {
                    [imagePickerVc removeSelectedModel:model_item];
                    break;
                }
            };
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TZ_PHOTO_PICKER_RELOAD_NOTIFICATION" object:strongSelf.navigationController];
            [weakSelf refreshBottomToolBarStatus];
            [strongSelf->_models replaceObjectAtIndex:indexPath.row withObject:model];
         
        }else {
            strongCell.selectPhotoButton.selected = YES;
            model.isSelected = YES;
            [imagePickerVc addSelectedModel:model];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TZ_PHOTO_PICKER_RELOAD_NOTIFICATION" object:strongSelf.navigationController];
            [weakSelf refreshBottomToolBarStatus];
            [strongSelf->_models replaceObjectAtIndex:indexPath.row withObject:model];
        }
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DVMediaPickerContoller *imagePickerVc = (DVMediaPickerContoller *)self.navigationController;
    DVPhotoPreviewController * photoVc = [[DVPhotoPreviewController alloc] init];
    photoVc.models = [NSMutableArray arrayWithArray:_models];
    photoVc.photos = [NSMutableArray arrayWithArray:imagePickerVc.selectedModels];
    photoVc.currentIndex = indexPath.row;
    __strong typeof(self) strongSelf = self;
    [photoVc setSelectBlock:^(DVAssetModel * model, NSInteger index){
        [strongSelf.collectionView reloadData];
        [strongSelf refreshBottomToolBarStatus];
    }];
    __weak typeof(self) weakSelf = self;
    photoVc.doneCallBack = ^(){
        [weakSelf doneButtonClick];
    };
    [self.navigationController pushViewController:photoVc animated:true];
}

#pragma mark -- Click event

- (void)selectButtonRespond:(DVAssetModel *)mode{
    NSLog(@"-----%@",mode);
}

- (void)doneButtonClick{
    DVMediaPickerContoller *imagePickerVc = (DVMediaPickerContoller *)self.navigationController;

    [imagePickerVc showProgressHUD];
    
    NSMutableArray *assets = [NSMutableArray array];
    NSMutableArray *photos = [NSMutableArray array];;
    NSMutableArray *infoArr = [NSMutableArray array];
    for (NSInteger i = 0; i < imagePickerVc.selectedModels.count; i++) {
        [photos addObject:@1];
        [assets addObject:@1];
        [infoArr addObject:@1];
    }
    __block BOOL havenotShowAlert = YES;
    for (NSInteger i = 0; i < imagePickerVc.selectedModels.count; i++) {
        DVAssetModel *model = imagePickerVc.selectedModels[i];
        DVRequestOperation *operation = [[DVRequestOperation alloc] initWithAsset:model.asset completion:^(UIImage * _Nonnull photo) {
            if (photo) {
                [photos replaceObjectAtIndex:i withObject:photo];
            }
            [assets replaceObjectAtIndex:i withObject:model.asset];
            
            for (id item in photos) { if ([item isKindOfClass:[NSNumber class]]) return; }

            if (havenotShowAlert) {
                [self didGetAllPhotos:photos assets:assets infoArr:infoArr];
            }
        } progressHandler:^(double progress) {
            if (progress >= 1) {
                havenotShowAlert = YES;
            }
        }];
        [self.operationQueue addOperation:operation];
    }
}

- (void)didGetAllPhotos:(NSArray *)photos assets:(NSArray *)assets infoArr:(NSArray *)infoArr {
    DVMediaPickerContoller *imagePickerVc = (DVMediaPickerContoller *)self.navigationController;
    [imagePickerVc hideProgressHUD];
    imagePickerVc.selectBlock != nil ?  imagePickerVc.selectBlock(photos, assets) : NULL;
    [imagePickerVc dismissViewControllerAnimated:true completion:nil];
}


#pragma mark -- Private Method

- (void)refreshBottomToolBarStatus{
    DVMediaPickerContoller *imagePickerVc = (DVMediaPickerContoller *)self.navigationController;

    _numberImageView.hidden = imagePickerVc.selectedModels.count <= 0;
    _numberLabel.hidden = imagePickerVc.selectedModels.count <= 0;
    _numberLabel.text = [NSString stringWithFormat:@"%zd",imagePickerVc.selectedModels.count];
    
}


@end



@implementation DVCollectionView



@end

