//
//  FBFcCommentCell.m
//  PublishMedia
//
//  Created by derek on 2017/11/24.
//  Copyright © 2017年 derek. All rights reserved.
//

#import "FBFcCommentCell.h"
#import <YYText/YYText.h>

@interface FBFcCommentCell()
/** 文本内容 */
@property (nonatomic , weak) YYLabel *contentLabel;
@end

@implementation FBFcCommentCell
- (instancetype)init
{
    self = [super init];
    if (self) {
        // 文本
        YYLabel *contentLabel = [[YYLabel alloc] init];
        contentLabel.numberOfLines = 0 ;
        contentLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:contentLabel];
        self.contentLabel = contentLabel;
    }
    return self;
}
- (void)setCommentModel:(FBFriendCommentItemModel *)commentModel {
    _commentModel = commentModel;
    self.contentLabel.attributedText = commentModel.attributedContent;
}
#pragma mark - override
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
