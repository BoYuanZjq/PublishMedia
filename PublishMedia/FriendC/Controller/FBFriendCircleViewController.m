//
//  FBFriendCircleViewController.m
//  PublishMedia
//
//  Created by derek on 2017/11/22.
//  Copyright © 2017年 derek. All rights reserved.
//

#import "FBFriendCircleViewController.h"

#import "UITableView+SDAutoTableViewCellHeight.h"
#import "UIView+SDAutoLayout.h"

#import "FBFriendCircleCell.h"
#import "FBFriendCommentModel.h"

static NSString *fbFriendCircleCell = @"FBFriendCircleCell";

@interface FBFriendCircleViewController ()<FBFriendCircleCellDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation FBFriendCircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.dataArray  = [[NSMutableArray alloc] init];
    FBFriendCommentModel *model = [[FBFriendCommentModel alloc] init];
    model.name = @"哈哈";
    model.msgContent = @"不醉不归";
    [self.dataArray addObject:model];
    
    //注册
    [self.tableView registerClass:[FBFriendCircleCell class] forCellReuseIdentifier:fbFriendCircleCell];
}

#pragma mark ====== UITableViewDelegate ======
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FBFriendCircleCell *cell = [tableView dequeueReusableCellWithIdentifier:fbFriendCircleCell];
    cell.indexPath = indexPath;
    __weak typeof(self) weakSelf = self;
    if (!cell.moreButtonClickedBlock) {
        [cell setMoreButtonClickedBlock:^(NSIndexPath *indexPath) {
            FBFriendCommentModel *model = weakSelf.dataArray[indexPath.row];
            model.isOpening = !model.isOpening;
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
        cell.delegate = self;
    }
    
    ////// 此步设置用于实现cell的frame缓存，可以让tableview滑动更加流畅 //////
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // >>>>>>>>>>>>>>>>>>>>> * cell自适应 * >>>>>>>>>>>>>>>>>>>>>>>>
    id model = self.dataArray[indexPath.row];
    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[FBFriendCircleCell class] contentViewWidth:[self cellContentViewWith]];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消
}
- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}

#pragma mark - FBFriendCircleCellDelegate
//点击喜欢
- (void)didClickLikeButtonInCell:(FBFriendCircleCell *)cell {
    
}
//点击评论
- (void)didClickcCommentButtonInCell:(FBFriendCircleCell *)cell {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
