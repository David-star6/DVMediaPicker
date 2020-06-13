//
//  DVMediaPickerContoller.m
//  DVMediaPicker
//
//  Created by jacob on 2019/11/9.
//  Copyright © 2019 david. All rights reserved.
//

#import "DVMediaPickerContoller.h"
#import "DVMediaListController.h"
#import "DVAlbumCell.h"
#import "DVMediaManager.h"
#import "DVAlbumModel.h"
#import "NSBundle+ImagePicker.h"

@interface DVMediaPickerContoller ()
{
    UIButton *_progressHUD;
    UIView *_HUDContainer;
    UILabel *_HUDLabel;
    UIActivityIndicatorView *_HUDIndicatorView;


}

@end

@implementation DVMediaPickerContoller

- (instancetype)init {
    self = [super init];
    if(self){
        self = [self initWithMaxImagesCount:9];
    }
    return self;
}

#pragma mark -- Layout
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat progressHUDY = CGRectGetMaxY(self.navigationBar.frame);
    _progressHUD.frame = CGRectMake(0, progressHUDY, self.view.frame.size.width, self.view.frame.size.height - progressHUDY);
    _HUDContainer.frame = CGRectMake((self.view.frame.size.width - 120) / 2, (_progressHUD.frame.size.height - 90 - progressHUDY) / 2, 120, 90);
    _HUDIndicatorView.frame = CGRectMake(45, 15, 30, 30);
    _HUDLabel.frame = CGRectMake(0,40, 120, 50);
    
}


#pragma

- (void)viewDidLoad{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationBar.barTintColor = [UIColor colorWithRed:(34/255.0) green:(34/255.0)  blue:(34/255.0) alpha:1.0];
    self.navigationBar.tintColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (instancetype)initWithMaxImagesCount:(NSInteger )cout{
    return [self initWithMaxImagesCount:cout columnNumber:4];
}

- (instancetype)initWithMaxImagesCount:(NSInteger)maxImagesCount columnNumber:(NSInteger)columnNumber{
    DVAlbumPickerController * vc = [[DVAlbumPickerController alloc] init];
    self = [super initWithRootViewController:vc];
    if(self){
        [self configDefaultSetting];
    }
    return self;
}

- (void)configDefaultSetting {
    self.timeout = 15;

}

- (void)showProgressHUD {
    if (!_progressHUD) {
        _progressHUD = [UIButton buttonWithType:UIButtonTypeCustom];
        [_progressHUD setBackgroundColor:[UIColor clearColor]];
        
        _HUDContainer = [[UIView alloc] init];
        _HUDContainer.layer.cornerRadius = 8;
        _HUDContainer.clipsToBounds = YES;
        _HUDContainer.backgroundColor = [UIColor darkGrayColor];
        _HUDContainer.alpha = 0.7;
        
        _HUDIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        
        _HUDLabel = [[UILabel alloc] init];
        _HUDLabel.textAlignment = NSTextAlignmentCenter;
        _HUDLabel.text = @"Processing...";
        _HUDLabel.font = [UIFont systemFontOfSize:15];
        _HUDLabel.textColor = [UIColor whiteColor];
        
        [_HUDContainer addSubview:_HUDLabel];
        [_HUDContainer addSubview:_HUDIndicatorView];
        [_progressHUD addSubview:_HUDContainer];
    }
    [_HUDIndicatorView startAnimating];
    UIWindow *applicationWindow;
    if ([[[UIApplication sharedApplication] delegate] respondsToSelector:@selector(window)]) {
        applicationWindow = [[[UIApplication sharedApplication] delegate] window];
    } else {
        applicationWindow = [[UIApplication sharedApplication] keyWindow];
    }
    [applicationWindow addSubview:_progressHUD];
    [self.view setNeedsLayout];
    
    // if over time, dismiss HUD automatic
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.timeout * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf hideProgressHUD];
    });
}

- (void)hideProgressHUD {
    if (_progressHUD) {
        [_HUDIndicatorView stopAnimating];
        [_progressHUD removeFromSuperview];
    }
}

#pragma mark -- event
- (void)cancelButtonClick{
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)addSelectedModel:(DVAssetModel *)model{
    [self.selectedModels addObject:model];
    [self.selectedAssetIds addObject:model.asset.localIdentifier];
}

- (void)removeSelectedModel:(DVAssetModel *)model{
    [self.selectedModels removeObject:model];
    [self.selectedAssetIds removeObject:model.asset.localIdentifier];
}

- (void)setMaxImagesCount:(NSInteger)maxImagesCount {
    _maxImagesCount = maxImagesCount;
}

- (NSMutableArray<DVAssetModel *> *)selectedModels{
    if(!_selectedModels){
        _selectedModels = [[NSMutableArray alloc] init];
    }
    return _selectedModels;
}

