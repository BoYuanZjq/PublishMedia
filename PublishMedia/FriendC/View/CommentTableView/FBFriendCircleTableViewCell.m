//
//  FBFriendCircleTableViewCell.m
//  PublishMedia
//
//  Created by derek on 2017/11/28.
//  Copyright © 2017年 derek. All rights reserved.
//

#import "FBFriendCircleTableViewCell.h"
#import "FBFriendContactLabel.h"
#import "JGGView.h"
//#import "FBFriendOperationMenuView.h"
#import "FBOperationView.h"
#import "UITableViewCell+HYBMasonryAutoCellHeight.h"
#import <YYKit/YYKit.h>

NSString *const kSDTimeLineCellOperationButtonClickedNoc = @"SDTimeLineCellOperationButtonClickedNoc";

@interface FBFriendCircleTableViewCell() <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) FBFriendContactLabel *descLabel;

@property (nonatomic, strong) UIImageView *headImageView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *moreBtn;

@property (nonatomic, strong) UIButton *commentBtn;

@property (nonatomic, copy) NSIndexPath *indexPath;

@property (nonatomic, strong) FBFriendCommentModel *messageModel;

@property (nonatomic, strong) FBOperationView *operationMenu;

@end

@implementation FBFriendCircleTableViewCell

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (_operationMenu.isShowing) {
        _operationMenu.isShowing = NO;
    }
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        
        //头像
        self.headImageView = [[UIImageView alloc] init];
        self.headImageView.backgroundColor = [UIColor whiteColor];
        self.headImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.headImageView];
        [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(kGAP);
            make.width.height.mas_equalTo(kAvatar_Size);
        }];
        
        // nameLabel
        self.nameLabel = [UILabel new];
        [self.contentView addSubview:self.nameLabel];
        self.nameLabel.textColor = [UIColor colorWithRed:(54/255.0) green:(71/255.0) blue:(121/255.0) alpha:0.9];
        self.nameLabel.preferredMaxLayoutWidth = screenWidth - kGAP-kAvatar_Size - 2*kGAP-kGAP;
        self.nameLabel.numberOfLines = 0;
        self.nameLabel.font = [UIFont systemFontOfSize:14.0];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.headImageView.mas_right).offset(10);
            make.top.mas_equalTo(self.headImageView);
            make.right.mas_equalTo(-kGAP);
        }];
        
        // desc
        self.descLabel = [FBFriendContactLabel new];
        UITapGestureRecognizer *tapText = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapText)];
        [self.descLabel addGestureRecognizer:tapText];
        [self.contentView addSubview:self.descLabel];
        self.descLabel.preferredMaxLayoutWidth =screenWidth - kGAP-kAvatar_Size ;
        self.descLabel.lineBreakMode = NSLineBreakByCharWrapping;
        self.descLabel.numberOfLines = 0;
        self.descLabel.font = [UIFont systemFontOfSize:13.0];
        [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.nameLabel);
            make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(kGAP/2.0);
        }];
        
        //全文
        self.moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.moreBtn setTitle:@"全文" forState:UIControlStateNormal];
        [self.moreBtn setTitle:@"收起" forState:UIControlStateSelected];
        [self.moreBtn setTitleColor:[UIColor colorWithRed:92/255.0 green:140/255.0 blue:193/255.0 alpha:1.0] forState:UIControlStateNormal];
        [self.moreBtn setTitleColor:[UIColor colorWithRed:92/255.0 green:140/255.0 blue:193/255.0 alpha:1.0] forState:UIControlStateSelected];
        
        self.moreBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        self.moreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.moreBtn.selected = NO;
        [self.moreBtn addTarget:self action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.moreBtn];
        [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.descLabel);
            make.top.mas_equalTo(self.descLabel.mas_bottom);
        }];
        
        self.jggView = [JGGView new];
        [self.contentView addSubview:self.jggView];
        [self.jggView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.moreBtn);
            make.top.mas_equalTo(self.moreBtn.mas_bottom).offset(kGAP);
        }];
        
        self.commentBtn = [UIButton new];
        [self.commentBtn setImage:[UIImage imageNamed:@"AlbumOperateMore"] forState:UIControlStateNormal];
        [self.commentBtn addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.commentBtn];
        [self.commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.descLabel);
            make.top.mas_equalTo(self.jggView.mas_bottom).offset(kGAP);
            make.width.mas_equalTo(26);
            make.height.mas_equalTo(26);
        }];
        
        self.operationMenu = [FBOperationView new];
        [self.contentView addSubview:self.operationMenu];
        __weak typeof(self) weakSelf = self;
        _operationMenu.zanBtnClickBlock = ^{
            if ([weakSelf.delegate respondsToSelector:@selector(didClickLikeButtonInCell:wihtPathIndex:)]) {
                [weakSelf.delegate didClickLikeButtonInCell:weakSelf wihtPathIndex:weakSelf.indexPath];
            }
        };
        _operationMenu.commentBtnClickBlock = ^{
            if ([weakSelf.delegate respondsToSelector:@selector(didClickcCommentButtonInCell:wihtPathIndex:)]) {
                [weakSelf.delegate didClickcCommentButtonInCell:weakSelf wihtPathIndex:weakSelf.indexPath];
            }
        };
        [self.operationMenu mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.commentBtn.mas_left).offset(-3);
            make.height.equalTo(@36);
            make.centerY.equalTo(self.commentBtn.mas_centerY);
            make.width.equalTo(@0);
        }];
        
        self.tableView = [[UITableView alloc] init];
        self.tableView.scrollEnabled = NO;
        [self.tableView registerClass:[CommentCell1 class] forCellReuseIdentifier:@"CommentCell1"];
        [self.tableView registerNib:[UINib nibWithNibName:@"LikeUsersCell1" bundle:nil] forCellReuseIdentifier:@"LikeUsersCell1"];
        
        UIImage *image = [UIImage imageNamed:@"LikeCmtBg"];
        image = [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
        self.tableView.backgroundView = [[UIImageView alloc]initWithImage:image];
        [self.contentView addSubview:self.tableView];
        self.tableView.userInteractionEnabled = YES;
        self.tableView.backgroundView.userInteractionEnabled = YES;
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.jggView);
            make.top.mas_equalTo(self.commentBtn.mas_bottom).offset(kGAP);
            make.right.mas_equalTo(-kGAP);
        }];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.hyb_lastViewInCell = self.tableView;
        self.hyb_bottomOffsetToCell = kGAP;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveOperationButtonClickedNotification:) name:kSDTimeLineCellOperationButtonClickedNoc object:nil];
        
        
    }
    return self;
}

