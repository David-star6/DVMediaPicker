# DVMediaPicker

一个ios选择图片和视频的组件

## Getting Started

选择图片以后，获取到完整的图片和资源

- 安装

```
pod 'DVMediaPicker'
```

- 使用
 ```
DVMediaPickerContoller * vc = [[DVMediaPickerContoller alloc] init];
__weak typeof(self) weakSelf = self;

vc.selectBlock = ^(NSArray * photos, NSArray * assets) {
    weakSelf.array = photos;
    [weakSelf.collectionView reloadData];
};
vc.modalPresentationStyle = UIModalPresentationFullScreen;
[self presentViewController:vc animated:true completion:nil];
```
