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
        
    }
    return self;
}

#pragma mark -- event
- (void)cancelButtonClick{
    NSLog(@"123");
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
    NSLog(@"%@",image);
    return image;
}

@end

