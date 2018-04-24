//
//  ZHDHomeViewController.m
//  myZhiHuDaily
//
//  Copyright © 2016年 刘 晓东. All rights reserved.
//

#import "ZHDHomeViewController.h"
#import "ZHDHttpProxy.h"
#import "ZHDHomeTableViewCell.h"
#import "ModelManager.h"
#import "ZHDHomeTitleBar.h"
#import "lxd_ParallaxTableViewHeader.h"
#import "HFStretchableTableHeaderView.h"
#import "ZHDSplashScreenController.h"
#import "ZHDDetailViewController.h"
#import "ZHDDetailContainerViewContoller.h"
#import "UIViewController+MMDrawerController.h"
#import "ZHDSlipMenuViewController.h"

#define StatusBarHeight 24
#define SectionHigh 40
#define CellHigh 88

@interface ZHDHomeViewController ()
{
    BOOL _isRequesting;
    CGFloat _headHeight;
}
@property (nonatomic, strong) lxd_ParallaxTableViewHeader *adPageView;
@property (nonatomic, strong) HFStretchableTableHeaderView* stretchableTableHeaderView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ZHDHomeTitleBar *titleBar;

@end

@implementation ZHDHomeViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    CGRect mainSreenBounds      = [[UIScreen mainScreen] bounds];
    _isRequesting               = NO;
    _headHeight                 = 220;
    _stretchableTableHeaderView = [HFStretchableTableHeaderView new];

    _adPageView = [[lxd_ParallaxTableViewHeader alloc] initWithFrame:CGRectMake(0, 0, mainSreenBounds.size.width , _headHeight) tapCallback:^(NSInteger index) {
        PKLog(@"ad index is %d" ,index);
        ModelTopStory *topstory = [[[ModelManager sharedModelManager] topStories] objectAtIndex:index];
        if (topstory) {
            NSDictionary *dic = [[ModelManager sharedModelManager] getStoryAndIndexPathByID:topstory.ID];
            [self gotoDetailPageByStory:[dic objectForKey:kModelStory] andIndexPath: [dic objectForKey:kIndexPath]];
        }
    }];
    
    _tableView                              = [[UITableView alloc] initWithFrame: mainSreenBounds style:UITableViewStylePlain];
    _tableView.backgroundColor              = [UIColor clearColor];
    _tableView.dataSource                   = self;
    _tableView.delegate                     = self;
    _tableView.contentInset                 = UIEdgeInsetsMake(-StatusBarHeight, 0.0, 0.0, 0.0);
    _tableView.separatorColor               = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.5];
    _tableView.separatorInset               = UIEdgeInsetsMake(0, 10, 0, 10);
    _tableView.separatorStyle               = UITableViewCellSeparatorStyleSingleLine;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.userInteractionEnabled       = YES;

    [_stretchableTableHeaderView stretchHeaderForTableView:self.tableView withView:_adPageView];
    [self.view addSubview:_tableView];
    [[ModelManager sharedModelManager] load];
    
    __weak __typeof(self) wself = self;
    [[ZHDHttpProxy SharedProxy] requestLastNews:^(id data) {
        [wself.tableView reloadData];
        [wself.adPageView setAdWithImgUrls:[[ModelManager sharedModelManager] topStoriesImgUrls] andTitles:[[ModelManager sharedModelManager] topStoriesTitles]];
    } Failure:^(NSError *error) {
        ;
    }];
    
     UIColor* blue =[UIColor colorWithRed:1/255.0 green:131/255.0 blue:209/255.0 alpha:0];
     _titleBar = [[ZHDHomeTitleBar alloc] initWithFrame:CGRectMake(0, 0, mainSreenBounds.size.width, StatusBarHeight + SectionHigh) andStatusBarHeight:StatusBarHeight withBgColor:blue];
     [_titleBar setTitleText: @"今日热闻"];
    [self.view insertSubview:_titleBar atIndex:9999];
    [self setupLeftMenuButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    [self updateVisibleCell];
    [self setUpSlipMenuVC];
}

