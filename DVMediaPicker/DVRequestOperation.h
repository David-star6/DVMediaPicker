//
//  DVRequestOperation.h
//  DVMediaPicker
//
//  Created by jacob on 2019/11/12.
//  Copyright © 2019 david. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^DVRequestCompletedBlock)(UIImage *photo);
typedef void(^DVRequestProgressBlock)(double progress);


@interface DVRequestOperation : NSOperation

@property (nonatomic, copy ,nullable) DVRequestCompletedBlock completedBlock;
@property (nonatomic, copy, nullable) DVRequestProgressBlock progressBlock;
@property (nonatomic, strong, nullable) PHAsset *asset;

@property (assign, nonatomic, getter = isExecuting) BOOL executing;
@property (assign, nonatomic, getter = isFinished) BOOL finished;

- (instancetype)initWithAsset:(PHAsset *)asset completion:(DVRequestCompletedBlock)completionBlock progressHandler:(DVRequestProgressBlock)progressHandler;
- (void)done;

@end

NS_ASSUME_NONNULL_END
