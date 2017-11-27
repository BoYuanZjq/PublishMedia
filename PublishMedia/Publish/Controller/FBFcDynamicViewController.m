//
//  FBFcDynamicViewController.m
//  PublishMedia
//
//  Created by derek on 2017/11/21.
//  Copyright © 2017年 derek. All rights reserved.
//

#import "FBFcDynamicViewController.h"
#import "FBFcDynamicTopCell.h"
#import "FBFcDynamicBottomCell.h"

#import "FBFcDynamicModel.h"
#import "TZImagePickerController.h"
#import "UIView+Layout.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "TZImageManager.h"
#import "TZVideoPlayerController.h"
#import "TZPhotoPreviewController.h"
#import "TZGifPhotoPreviewController.h"
#import "TZLocationManager.h"

#import "FcVisit.h"
#import "JQOSSHelper.h"


#define K_Top_Cell @"FBFcDynamicTopCell"
#define K_Bottom_Cell @"FBFcDynamicBottomCell"

@interface FBFcDynamicViewController ()<FBFcDynamicTopCellDelegate,UITableViewDelegate,UITableViewDataSource,TZImagePickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextViewDelegate>
@property (nonatomic, strong) NSArray *dataAry;
@property (nonatomic, assign) CGFloat heightH;

@property (nonatomic, strong) FBFcDynamicModel *dynamicModel;
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;

@end

@implementation FBFcDynamicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view from its nib.
    [self.tableView registerClass:[FBFcDynamicTopCell class] forCellReuseIdentifier:K_Top_Cell];
    [self.tableView registerNib:[UINib nibWithNibName:@"FBFcDynamicBottomCell" bundle:nil] forCellReuseIdentifier:K_Bottom_Cell];
    self.tableView.tableFooterView = [UIView new];
    
    self.dynamicModel  = [[FBFcDynamicModel alloc] init];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setTitle:@"取消" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(closeEvent) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backItem;
    
    UIButton *sendButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [sendButton setTitle:@"发布" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *sendItem = [[UIBarButtonItem alloc] initWithCustomView:sendButton];
    self.navigationItem.rightBarButtonItem = sendItem;
    
}
//关闭
- (void)closeEvent {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)send {
    
    if (self.dynamicModel.picArray.count!=0) {
        // 先上传图片，在发表说说
        __weak typeof(self)weakSelf = self;
        [JQOSSHelper asyncUploadImages:self.dynamicModel.picArray complete:^(BOOL isSuccess, NSArray<NSString *> *remotePaths) {
            if (isSuccess) {
//                [weakSelf sendFriendC:[weakSelf toIosJSON:remotePaths]];
                [weakSelf sendFriendC:[weakSelf toPostString:remotePaths]];
            }else{
                NSLog(@"上传图片出错");
            }
        }];
    }else{
        [self sendFriendC:nil];
    }
}
- (void)sendFriendC:(NSString*)picJson {
    __weak typeof(self)weakSelf = self;
    //发布说说
    [FcVisit publish_fc:@"11" withUname:@"坚强" withUicon:@"www.baidu.com" withCateId:nil withTitle:nil withContent:self.dynamicModel.textStr withMedias:picJson withAccessToken:@"skkjlksdf" withReturnData:^(BOOL isScuess, int responseCode) {
        if (isScuess) {
            dispatch_async(dispatch_get_main_queue(), ^{
                 [weakSelf closeEvent];
            });
        }
    } withFail:^(NSError *error, BOOL isNetError) {
        
    }];
}
- (NSString*)toPostString:(NSArray*)array {
    NSString *str;
    for (int i=0; i<array.count; i++) {
        if (i==0) {
            str = [array objectAtIndex:i];
        }else{
            str = [str stringByAppendingString:[NSString stringWithFormat:@",%@",[array objectAtIndex:i]]];
        }
    }
    return str;
}

-(NSString *)toIosJSON:(id)aParam {
    
    NSData   *jsonData=[NSJSONSerialization dataWithJSONObject:aParam options:0 error:nil];
    NSString *jsonStr=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    jsonStr = [jsonStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return jsonStr;
}

#pragma mark ====== UITableViewDelegate ======
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else{
        return self.dataAry.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01;
    }else{
        return 10;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return self.heightH;
        }else{
            return 45;
        }
        
    } else {
        return 45;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            FBFcDynamicTopCell *cell = [tableView dequeueReusableCellWithIdentifier:K_Top_Cell forIndexPath:indexPath];
            cell.delegate = self;
            cell.indexPath = indexPath;
            cell.dataAry = self.dynamicModel.picArray;
            cell.textView.delegate = self;
            return cell;
        }else{
            FBFcDynamicBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:K_Bottom_Cell forIndexPath:indexPath];
            return cell;
        }
    }else{
        FBFcDynamicBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:K_Bottom_Cell forIndexPath:indexPath];
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消
}

#pragma mark - UIImagePickerController

- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS7Later) {
        // 无相机权限 做一个友好的提示
        if (iOS8Later) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
            [alert show];
        } else {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
        if (iOS7Later) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self takePhoto];
                    });
                }
            }];
        } else {
            [self takePhoto];
        }
        // 拍照之前还需要检查相册权限
    } else if ([TZImageManager authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
        if (iOS8Later) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
            [alert show];
        } else {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    } else if ([TZImageManager authorizationStatus] == 0) { // 未请求过相册权限
        [[TZImageManager manager] requestAuthorizationWithCompletion:^{
            [self takePhoto];
        }];
    } else {
        [self pushImagePickerController];
    }
}