- (void)viewDidLayoutSubviews {
    [_stretchableTableHeaderView resizeView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [ModelManager sharedModelManager].zhdSections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ModelSection *modelSection = [[ModelManager sharedModelManager].zhdSections objectAtIndex:section] ;
    return [modelSection  numberOfStories];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"ZHDHomeCell";
    ZHDHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (nil == cell) {
        cell = [[ZHDHomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    };
    ModelSection * section = [[ModelManager sharedModelManager].zhdSections objectAtIndex:indexPath.section];
    [cell setStory: [section.stories objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ModelSection *section = [[ModelManager sharedModelManager].zhdSections objectAtIndex:indexPath.section];
    ModelStory *story = [section.stories objectAtIndex:indexPath.row];
    [self gotoDetailPageByStory:story andIndexPath:indexPath];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_stretchableTableHeaderView scrollViewDidScroll:scrollView];
    UIColor* blue =[UIColor colorWithRed:1/255.0 green:131/255.0 blue:209/255.0 alpha:1];
    NSInteger n;
    if ([ModelManager sharedModelManager].zhdSections.count <= 0) {
        n = 0;
    }
    else{
        n = [[[ModelManager sharedModelManager].zhdSections objectAtIndex:0] numberOfStories];
    }
    if (scrollView.contentOffset.y < (_headHeight - self.view.bounds.size.width) ) {
        scrollView.contentOffset = CGPointMake(0, (_headHeight - self.view.bounds.size.width));
    }
    if (scrollView.contentOffset.y <300 ) { // 下拉300的时候 navigation 从完全透明渐变为不透明
        CGFloat alpha = 1- (240 - scrollView.contentOffset.y) / 240;
        [_titleBar zhd_setBackgroundColor:[blue colorWithAlphaComponent:alpha]];
    }
    else if (scrollView.contentOffset.y >=  (CellHigh * n + _headHeight - StatusBarHeight)) {//第二section 的header 达到顶端的时候 隐藏部分navigation
            _tableView.contentInset = UIEdgeInsetsMake(StatusBarHeight , 0.0, 0.0, 0.0);
            [self hiddenNavigation];
        }
    else{
            _tableView.contentInset = UIEdgeInsetsMake(0.0 , 0.0, 0.0, 0.0);
            [self showNavigation];
        
            [_titleBar zhd_setBackgroundColor:[blue colorWithAlphaComponent:1]];
        }
    NSArray *indexPaths = [self.tableView indexPathsForVisibleRows];
    if (nil == indexPaths || indexPaths.count <= 0) {
        return;
    }
    NSIndexPath *indexPath = [indexPaths objectAtIndex:0];
    if (indexPath.section  ==  ([ModelManager sharedModelManager].zhdSections.count -1) ) {
        if (NO == _isRequesting) {
            [self requestNextDayStories];
        }
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (0 == section) {
        UIView *cellHead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 0)];
        return cellHead;
    }
    UIView *cellHead          = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, SectionHigh)];
    UILabel *titleLbl         = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, tableView.frame.size.width, 30)];

    ModelSection *tempSection = [ModelManager sharedModelManager].zhdSections[section];
    titleLbl.text             = (section == 0 ? @"今日热闻" : [tempSection dateString]);
    titleLbl.font             = [UIFont systemFontOfSize:16];
    titleLbl.textAlignment    = NSTextAlignmentCenter;
    
    if (section == 0) {
        cellHead.backgroundColor = [UIColor clearColor];
        titleLbl.textColor = [UIColor clearColor];

    } else {
        cellHead.backgroundColor = [UIColor colorWithRed:1/255.0 green:131/255.0 blue:209/255.0 alpha:1];
        titleLbl.textColor = [UIColor whiteColor];
    }
    [cellHead addSubview:titleLbl];
    return cellHead;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CellHigh;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (0 == section) {
        return 0;
    }
    return SectionHigh;
}

#pragma mark - request

- (void)requestNextDayStories {
    _isRequesting = YES;
     __weak __typeof(self) wself = self;
    [[ZHDHttpProxy SharedProxy] requestStoriesByDate: [ModelManager sharedModelManager].earliestDate withBlock:^(id data) {
        if (nil != data) {
            [wself.tableView reloadData];
            wself.isRequesting = NO;
        }
    } Failure:^(NSError *error) {
        wself.isRequesting = NO;
    }];
}

#pragma mark - Navigation show and hidden
- (void)showNavigation {
    [_titleBar setTitleText: @"今日热闻"];
    [_titleBar zhd_showBar];
}

-( void)hiddenNavigation {
    [_titleBar setTitleText: @""];
    [_titleBar zhd_hiddenBar];
}

#pragma mark - Navigation push

- (void)gotoDetailPageByStory:(ModelStory *)story andIndexPath:(NSIndexPath *) indexPath {
    ZHDDetailViewController *detailVC = [[ZHDDetailViewController alloc] initWithStory:story];
    ZHDDetailContainerViewContoller *detailContainerVC = [[ ZHDDetailContainerViewContoller alloc] initWithShowedViewController:detailVC withIndexPath:indexPath];
    [detailContainerVC setModalTransitionStyle:UIModalTransitionStylePartialCurl];
    [self.navigationController pushViewController:detailContainerVC animated:YES];
    [self removeLeftMenu];
}

- (void)updateVisibleCell {
    NSArray *indexPaths = [_tableView indexPathsForVisibleRows];
    [_tableView beginUpdates];
    [_tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    [_tableView endUpdates];
}

- (void)setupLeftMenuButton {
    UIButton * leftDrawerButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 15, 50, 50)];
    [leftDrawerButton setImage:[UIImage imageNamed:@"ZHD.bundle/Home_Icon.png"] forState:UIControlStateNormal];
     [leftDrawerButton setImage:[UIImage imageNamed:@"ZHD.bundle/Home_Icon_Highlight.png"] forState:UIControlStateHighlighted];
    [leftDrawerButton addTarget:self action:@selector(leftDrawerButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.titleBar setLeftBtn:leftDrawerButton];
}

- (void)leftDrawerButtonPress:(id)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void)removeLeftMenu {
    [self.mm_drawerController setLeftDrawerViewController:nil];
    //self.mm_drawerController.recognizesPanning = NO;
}

- (void)setUpSlipMenuVC {
     UIViewController * vc = [[ZHDSlipMenuViewController alloc] init];
    [self.mm_drawerController setLeftDrawerViewController:vc];
    //self.mm_drawerController.recognizesPanning = YES;
}

@end