- (NSMutableArray *)selectedAssetIds{
    if(!_selectedAssetIds){
        _selectedAssetIds = [[NSMutableArray alloc] init];
    }
    return _selectedAssetIds;
}


@end


@interface DVAlbumPickerController ()<UITableViewDataSource,UITableViewDelegate> {
    UITableView * _tableView;
}
@property (nonatomic, strong) NSMutableArray *albumArr;
@end

@implementation DVAlbumPickerController

- (void)viewDidLoad{
    self.view.backgroundColor = [UIColor whiteColor];
    DVMediaPickerContoller *imagePickerVc = (DVMediaPickerContoller *)self.navigationController;
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:imagePickerVc action:@selector(cancelButtonClick)];
    self.navigationItem.rightBarButtonItem = cancelItem;
    [self configTableView];
}

- (void)configTableView{
    if(![[DVMediaManager shareInstance] authorizationStatusAuthorized]){
        return;
    }
    [[DVMediaManager shareInstance] getAllAlbums:true allowPickingImage:true completion:^(NSArray * _Nonnull arr) {
        self->_albumArr = [NSMutableArray arrayWithArray:arr];
        if (!self->_tableView) {
            self->_tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
            self->_tableView.rowHeight = 70;
            self->_tableView.backgroundColor = [UIColor redColor];
            self->_tableView.backgroundColor = [UIColor whiteColor];
            self->_tableView.tableFooterView = [[UIView alloc] init];
            self->_tableView.dataSource = self;
            self->_tableView.delegate = self;
            [self->_tableView registerClass:[DVAlbumCell class] forCellReuseIdentifier:@"AlbumCell"];
            [self.view addSubview:self->_tableView];
        } else {
            [self->_tableView reloadData];
        }
    }];
}

#pragma mark -- Layout

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat top = 0;
    CGFloat tableViewHeight = 0;
    CGFloat naviBarHeight = self.navigationController.navigationBar.frame.size.height;
    BOOL isStatusBarHidden = [UIApplication sharedApplication].isStatusBarHidden;
    BOOL isFullScreen = self.view.frame.size.height == [UIScreen mainScreen].bounds.size.height;
    if (self.navigationController.navigationBar.isTranslucent) {
        top = naviBarHeight;
        if (!isStatusBarHidden && isFullScreen) top += [DVCommonTools tz_statusBarHeight];
        tableViewHeight = self.view.frame.size.height - top;
    } else {
        tableViewHeight = self.view.frame.size.height;
    }
    _tableView.frame = CGRectMake(0, top, self.view.frame.size.width, tableViewHeight);
}


#pragma mark  --- tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _albumArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DVAlbumModel * model = _albumArr[indexPath.row];
    DVAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlbumCell"];
    cell.textLabel.text = model.name;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [DVMediaManager shareInstance].columnNumber = 4;
    DVMediaListController *vc = [[DVMediaListController alloc] init];
    vc.model = _albumArr[indexPath.row];
    vc.columnNumber = 4;
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end



@implementation DVCommonTools

+ (BOOL)tz_isIPhoneX {
    return (CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(375, 812)) ||
            CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(812, 375)) ||
            CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(414, 896)) ||
            CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(896, 414)));
}

+ (CGFloat)tz_statusBarHeight {
    return [self tz_isIPhoneX] ? 44 : 20;
}

// 获得Info.plist数据字典
+ (NSDictionary *)tz_getInfoDictionary {
    NSDictionary *infoDict = [NSBundle mainBundle].localizedInfoDictionary;
    if (!infoDict || !infoDict.count) {
        infoDict = [NSBundle mainBundle].infoDictionary;
    }
    if (!infoDict || !infoDict.count) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
        infoDict = [NSDictionary dictionaryWithContentsOfFile:path];
    }
    return infoDict ? infoDict : @{};
}

+ (BOOL)tz_isRightToLeftLayout {
    if (@available(iOS 9.0, *)) {
        if ([UIView userInterfaceLayoutDirectionForSemanticContentAttribute:UISemanticContentAttributeUnspecified] == UIUserInterfaceLayoutDirectionRightToLeft) {
            return YES;
        }
    } else {
        NSString *preferredLanguage = [NSLocale preferredLanguages].firstObject;
        if ([preferredLanguage hasPrefix:@"ar-"]) {
            return YES;
        }
    }
    return NO;
}


@end


@implementation UIImage (Bundle)
+ (UIImage *)imageNamedFromBundle:(NSString *)name{
    NSBundle *imageBundle = [NSBundle imagePickerBundle];
    name = [name stringByAppendingString:@"@2x"];
    NSString *imagePath = [imageBundle pathForResource:name ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    if (!image) {
        // 兼容业务方自己设置图片的方式
        name = [name stringByReplacingOccurrencesOfString:@"@2x" withString:@""];
        image = [UIImage imageNamed:name];
    }
    return image;
}

@end