// 调用相机
- (void)pushImagePickerController {
    // 提前定位
    __weak typeof(self) weakSelf = self;
    [[TZLocationManager manager] startLocationWithSuccessBlock:^(CLLocation *location, CLLocation *oldLocation) {
        
    } failureBlock:^(NSError *error) {
        
    }];
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerVc.sourceType = sourceType;
        if(iOS8Later) {
            _imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        }
        [self presentViewController:_imagePickerVc animated:YES completion:nil];
    } else {
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}
- (void)pushTZImagePickerController {
   
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    // imagePickerVc.navigationBar.translucent = NO;
    
#pragma mark - 五类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = YES;
    imagePickerVc.selectedAssets = self.dynamicModel.selectedAssets;
    
    imagePickerVc.allowTakePicture = NO; // 在内部显示拍照按钮
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = YES;
    imagePickerVc.allowPickingGif = NO;
    imagePickerVc.allowPickingMultipleVideo = NO; // 是否可以多选视频
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = YES;

    /// 5. 单选模式,maxImagesCount为1时才生效
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.allowCrop = NO;
    imagePickerVc.needCircleCrop = NO;
 
    imagePickerVc.isStatusBarDefault = NO;
#pragma mark - 到这里为止
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
//    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
//
//    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        [tzImagePickerVc showProgressHUD];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        // save photo and get asset / 保存图片，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image location:nil completion:^(NSError *error){
            if (error) {
                [tzImagePickerVc hideProgressHUD];
                NSLog(@"图片保存失败 %@",error);
            } else {
                [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES completion:^(TZAlbumModel *model) {
                    [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                        [tzImagePickerVc hideProgressHUD];
                        TZAssetModel *assetModel = [models firstObject];
                        if (tzImagePickerVc.sortAscendingByModificationDate) {
                            assetModel = [models lastObject];
                        }
                       [self refreshCollectionViewWithAddedAsset:assetModel.asset image:image];
                    }];
                }];
            }
        }];
    }
}

- (void)refreshCollectionViewWithAddedAsset:(id)asset image:(UIImage *)image {
   
    [self.dynamicModel.picArray addObject:image];
    [self.dynamicModel.selectedAssets addObject:asset];
    [self.tableView reloadData];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}


#pragma mark - FBFcDynamicTopCellDelegate
- (void)updateTableViewCellHeight:(FBFcDynamicTopCell *)cell andheight:(CGFloat)height andIndexPath:(NSIndexPath *)indexPath {
    if (self.heightH != height) {
        self.heightH = height;
        [self.tableView reloadData];
    }
}
- (void)addItem {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController * AV = [UIAlertController alertControllerWithTitle:@"提示" message:@"定位服务当前可能尚未打开，请设置打开！" preferredStyle:UIAlertControllerStyleActionSheet];
       
        [AV addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [AV addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           [self takePhoto];
        }]];
        [AV addAction:[UIAlertAction actionWithTitle:@"去相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self pushTZImagePickerController];
        }]];
        [self presentViewController:AV animated:YES completion:nil];
    });
}
/**
 * 点击UICollectionViewCell的代理方法
 */
- (void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:self.dynamicModel.selectedAssets selectedPhotos:self.dynamicModel.picArray index:indexPath.row];
    imagePickerVc.maxImagesCount = 9;
    imagePickerVc.allowPickingGif = NO;
    imagePickerVc.allowPickingOriginalPhoto = YES;
    imagePickerVc.allowPickingMultipleVideo = NO;
    imagePickerVc.isSelectOriginalPhoto = YES;

    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

/**
 删除一个图片
 */
- (void)didSelectCloseItemAtIndexPath:(int)index {
   
    [self.dynamicModel.picArray removeObjectAtIndex:index];
    [self.dynamicModel.selectedAssets removeObjectAtIndex:index];
    [self.tableView reloadData];

}

- (void)didMoveFromIndex:(NSIndexPath*)fromIndex toIndex:(NSIndexPath*)toIndex {
    
    UIImage *image = [self.dynamicModel.picArray objectAtIndex:fromIndex.row];
    [self.dynamicModel.picArray removeObjectAtIndex:fromIndex.row];
    [self.dynamicModel.picArray insertObject:image atIndex:toIndex.row];
    
    id asset = [self.dynamicModel.selectedAssets objectAtIndex:fromIndex.row];
    [self.dynamicModel.selectedAssets removeObjectAtIndex:fromIndex.row];
    [self.dynamicModel.selectedAssets insertObject:asset atIndex:toIndex.row];
    
    [self.tableView reloadData];
}
#pragma mark - TZImagePickerControllerDelegate
/// 用户点击了取消
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
}

// 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的代理方法
// 如果isSelectOriginalPhoto为YES，表明用户选择了原图
// 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
// photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    self.dynamicModel.picArray = [photos mutableCopy];
    self.dynamicModel.selectedAssets = [assets mutableCopy];
    [self.tableView reloadData];
}

// 如果用户选择了一个视频，下面的handle会被执行
// 如果系统版本大于iOS8，asset是PHAsset类的对象，否则是ALAsset类的对象
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {

  
}

// If user picking a gif image, this callback will be called.
// 如果用户选择了一个gif图片，下面的handle会被执行
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingGifImage:(UIImage *)animatedImage sourceAssets:(id)asset {
  
}

// Decide album show or not't
// 决定相册显示与否
- (BOOL)isAlbumCanSelect:(NSString *)albumName result:(id)result {
 
    return YES;
}

// Decide asset show or not't
// 决定asset显示与否
- (BOOL)isAssetCanSelect:(id)asset {
  
    return YES;
}
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        if (iOS7Later) {
            _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        }
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
        
    }
    return _imagePickerVc;
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    self.dynamicModel.textStr = textView.text;
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
