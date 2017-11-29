//
//  LikeUsersCell1.m
//  WeChat
//
//  Created by zhengwenming on 2017/9/23.
//  Copyright © 2017年 zhengwenming. All rights reserved.
//

#import "LikeUsersCell1.h"
#import "UILabel+TapAction.h"

@interface LikeUsersCell1 ()<MLLinkLabelDelegate>
@property(nonatomic,strong)NSMutableArray *likeUsersArray;

@property(nonatomic,strong)NSMutableArray *nameArray;
@end

@implementation LikeUsersCell1

-(NSMutableArray *)nameArray{
    if (_nameArray==nil) {
        _nameArray = [NSMutableArray array];
    }
    return _nameArray;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.likeUsersLabel.linkTextAttributes = @{NSForegroundColorAttributeName : [UIColor grayColor]};
    self.likeUsersLabel.numberOfLines = 0;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
-(void)setModel:(FBFriendCommentModel *)messageModel{
    _model = messageModel;
    _likeUsersArray = messageModel.tr_ilikes.mutableCopy;
    NSMutableAttributedString *mutablAttrStr = [[NSMutableAttributedString alloc]init];
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    //定义图片内容及位置和大小
    attch.image = [UIImage imageNamed:@"Like"];
    attch.bounds = CGRectMake(0, -5, attch.image.size.width, attch.image.size.height);
    //创建带有图片的富文本
    [mutablAttrStr insertAttributedString:[NSAttributedString attributedStringWithAttachment:attch] atIndex:0];
    
    for (int i = 0; i < messageModel.tr_ilikes.count; i++) {
        FBFriendLikeModel *model = messageModel.tr_ilikes[i];
        if (i > 0) {
            [mutablAttrStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"，"]];
        }
        if (!model.attributedContent) {
            model.attributedContent = [self generateAttributedStringWithLikeItemModel:model];
        }
        [mutablAttrStr appendAttributedString:model.attributedContent];
    }
    
    _likeUsersLabel.attributedText = [mutablAttrStr copy];
    
}
//点赞
- (NSMutableAttributedString *)generateAttributedStringWithLikeItemModel:(FBFriendLikeModel *)model
{
    NSString *text = model.lk_u_name;
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text];
    [attString setAttributes:@{NSForegroundColorAttributeName : [UIColor grayColor], NSLinkAttributeName : [NSString stringWithFormat:@"selected:%@",model.lk_u_id]} range:[text rangeOfString:model.lk_u_name]];
    
    return attString;
}

#pragma mark - MLLinkLabelDelegate

- (void)didClickLink:(MLLink *)link linkText:(NSString *)linkText linkLabel:(MLLinkLabel *)linkLabel
{
    NSLog(@"%@", link.linkValue);
    if ([link.linkValue hasPrefix:@"selected:"]) {
        //点赞：
        if (self.tapNameBlock) {
            NSArray *likeArr = [link.linkValue componentsSeparatedByString:@":"];
            self.tapNameBlock([likeArr lastObject]);
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
@end