- (void)receiveOperationButtonClickedNotification:(NSNotification *)notification
{
    UIButton *btn = [notification object];
    
    if (btn != _commentBtn && _operationMenu.isShowing) {
        _operationMenu.isShowing = NO;
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    self.frame = self.frame;
    [self postOperationButtonClickedNotification];
    if (_operationMenu.isShowing) {
        _operationMenu.isShowing = NO;
    }
}

- (void)postOperationButtonClickedNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kSDTimeLineCellOperationButtonClickedNoc object:self.commentBtn];
}

- (void)configCellWithModel:(FBFriendCommentModel *)model indexPath:(NSIndexPath *)indexPath {
    self.indexPath = indexPath;
    self.nameLabel.text = model.tr_u_name;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.tr_u_icon] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    _messageModel = model;
    NSMutableParagraphStyle *muStyle = [[NSMutableParagraphStyle alloc]init];
    muStyle.lineSpacing = 3;//设置行间距离
    muStyle.alignment = NSTextAlignmentLeft;//对齐方式
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:model.tr_content];
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0] range:NSMakeRange(0, attrString.length)];
    
    [attrString addAttribute:NSParagraphStyleAttributeName value:muStyle range:NSMakeRange(0, attrString.length)];
    self.descLabel.attributedText = attrString;
    
    self.descLabel.highlightedTextColor = [UIColor blackColor];//设置文本高亮显示颜色，与highlighted一起使用。
    self.descLabel.highlighted = YES; //高亮状态是否打开
    self.descLabel.enabled = YES;//设置文字内容是否可变
    self.descLabel.userInteractionEnabled = YES;//设置标签是否忽略或移除用户交互。默认为NO
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:13.0],NSParagraphStyleAttributeName:muStyle};
    
    CGFloat h = [model.tr_content boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - kGAP-kAvatar_Size - 2*kGAP, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.height+0.5;
    
    if (h<=60) {
        [self.moreBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.descLabel);
            make.top.mas_equalTo(self.descLabel.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(0, 0));
        }];
    }else{
        [self.moreBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.descLabel);
            make.top.mas_equalTo(self.descLabel.mas_bottom);
        }];
    }
    
    if (model.isOpening) {//展开
        [self.descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.nameLabel);
            make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(kGAP/2.0);
            make.height.mas_equalTo(h);
        }];
    }else{//闭合
        [self.descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.nameLabel);
            make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(kGAP/2.0);
            make.height.mas_lessThanOrEqualTo(60);
        }];
    }
    self.moreBtn.selected = model.isOpening;
    
    CGFloat jgg_width = kScreenWidth-2*kGAP-kAvatar_Size-50;
    CGFloat image_width = (jgg_width-2*kGAP)/3;
    
    CGFloat jgg_height = 0.0;
    
    
    if (model.picNamesArray.count==0) {
        jgg_height = 0;
    }else if (model.picNamesArray.count<=3) {
        jgg_height = image_width;
    }else if (model.picNamesArray.count>3&&model.picNamesArray.count<=6){
        jgg_height = 2*image_width+kGAP;
    }else  if (model.picNamesArray.count>6&&model.picNamesArray.count<=9){
        jgg_height = 3*image_width+2*kGAP;
    }
    
    ///解决图片复用问题
    [self.jggView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.jggView.dataSource = model.picNamesArray;
    __weak __typeof(self) weakSelf= self;
    
    self.jggView.tapBlock = ^(NSInteger index, NSArray *dataSource) {

    };
    ///布局九宫格
    [self.jggView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.moreBtn);
        make.top.mas_equalTo(self.moreBtn.mas_bottom).offset(kGAP/2);
        make.size.mas_equalTo(CGSizeMake(jgg_width, jgg_height));
    }];
    
    CGFloat tableViewHeight = 0;
    for (id obj in model.tr_comments) {
        if ([obj isKindOfClass:[NSArray class]]) {
            
        }else{
            FBFriendCommentItemModel *commentModel = (FBFriendCommentItemModel *)obj;
            CGFloat cellHeight = [CommentCell1 hyb_heightForTableView:self.tableView config:^(UITableViewCell *sourceCell) {
                CommentCell1 *cell = (CommentCell1 *)sourceCell;
                [cell configCellWithModel:commentModel];
            } cache:^NSDictionary *{
                return @{kHYBCacheUniqueKey : commentModel.c_id,
                         kHYBCacheStateKey : @"",
                         kHYBRecalculateForStateKey : @(YES)};
            }];
            tableViewHeight += cellHeight;
        }
    }
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(tableViewHeight);
    }];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView reloadData];
}

