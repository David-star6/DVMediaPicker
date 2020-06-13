//
//  DVAlbumCell.m
//  DVMediaPicker
//
//  Created by jacob on 2019/11/9.
//  Copyright © 2019 david. All rights reserved.
//

#import "DVAlbumCell.h"

@implementation DVAlbumCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.backgroundColor = [UIColor whiteColor];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

@end
