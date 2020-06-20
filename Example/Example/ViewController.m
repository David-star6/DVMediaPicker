//
//  ViewController.m
//  Example
//
//  Created by 刘先生 on 2020/6/7.
//  Copyright © 2020 david. All rights reserved.
//

#import "ViewController.h"
#import <DVMediaPicker/DVMediaPickerContoller.h>
@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) NSArray * array;
@property (nonatomic, strong) UIButton * selectButton;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.selectButton];
}

- (void)viewDidLayoutSubviews {
    self.collectionView.frame = self.view.bounds;
    self.selectButton.frame = CGRectMake( (self.view.bounds.size.width - 200) /2, self.view.bounds.size.height - 200, 200, 40);
    self.selectButton.layer.cornerRadius = 8;
    self.selectButton.layer.masksToBounds = true;
}

- (void)openPickerController {
    
    DVMediaPickerContoller * vc = [[DVMediaPickerContoller alloc] initWithMaxImagesCount:4];
    __weak typeof(self) weakSelf = self;

    vc.selectBlock = ^(NSArray * photos, NSArray * assets) {
        weakSelf.array = photos;
        [weakSelf.collectionView reloadData];
    };
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:true completion:nil];
}


#pragma make -- delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotoCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[PhotoCell alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        cell.backgroundColor = [UIColor grayColor];
    }
    [cell setPhoto: self.array[indexPath.row]];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.array.count;
}


#pragma make -- git

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(100, 100);
        layout.minimumLineSpacing = 2;
        layout.minimumInteritemSpacing = 2;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[PhotoCell class] forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
}


- (UIButton *)selectButton {
    if (!_selectButton) {
        _selectButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_selectButton setTitle:@"选择照片" forState:UIControlStateNormal];
        _selectButton.backgroundColor = [UIColor grayColor];
        [_selectButton addTarget:self action:@selector(openPickerController) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectButton;
    
}
@end

@interface PhotoCell()

@property (nonatomic) UIImageView * image;

@end

@implementation PhotoCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.image = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, 100, 100)];
        [self addSubview:self.image];
        self.backgroundColor = [UIColor grayColor];
    }
    return self;
}


- (void)setPhoto:(UIImage *)image{
    self.image.image = image;
}

@end
