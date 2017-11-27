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

#import "ChatKeyBoard.h"

#import "FcVisit.h"

static NSString *fbFriendCircleCell = @"FBFriendCircleCell";
static CGFloat textFieldH = 40;


@interface FBFriendCircleViewController ()<FBFriendCircleCellDelegate,ChatKeyBoardDelegate,ChatKeyBoardDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) ChatKeyBoard *chatKeyBoard;
@property (nonatomic, assign) float totalKeybordHeight;
@property (nonatomic, strong) NSIndexPath *currentEditingIndexthPath;

@end

@implementation FBFriendCircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.dataArray  = [[NSMutableArray alloc] init];
    [self initData];
    //注册
    [self.tableView registerClass:[FBFriendCircleCell class] forCellReuseIdentifier:fbFriendCircleCell];
    
    [self setupTextField];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    // 解决在iOS11上朋友圈demo文字收折或者展开时出现cell跳动问题
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    
}

- (void)setupTextField {
    _chatKeyBoard =[ChatKeyBoard keyBoardWithParentViewBounds:CGRectMake(0, 0, self.view.width_sd, [[UIScreen mainScreen] bounds].size.height)];
    _chatKeyBoard.delegate = self;
    _chatKeyBoard.dataSource = self;
    _chatKeyBoard.keyBoardStyle = KeyBoardStyleComment;
    _chatKeyBoard.allowVoice = NO;
    _chatKeyBoard.allowMore = NO;
    _chatKeyBoard.allowFace = NO;
    UIWindow *window =  [UIApplication sharedApplication].delegate.window;
    [window addSubview:_chatKeyBoard];
}
//获取数据
- (void)initData {
    __weak typeof(self)weakSelf = self;
    [FcVisit fc_get_list:@"11" withCategory:0 withDeviceId:@"SDFSKLDFSLKK" withDeviceType:1 withCateid:nil withRow:0 withReturnData:^(NSArray *dataArray, int responseCode) {
        weakSelf.dataArray = [dataArray mutableCopy];
        [weakSelf.tableView reloadData];
    } withFail:^(NSError *error, BOOL isNetError) {
        
    }];
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
    NSIndexPath *index = [self.tableView indexPathForCell:cell];
    FBFriendCommentModel *model = self.dataArray[index.row];
    __weak typeof(self)weakSelf = self;
    if (model.tr_ilike) {
        //取消点赞
        [FcVisit fc_ilike_u:@"11" withFc_tr_Id:model.fc_tr_id withAcstoken:@"xxxxx" withReturnData:^(BOOL isScuess, int responseCode) {
            if (isScuess) {
                [weakSelf like:NO withCommentModel:model withIndexPath:index];
            }
        } withFail:^(NSError *error, BOOL isNetError) {
            
        }];
    } else {
        [FcVisit fc_ilike:@"11" withFc_tr_Id:model.fc_tr_id withDeviceId:@"xxsdfsd" withU_icon:@"www.baidu.com" withAcstoken:@"xxxxxx" withReturnData:^(BOOL isScuess, int responseCode) {
            if (isScuess) {
                [weakSelf like:YES withCommentModel:model withIndexPath:index];
            }
        } withFail:^(NSError *error, BOOL isNetError) {
            
        }];
    }
}
// 点赞与取消点赞的方法
- (void)like:(BOOL)isLike withCommentModel:(FBFriendCommentModel*)commentModel withIndexPath:(NSIndexPath *)path{
    NSMutableArray *temp = [NSMutableArray arrayWithArray:commentModel.tr_ilikes];
    if (isLike) {
        FBFriendLikeModel *like = [[FBFriendLikeModel alloc] init];
        like.lk_u_id = @"11";
        like.userName = @"坚强";
        commentModel.tr_ilike = YES;
        [temp addObject:like];
    }else{
        commentModel.tr_ilike =  NO;
        FBFriendLikeModel *likeItem;
        for (FBFriendLikeModel *templikeItem in commentModel.tr_ilikes) {
            
            if ([templikeItem.lk_u_id isEqualToString:@"11"]) {
                likeItem = templikeItem;
            }
        }
        [temp removeObject:likeItem];
    }
    commentModel.tr_ilikes = [temp copy];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
    });
}
//点击评论
- (void)didClickcCommentButtonInCell:(FBFriendCircleCell *)cell {
   
    _currentEditingIndexthPath = [self.tableView indexPathForCell:cell];
    
    FBFriendCommentModel *model = [self.dataArray objectAtIndex:_currentEditingIndexthPath.row];
    self.chatKeyBoard.placeHolder = [NSString stringWithFormat:@"评论：%@",model.tr_u_name];
    [self.chatKeyBoard keyboardUpforComment];
}

#pragma mark -- ChatKeyBoardDelegate
- (void)chatKeyBoardSendText:(NSString *)text;
{
    if (text.length==0) {
        return;
    }
    [self.chatKeyBoard keyboardDownForComment];
    
    FBFriendCommentModel *model = self.dataArray[_currentEditingIndexthPath.row];
    NSMutableArray *temp = [NSMutableArray new];
    [temp addObjectsFromArray:model.tr_comments];
    __weak typeof(self)weakSelf = self;
    [FcVisit fc_reply:model.fc_tr_id withDeviceId:@"xxxxxx" withUserId:@"11" withUserName:@"坚强" withUIcon:@"www.baidu.com" withReplayId:nil withReplyuid:nil withreplyname:nil withreplyContent:text withAcstoken:@"xxxxx" withReturnData:^(BOOL isScuess, int responseCode) {
        if (isScuess) {
            FBFriendCommentItemModel *commentModel = [[FBFriendCommentItemModel alloc] init];
            commentModel.c_u_id = @"11";
            commentModel.c_u_name = @"坚强";
            [temp addObject:commentModel];
            model.tr_comments = [temp copy];
            
            [weakSelf.tableView reloadRowsAtIndexPaths:@[_currentEditingIndexthPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    } withFail:^(NSError *error, BOOL isNetError) {
        
    }];
}

#pragma mark -- ChatKeyBoardDataSource
- (NSArray<MoreItem *> *)chatKeyBoardMorePanelItems
{
    return nil;
}
- (NSArray<ChatToolBarItem *> *)chatKeyBoardToolbarItems
{
    //ChatToolBarItem *item1 = [ChatToolBarItem barItemWithKind:kBarItemFace normal:@"face" high:@"face_HL" select:@"keyboard"];
    return nil;//@[item1];
}
- (NSArray<FaceThemeModel *> *)chatKeyBoardFacePanelSubjectItems
{
    return nil;//[FaceSourceManager loadFaceSource];
}

- (void)keyboardNotification:(NSNotification *)notification
{
    NSDictionary *dict = notification.userInfo;
    CGRect rect = [dict[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    if(rect.origin.y<[UIScreen mainScreen].bounds.size.height)
    {
        self.totalKeybordHeight  = rect.size.height + 49;
        
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.currentEditingIndexthPath];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        //坐标转换
        CGRect rect = [cell.superview convertRect:cell.frame toView:window];
        
        CGFloat dis = CGRectGetMaxY(rect) - (window.bounds.size.height - _totalKeybordHeight);
        CGPoint offset = self.tableView.contentOffset;
        offset.y += dis;
        if (offset.y < 0) {
            offset.y = 0;
        }
        
        [self.tableView setContentOffset:offset animated:YES];
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.chatKeyBoard keyboardDownForComment];
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
