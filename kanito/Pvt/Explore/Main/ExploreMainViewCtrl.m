//
//  ExploreMainViewCtrl
//

#import "ExploreMainViewCtrl.h"
#import "GalleryItemCollectionViewCell.h"
#import "GalleryItemsLayout.h"

#import "ExploreDetailViewCtrl.h"

#import "MyRefreshControl.h"
#import "MyBaseViewController+ShowAlert.h"

#define maxCol 2

@interface ExploreMainViewCtrl () {
    NSInteger maxRec;
    NSInteger pagNum;
    CGFloat itemWidth;
    
    MyRefreshControl *myRefreshControl;
    BOOL isLoading;
}

@property (nonatomic, strong) NSMutableArray *itemsArray;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet GalleryItemsLayout *collectViewLayout;

@end

@implementation ExploreMainViewCtrl

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    myRefreshControl = [MyRefreshControl addToView:self.collectionView
                                            target:self
                                          selector:@selector(startFromPageOne)];
    
    self.collectViewLayout.dataSource = self;
    self.collectViewLayout.maxColumns = maxCol;
    self.collectViewLayout.horizontalInset = 2;
    self.collectViewLayout.verticalInset = 2;

    CGFloat inset = self.collectViewLayout.horizontalInset * (maxCol + 1);
    itemWidth = (self.view.frame.size.width - inset) / maxCol;
    [self startFromPageOne];
}

#pragma mark - Start

- (void) startFromPageOne {
    pagNum = 1;
    self.itemsArray = [NSMutableArray array];
    [self.collectViewLayout invalidateLayout];
    [self.collectionView reloadData];
    
    [self retrivePhotos];
    [myRefreshControl endRefreshing];
}

- (void) retrivePhotos {
    NSString *strId = [ClsUser userId];
    if (strId.length == 0)
        strId = @"";
    maxRec = (pagNum == 1) ? 20 : 10;


    MyHttpRequest *request = [MyHttpRequest pvtRequest];
    request.view = self.view;
    request.page = @"funsection/retrive-photos";
    request.json = @{
                     @"maxrecords": @(maxRec),
                     @"img_width" : @(itemWidth),
                     @"page"      : @(pagNum),
                     @"biz_id"    : strId
                     };
    
    [MyHttp httpRequest:request
             completion:^(BOOL succeeded, NSDictionary *resultDict) {
                 if (resultDict == nil)
                     maxRec = 0;
                 else
                     [self httpResult:resultDict];
             }];
}

- (void) httpResult:(NSDictionary *) dicJson {
    isLoading = NO;
    
    NSArray *photosArray = [dicJson getArray:@"photos"];
    if (photosArray.count < maxRec) {
        maxRec = 0;
    }
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 4;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSBlockOperation *completionOperation = [NSBlockOperation blockOperationWithBlock:^{
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.collectionView reloadData];
            [hud hideAnimated:YES];
        }];
    }];
    
    for (NSDictionary *dic in photosArray) {
        ExploreItemCls *item = [[ExploreItemCls alloc] init];
        item.itemDic = dic;
        [completionOperation addDependency:item.operation];
        [self.itemsArray addObject:item];
    }
    
    [queue addOperations:completionOperation.dependencies waitUntilFinished:NO];
    [queue addOperation:completionOperation];
}

#pragma mark - Next Page

- (void) scrollViewDidScroll:(UIScrollView*)scrollView {
    if (isLoading)
        return;
    if (maxRec == 0)
        return;
    if (scrollView.contentOffset.y < scrollView.frame.size.height)
        return;
    if (scrollView.contentOffset.y + scrollView.frame.size.height < scrollView.contentSize.height + 10)
        return;
    isLoading = YES;
    pagNum++;
    [self retrivePhotos];
}

#pragma mark - UICollectionViewDataSource

- (CGSize)getImageSizeAtIndexPath:(NSIndexPath *)indexPath {
    ExploreItemCls *item = self.itemsArray[indexPath.row];
    CGSize size = item.image.size;
    size.height += 65;
    return size;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.itemsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GalleryItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GalleryItemCollectionViewCell" forIndexPath:indexPath];
    cell.item = self.itemsArray[indexPath.row];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ExploreItemCls *item = self.itemsArray[indexPath.row];

    ExploreDetailViewCtrl *ctrl = [self.storyboard instantiateViewControllerWithIdentifier:@"ExploreDetailViewCtrl"];
    ctrl.dicData = item.itemDic;
    ctrl.imageDog = item.image;
    
    [self.navigationController showViewController:ctrl sender:self];
}

#pragma mark - Next Page

- (IBAction)btnGotoCam:(id)sender {
    
    NSString *s = [ClsUser uniqueId];
    if (s.length == 0) {
        [self showAlertWithTitle:keyLang(@"warning")
                         message:keyLang(@"explList.loginToUpload")];
        return;
    }
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"PvtUpload" bundle:nil];
    UIViewController *ctrl = [sb instantiateInitialViewController];
    [self.navigationController showViewController:ctrl sender:self];
}

@end
