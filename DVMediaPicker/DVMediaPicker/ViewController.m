//
//  ViewController.m
//  DVMediaPicker
//
//  Created by jacob on 2019/11/8.
//  Copyright © 2019 david. All rights reserved.
//

#import "ViewController.h"
#import "DVMediaPickerContoller.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        DVMediaPickerContoller * vc = [[DVMediaPickerContoller alloc] init];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:true completion:nil];
    });
    // Do any additional setup after loading the view, typically from a nib.
}


@end
