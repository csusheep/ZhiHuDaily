//
//  ZHDSlipMenuViewController.m
//  myZhiHuDaily
//
//  Created by 刘 晓东 on 16/4/8.
//  Copyright © 2016年 刘 晓东. All rights reserved.
//

#import "ZHDSlipMenuViewController.h"
#import "ZHDHttpProxy.h"
#import "ModelManager.h"
#import "ZHDMenuButton.h"

#define kDefaultUserLogoDir @"ZHD.bundle/Account_Avatar.png"
#define kDefaultUserLogoMaskDir @"ZHD.bundle/Account_Avatar_Box.png"
#define kFavBtnImgDir @"ZHD.bundle/Menu_Icon_Collect.png"
#define kMsgBtnImgDir @"ZHD.bundle/Menu_Icon_Message.png"
#define kSettingBtnImgDir @"ZHD.bundle/Menu_Icon_Setting.png"
#define kDefaultUserTitle @"请登录"

static const NSInteger logginBtnHight = 50;
static const NSInteger cellHigh = 40;
static const NSInteger btnW = 40;
static const NSInteger btnH = 40;

@interface ZHDSlipMenuViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *header;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) ZHDMenuButton *favButton;
@property (nonatomic, strong) UIButton *msgButton;
@property (nonatomic, strong) UIButton *settingButton;
@property (nonatomic, strong) UITableView *menuList;
@property (nonatomic, strong) UIImageView *userLogo;
@end

@implementation ZHDSlipMenuViewController

- (void)viewDidLoad {
    
    UIColor *bgcolor = [UIColor colorWithRed:35/256.0 green:42/256.0 blue:48/256.0 alpha:1];

    if (![self isLogin]) {
        _userLogo            = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kDefaultUserLogoDir ]];
        UIImage* userlogMask = [UIImage imageNamed:kDefaultUserLogoMaskDir];
        CALayer *maskLayer   = [CALayer layer];
        maskLayer.frame      = _userLogo.frame;
        maskLayer.contents   = (id)[userlogMask CGImage];
        [_userLogo.layer setMask:maskLayer];
        
        [self.view addSubview:_userLogo];
        UILabel *loginTitle  = [[UILabel alloc] init];
        loginTitle.font      = [UIFont systemFontOfSize:15];
        loginTitle.text      = kDefaultUserTitle;
        loginTitle.textColor = bgcolor;
        
        _menuList                 = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _menuList.backgroundColor = bgcolor;
        _menuList.separatorStyle  = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_menuList];
        [self.view setBackgroundColor:bgcolor];
    }
    
    
    _favButton  = [ZHDMenuButton buttonWithType:UIButtonTypeCustom];
    _favButton.frame = CGRectMake(0, logginBtnHight, btnW, btnH);
    UIImage *btnIcon = [UIImage imageNamed:kFavBtnImgDir];
    [_favButton setImage:btnIcon forState:UIControlStateNormal];
    [_favButton setTitle:NSLocalizedString(@"Favorites",@"Favorite") forState:UIControlStateNormal];
//    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, (btnH - btnIcon.size.height), 0);
//    _favButton.imageEdgeInsets = insets;
    [self.view addSubview:_favButton];
    
    _msgButton = [[UIButton alloc] initWithFrame:CGRectMake(btnW, logginBtnHight, btnW, btnH)];
    [_msgButton setImage:[UIImage imageNamed:kMsgBtnImgDir] forState:UIControlStateNormal];
    [_msgButton setTitle:NSLocalizedString(@"Messages",@"Messages") forState:UIControlStateNormal];
    [self.view addSubview:_msgButton];
    
    _settingButton = [[UIButton alloc] initWithFrame:CGRectMake(btnW * 2, logginBtnHight, btnW, btnH)];
    [_settingButton setImage:[UIImage imageNamed:kSettingBtnImgDir] forState:UIControlStateNormal];
    [_settingButton setTitle:NSLocalizedString(@"Settings",@"Settings") forState:UIControlStateNormal];
    [self.view addSubview:_settingButton];

    
    [[ZHDHttpProxy SharedProxy] requestThemeListwithBlock:^(id data) {
        ;
    } Failure:^(NSError *error) {
        ;
    }];
}

- (BOOL)isLogin {
    return NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [ModelManager sharedModelManager].zhdSections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    ModelSection *modelSection =  [[ModelManager sharedModelManager].zhdSections objectAtIndex:section] ;
    return [modelSection  numberOfStories];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *cellIdentifier = @"ZHDThemeCell";
    UITableViewCell *cell           = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    };
    
    ModelSection * section = [[ModelManager sharedModelManager].zhdSections objectAtIndex:indexPath.section];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ModelSection *section = [[ModelManager sharedModelManager].zhdSections objectAtIndex:indexPath.section];
    ModelStory *story     = [section.stories objectAtIndex:indexPath.row];
    
    ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHigh;
}



@end
