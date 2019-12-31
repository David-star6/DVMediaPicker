//
//  DVRequestOperation.m
//  DVMediaPicker
//
//  Created by jacob on 2019/11/12.
//  Copyright © 2019 david. All rights reserved.
//

#import "DVRequestOperation.h"
#import "DVMediaManager.h"

@implementation DVRequestOperation

@synthesize executing = _executing;
@synthesize finished = _finished;

- (instancetype)initWithAsset:(PHAsset *)asset completion:(DVRequestCompletedBlock)completionBlock progressHandler:(DVRequestProgressBlock)progressHandler{
    self = [super init];
    self.asset = asset;
    self.completedBlock = completionBlock;
    self.progressBlock = progressHandler;
    _executing = NO;
    _finished = NO;
    return self;
}

- (void)start {
    self.executing = YES;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[DVMediaManager shareInstance] getPhotoWithAsset:self.asset completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded){
            if (!isDegraded) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (self.completedBlock) {
                        self.completedBlock(photo);
                    }
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self done];
                    });
                });
            }
        } progressHandler:^(double progress, NSError * _Nonnull error, BOOL * _Nonnull stop, NSDictionary * _Nonnull info) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.progressBlock) {
                    self.progressBlock(progress);
                }
            });
        } networkAccessAllowed:true];
    });
}


- (void)done {
    self.finished = YES;
    self.executing = NO;
    [self reset];
}

- (void)reset {
    self.asset = nil;
    self.completedBlock = nil;
    self.progressBlock = nil;
}

- (void)setFinished:(BOOL)finished {
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}

- (void)setExecuting:(BOOL)executing {
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

- (BOOL)isAsynchronous {
    return YES;
}
@end
