//
//  ViewController.m
//  Example
//
//  Created by 刘先生 on 2020/6/7.
//  Copyright © 2020 david. All rights reserved.
//

#import "ViewController.h"
#import <DVMediaPicker/DVMediaPickerContoller.h>
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
    
}


@end
