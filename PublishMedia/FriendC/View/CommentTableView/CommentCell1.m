//
//  CommentCell1.m
//  WeChat
//
//  Created by zhengwenming on 2017/9/21.
//  Copyright © 2017年 zhengwenming. All rights reserved.
//

#import "CommentCell1.h"
#import "JGGView.h"
#import "UITableViewCell+HYBMasonryAutoCellHeight.h"
#import <YYKit/YYKit.h>
#import "NSString+Extension.h"
#import "FBFriendOperationMenuView.h"

@interface CommentCell1 ()
@property (nonatomic, strong) UILabel *contentLabel;
@end

@implementation CommentCell1

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //self.selectionStyle = UITableViewCellSelectionStyleNone;
        // contentLabel
        self.contentLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.contentLabel];
        self.contentLabel.backgroundColor  = [UIColor clearColor];
        self.contentLabel.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - kGAP-kAvatar_Size - 2*kGAP;
        self.contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.font = [UIFont systemFontOfSize:13.0];
        
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.contentView);
            make.top.mas_equalTo(self.contentView).offset(7.0);//cell上部距离为3.0个间隙
        }];
        self.backgroundColor = [UIColor clearColor];
        self.hyb_lastViewInCell = self.contentLabel;
        self.hyb_bottomOffsetToCell = 0.0;//cell底部距离为3.0个间隙
    }
    return self;
}
- (void)configCellWithModel:(FBFriendCommentItemModel *)model {
    NSString *str  = nil;
    if (model.c_rep_u_name.length!=0) {
        str= [NSString stringWithFormat:@"%@回复%@：%@",
              model.c_u_name, model.c_rep_u_name, model.c_rep_content];
    }else{
        str= [NSString stringWithFormat:@"%@：%@",
              model.c_u_name, model.c_content];
    }
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:str];
    NSMutableParagraphStyle *muStyle = [[NSMutableParagraphStyle alloc] init];
    
    if ([text.string isMoreThanOneLineWithSize:CGSizeMake(kScreenWidth-kGAP-kAvatar_Size-2*kGAP, CGFLOAT_MAX) font:[UIFont systemFontOfSize:13.0] lineSpaceing:5.0]) {//margin
        muStyle.lineSpacing = 5.0;//设置行间距离
    }else{
        muStyle.lineSpacing = CGFLOAT_MIN;//设置行间距离
    }
    
    [text addAttribute:NSParagraphStyleAttributeName value:muStyle range:NSMakeRange(0, text.length)];
    
    [text addAttribute:NSForegroundColorAttributeName
                 value:[UIColor orangeColor]
                 range:NSMakeRange(0, model.c_rep_u_name.length)];
    [text addAttribute:NSForegroundColorAttributeName
                 value:[UIColor orangeColor]
                 range:NSMakeRange(model.c_rep_u_name.length + 2, model.c_u_name.length)];
    self.contentLabel.attributedText = text;
}
@end