#pragma mark- button event
- (void)tapText {
    
}
- (void)moreAction:(UIButton*)sender {
    
}
- (void)commentAction:(UIButton*)sender {
    [self postOperationButtonClickedNotification];
    _operationMenu.isShowing = !_operationMenu.isShowing;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row==0) {
        if (self.messageModel.tr_ilikes.count) {
            LikeUsersCell1 *likeUsersCell = [tableView dequeueReusableCellWithIdentifier:@"LikeUsersCell1" forIndexPath:indexPath];
            likeUsersCell.model = self.messageModel;
            likeUsersCell.tapNameBlock = ^(NSString* userID) {
              
            };
            return likeUsersCell;
        }
    }
    
    CommentCell1 *commentCell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell1" forIndexPath:indexPath];
    FBFriendCommentItemModel *model = self.messageModel.tr_comments[indexPath.row-1];
    [commentCell configCellWithModel:model];
    return commentCell;
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger num = self.messageModel.tr_comments.count + self.messageModel.tr_ilikes.count;
    return num;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0&&self.messageModel.tr_ilikes.count) {
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:13.0]};
        NSMutableAttributedString *mutablAttrStr = [[NSMutableAttributedString alloc]init];
        NSTextAttachment *attch = [[NSTextAttachment alloc] init];
        //定义图片内容及位置和大小
        attch.image = [UIImage imageNamed:@"Like"];
        attch.bounds = CGRectMake(0, -5, attch.image.size.width, attch.image.size.height);
        
        [mutablAttrStr insertAttributedString:[NSAttributedString attributedStringWithAttachment:attch] atIndex:0];
        
        for (int i = 0; i < self.messageModel.tr_ilikes.count; i++) {
            FBFriendLikeModel *friendModel = self.messageModel.tr_ilikes[i];
            
            [mutablAttrStr appendAttributedString:[[NSAttributedString alloc] initWithString:friendModel.lk_u_name]];
            if (i != self.messageModel.tr_ilikes.count - 1) {
                [mutablAttrStr appendAttributedString:[[NSAttributedString alloc] initWithString:@","]];
                
            }
        }
        [mutablAttrStr addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13.f]} range:NSMakeRange(0, mutablAttrStr.length)];
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = 0;
        [mutablAttrStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, mutablAttrStr.length)];
        
        CGFloat h = [mutablAttrStr.string boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - kGAP-kAvatar_Size - 2*kGAP, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.height+4;
        
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(self.tableView.contentSize.height+1+4);//4为tableView最后一个cell底部下面的空隙
        }];
        return h+1+10;//10为tableView最上面的箭头和文字的距离
    }
    FBFriendCommentItemModel *model = self.messageModel.tr_comments[indexPath.row-1];
    CGFloat cell_height = [CommentCell1 hyb_heightForTableView:self.tableView config:^(UITableViewCell *sourceCell) {
        CommentCell1 *cell = (CommentCell1 *)sourceCell;
        [cell configCellWithModel:model];
    } cache:^NSDictionary *{
        NSDictionary *cache = @{kHYBCacheUniqueKey : model.c_id,
                                kHYBCacheStateKey : @"",
                                kHYBRecalculateForStateKey : @(NO)};
        return cache;
    }];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.tableView.contentSize.height+2);//2为tableView最后一个CommentCell1底部下面的空隙
    }];
    
    
    return cell_height;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.indexPath = indexPath;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0) {
        if (self.messageModel.tr_ilikes.count) {
            return;
        }
    }
    
    FBFriendCommentItemModel *commentModel = self.messageModel.tr_comments[indexPath.row];
    CGFloat cell_height = [CommentCell1 hyb_heightForTableView:self.tableView config:^(UITableViewCell *sourceCell) {
        CommentCell1 *cell = (CommentCell1 *)sourceCell;
        [cell configCellWithModel:commentModel];
    } cache:^NSDictionary *{
        NSDictionary *cache = @{kHYBCacheUniqueKey : commentModel.c_id,
                                kHYBCacheStateKey : @"",
                                kHYBRecalculateForStateKey : @(NO)};
        return cache;
    }];
    
    
    if ([self.delegate respondsToSelector:@selector(passCellHeight:commentModel:commentCell:messageCell:)]) {
        CommentCell1 *commetCell =  (CommentCell1 *)[tableView cellForRowAtIndexPath:indexPath];
        [self.delegate passCellHeight:cell_height commentModel:commentModel commentCell:commetCell messageCell:self];
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
