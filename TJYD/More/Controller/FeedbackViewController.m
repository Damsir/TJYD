//
//  FeedbackViewController.m
//  TJYD
//
//  Created by 吴定如 on 17/4/1.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import "FeedbackViewController.h"
#import "FeedbackModel.h"
#import "FeedbackCell.h"
#import "FeedbackView.h"

static NSString *cellId = @"FeedbackCell";

@interface FeedbackViewController () <UITextViewDelegate>

@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableArray *timeArray;
@property (nonatomic,strong) NSMutableArray *IdArray;
@property (nonatomic,assign) NSInteger pageSize;
@property (nonatomic,assign) NSInteger pageIndex;
@property (nonatomic,strong) FeedbackView *feedbackView;
@property (nonatomic,strong) UITextView *adviceTextView;
@property (nonatomic,strong) UIButton *anonymityButton;/**< 匿名 */
@property (nonatomic,strong) UIButton *cancelButton;/**< 取消 */
@property (nonatomic,strong) UIButton *sendButton;/**< 立即发送 */
@property (nonatomic,strong) UIView *footView;
@property (nonatomic,strong) UIView *footLine;
@property (nonatomic,assign) NSInteger anonymity;

@end

@implementation FeedbackViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)dealloc {
    // 移除通知和监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNavigationBarTitle:@"系统反馈"];
    
    _anonymity = 1;
    _pageSize = 10;
    _pageIndex = 1;
    _timeArray = [NSMutableArray array];
    _IdArray = [NSMutableArray array];
    _dataArray = [NSMutableArray array];
    [self createTableViewAndFeedback];
    //[self loadData];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStyleDone target:self action:@selector(backToLastViewController)];
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addFeedback:)];

    //键盘唤起和隐藏的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self createNotification];
}

#pragma mark -- 屏幕旋转
- (void)createNotification {
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenRotation:) name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
}

- (void)screenRotation:(NSNotification *)noty {
    
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT-64-220);
    
    _footView.frame = CGRectMake(0, SCREEN_HEIGHT-220-64, SCREEN_WIDTH, 220);
    _footLine.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0.5);
    // 意见框
    _adviceTextView.frame = CGRectMake(10, 10, SCREEN_WIDTH-20, 120);
    // 匿名按钮
    _anonymityButton.frame = CGRectMake(SCREEN_WIDTH-80, CGRectGetMaxY(_adviceTextView.frame)+5, 70, 30);
    // 取消,立即反馈
    CGFloat btn_W = (SCREEN_WIDTH-30)/2;
    _cancelButton.frame = CGRectMake(10, CGRectGetMaxY(_anonymityButton.frame)+5, btn_W, 40);
    _sendButton.frame = CGRectMake(CGRectGetMaxX(_cancelButton.frame)+10, _cancelButton.frame.origin.y, btn_W, 40);

    _feedbackView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [_feedbackView screenRotation];
}

#pragma mark -- 加载数据
- (void)loadData {
    
    [MBProgressHUD showMessage:@"正在加载" toView:self.view];
    // 系统意见反馈列表
    NSString *ticket = [UserDefaults objectForKey:@"ticket"];
    NSString *des = [DES encryptUseDES:[[NSString stringWithFormat:@"action==noticeInfo/getSysResponseList.do?showType=my&queryFilter=&manageMoudle=&pageIndex=%ld&pageSize=%ld,%@",_pageIndex,_pageSize,ticket] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] key:Key];
    DistServiceAPI *api = [[DistServiceAPI alloc] initWithDes:des DistServiceActionType:DistServiceActionTypeGetSysResponseList requestMethod:DistRequestMethodPost arguments:nil];
    [api startWithCompletionBlockWithSuccess:^(__kindof DistBaseRequest *request) {
        
        NSDictionary *JsonDic = request.responseJSONObject;
        
        if ([[JsonDic objectForKey:@"state"] isEqualToString:@"true"]) {

            NSArray *resultArray = [JsonDic objectForKey:@"result"];
            //DLog(@"result::%@",resultArray);
            for (int i = 0; i < resultArray.count; i++) {
                NSMutableArray *listArray = [NSMutableArray array];
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setObject:[resultArray[i] objectForKey:@"NR"] forKey:@"NR"];
                [dic setObject:[resultArray[i] objectForKey:@"FBSJ"] forKey:@"FBSJ"];
                [dic setObject:[resultArray[i] objectForKey:@"ZXID"] forKey:@"ZXID"];
                [dic setObject:[resultArray[i] objectForKey:@"LX"] forKey:@"LX"];
                [dic setObject:[resultArray[i] objectForKey:@"NAME"] forKey:@"NAME"];
                [listArray addObject:dic];
//                [listArray addObject:[resultArray[i] objectForKey:@"NR"]];
                // 递归遍历
                [self recursionIndex:i dictionary:resultArray[i] array:listArray];
                
                [_timeArray addObject:[resultArray[i] objectForKey:@"FBSJ"]];
                [_IdArray addObject:[resultArray[i] objectForKey:@"ZXID"]];
            }
            //DLog(@"dataArray:%@",_dataArray);
            [self.tableView reloadData];
            // 加载更多
            BOOL loadMore = [JsonDic[@"result"][@"count"] integerValue] > _pageIndex * _pageSize;
            [self setLoadMoreData:loadMore];
            
            // 暂无数据
            _dataArray.count == 0 ? [self showEmptyData]: [self removeEmptyData] ;
            
        } else {
            // 单点登录超时(sessionTimeOut)
            [SingleLogin singleLoginActionWithSuccess:^(BOOL success) {
            }];
        }
        [self.tableView.header endRefreshing];
        //[self.tableView.footer endRefreshing];
        //加载提示框
        [MBProgressHUD hideHUDForView:self.view animated:NO];
    } failure:^(__kindof DistBaseRequest *request, NSError *error) {
        [self.tableView.header endRefreshing];
        //[self.tableView.footer endRefreshing];
        [MBProgressHUD hideHUDForView:self.view animated:NO];
    }];
}

#pragma mark -- 设置上拉加载更多
- (void)setLoadMoreData:(BOOL)loadMore {
    
    if (loadMore) {
        // 上拉加载更多
        [self.tableView.footer resetNoMoreData];
    } else {
        // 没有更多数据
        //self.tableView.footer = nil;
        [self.tableView.footer noticeNoMoreData];
    }
}

#pragma mark -- 递归
- (void)recursionIndex:(int)index dictionary:(NSDictionary *)dic array:(NSMutableArray *)listArray{
    
    if ([dic objectForKey:@"list"]) {
        
        for (int i = 0; i < [[dic objectForKey:@"list"] count]; i++) {
            
            NSMutableDictionary *replyDic = [NSMutableDictionary dictionary];
            [replyDic setObject:[[dic objectForKey:@"list"][i] objectForKey:@"FBSJ"] forKey:@"FBSJ"];
            [replyDic setObject:[[dic objectForKey:@"list"][i] objectForKey:@"ZXID"] forKey:@"ZXID"];
            [replyDic setObject:[[dic objectForKey:@"list"][i] objectForKey:@"LX"] forKey:@"LX"];
            
            // 拼接 "人员:回答" or "管理员:回答"
            if ([[[dic objectForKey:@"list"][i] objectForKey:@"LX"] isEqualToString:@"4"]) {
                [replyDic setObject:[NSString stringWithFormat:@"管理员: %@", [[dic objectForKey:@"list"][i] objectForKey:@"NR"]] forKey:@"NR"];
                [listArray addObject:replyDic];
            } else if ([[[dic objectForKey:@"list"][i] objectForKey:@"LX"] isEqualToString:@"3"]) {
                [replyDic setObject:[NSString stringWithFormat:@"%@: %@", [[dic objectForKey:@"list"][i] objectForKey:@"NAME"],[[dic objectForKey:@"list"][i] objectForKey:@"NR"]] forKey:@"NR"];
                [listArray addObject:replyDic];
            }
            
            
            [self recursionIndex:index dictionary:[dic objectForKey:@"list"][i] array:listArray];
        }
    } else {
        
        //number ++;
        
//        NSString *reply = [listArray componentsJoinedByString:@"\n"];
        
        NSMutableArray *replyArray = [NSMutableArray array];
        for (int j = 0; j < listArray.count; j++) {
            
            if (j == 0) {
                [replyArray addObject:[listArray[j] objectForKey:@"NR"]];
                
            } else {
                [replyArray addObject:[NSString stringWithFormat:@"%@  --  %@", [listArray[j] objectForKey:@"NR"],[listArray[j] objectForKey:@"FBSJ"]]];
            }
        }
        NSString *reply = [replyArray componentsJoinedByString:@"\n"];
        [_dataArray addObject:reply];
    }
    //DLog(@"_dataArray:%@",_dataArray);
}

#pragma mark -- 意见反馈界面和意见列表
- (void)createTableViewAndFeedback {
    
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT-64-220);
    self.tableView.delegate =self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:cellId bundle:nil] forCellReuseIdentifier:cellId];
    
    [self.view addSubview:self.tableView];
    
    // 下拉刷新
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [_dataArray removeAllObjects];
        _pageIndex = 1;
        [self loadData];
    }];
    // 上拉加载更多
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _pageSize ++;
        [self loadData];
    }];
    
    [self.tableView.header setAutoChangeAlpha:YES];
    [self.tableView.header beginRefreshing];
    
    //  --- Feedback ---
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-220-64, SCREEN_WIDTH, 220)];
    //footView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    //footView.backgroundColor = HOMETABLECOLOR;
    footView.backgroundColor = [UIColor whiteColor];
    _footView = footView;
    [self.view addSubview:footView];
    
    UIView *footLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    footLine.backgroundColor = GRAYCOLOR_MIDDLE;
    _footLine = footLine;
    [footView addSubview:footLine];
    
    // 意见框
    UITextView *adviceTextView = [[UITextView alloc] init];
    adviceTextView.frame = CGRectMake(10, 10, SCREEN_WIDTH-20, 120);
    adviceTextView.text = @"请输入反馈内容";
    adviceTextView.font = [UIFont systemFontOfSize:16.0];
    if ([adviceTextView.text isEqualToString:@"请输入反馈内容"])
    {
        adviceTextView.textColor = [UIColor lightGrayColor];
    }
    adviceTextView.layer.borderWidth = 0.5;
    adviceTextView.layer.borderColor = GRAYCOLOR_MIDDLE.CGColor;
    adviceTextView.layer.cornerRadius = 3;
    adviceTextView.clipsToBounds = YES;
    adviceTextView.returnKeyType = UIReturnKeyDone;
    adviceTextView.tintColor = HOMEBLUECOLOR;
    adviceTextView.delegate = self;
    _adviceTextView = adviceTextView;
    [footView addSubview:adviceTextView];
    
    // 匿名按钮
    UIButton *anonymityButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    button.backgroundColor = [UIColor orangeColor];
    anonymityButton.frame = CGRectMake(SCREEN_WIDTH-80, CGRectGetMaxY(adviceTextView.frame)+5, 70, 30);
    [anonymityButton setTitle:@"匿名" forState:UIControlStateNormal];
    [anonymityButton setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
    [anonymityButton setImageEdgeInsets:UIEdgeInsetsMake(5, 0, 5, 50)];
    //    [anonymityButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 20, 10)];
    anonymityButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [anonymityButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [anonymityButton addTarget:self action:@selector(buttonOnclick:) forControlEvents:UIControlEventTouchUpInside];
    _anonymityButton = anonymityButton;
    [footView addSubview:anonymityButton];
    
    // 取消,立即反馈
    CGFloat btn_W = (SCREEN_WIDTH-30)/2;
    
    UIButton *cancelButton = [self createCustomButtonWithTitle:@"取消"];
    cancelButton.frame = CGRectMake(10, CGRectGetMaxY(anonymityButton.frame)+5, btn_W, 40);
    [cancelButton addTarget:self action:@selector(cancelOnClick:) forControlEvents:UIControlEventTouchUpInside];
    _cancelButton = cancelButton;
    [footView addSubview:cancelButton];
    
    UIButton *sendButton = [self createCustomButtonWithTitle:@"立即反馈"];
    sendButton.frame = CGRectMake(CGRectGetMaxX(cancelButton.frame)+10, cancelButton.frame.origin.y, btn_W, 40);
    [sendButton addTarget:self action:@selector(sendOnClick:) forControlEvents:UIControlEventTouchUpInside];
    _sendButton = sendButton;
    self.sendButton.enabled = NO;
    self.sendButton.backgroundColor = [UIColor lightGrayColor];
    [footView addSubview:sendButton];
}

#pragma mark -- TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FeedbackCell *feedbackCell = [tableView dequeueReusableCellWithIdentifier:cellId];
    feedbackCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (_dataArray.count > indexPath.row) {
        
        feedbackCell.Date.text = _timeArray[indexPath.row];
        feedbackCell.Reply.text = _dataArray[indexPath.row];
//        QuestionModel *model = _dataArray[indexPath.row];
//        cell.userName.text = [NSString stringWithFormat:@"%@ · %@",model.userName,model.createDate];
//        cell.reply.text = _replyArray[indexPath.row];
        
        NSString *reply = _dataArray[indexPath.row];
        NSRange range = [reply rangeOfString:@"\n"];
        // NSLog(@"location:%ld length:%ld",range.location,range.length);
        if (range.location != NSNotFound) {
           // NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:reply];
            //UIFont *boldFont = [UIFont boldSystemFontOfSize:17.0];
            //[attr addAttribute:NSFontAttributeName value:boldFont range:NSMakeRange(0, 3)];
            //[attr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,range.location+1)];
            //feedbackCell.Reply.attributedText = attr;
            
            //
            NSDictionary *atrrDic = [self getAttributeDicWithFont:[UIFont systemFontOfSize:14.0]];
            NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:reply attributes:atrrDic];
            [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,range.location+1)];
            feedbackCell.Reply.attributedText = attributeStr;
            
        } else if (range.location == NSNotFound) {
            
            //NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:reply];
            //UIFont *boldFont = [UIFont boldSystemFontOfSize:17.0];
            //[attr addAttribute:NSFontAttributeName value:boldFont range:NSMakeRange(0, 3)];
            //[attr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,reply.length)];
            //feedbackCell.Reply.attributedText = attr;
            
            //
            NSDictionary *atrrDic = [self getAttributeDicWithFont:[UIFont systemFontOfSize:14.0]];
            NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:reply attributes:atrrDic];
            [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,reply.length)];
            feedbackCell.Reply.attributedText = attributeStr;
        }
        
        // 回复
//        cell.replyButton.tag = indexPath.row;
//        [cell.replyButton addTarget:self action:@selector(replyRequestion:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return feedbackCell;
}

#pragma mark -- 设置UILabel行间距和字间距(颜色等没有设置)
- (NSDictionary *)getAttributeDicWithFont:(UIFont *)font {
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    // 设置行间距
    paraStyle.lineSpacing = 5.0;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    // 设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *atrrDic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@.0f};
                                                   
    return atrrDic;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_dataArray.count > indexPath.row) {
        CGFloat cellHeight = [self getSpaceCellHeightWithContent:_dataArray[indexPath.row] withFont:[UIFont systemFontOfSize:14.0] withWidth:SCREEN_WIDTH-80];
        cellHeight += 50.0;
        return cellHeight >= 70.0 ? cellHeight : 70.0;
    }
    return 70.0;
}
/*
#pragma mark -- 计算UILabel文字高度
- (CGFloat)getCellHeightWithContent:(NSString *)content withFont:(UIFont *)font withWidth:(CGFloat)width {
    
    CGRect rect = [content boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    return rect.size.height + 50.0;
}

#pragma mark -- 计算UILabel的高度(带有行间距的情况)
- (CGFloat)getSpaceCellHeightWithContent:(NSString *)content withFont:(UIFont *)font withWidth:(CGFloat)width {
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 5.0;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@.0f};
    
    CGSize size = [content boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    
    return size.height + 50.0;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark -- 匿名勾选与否
- (void)buttonOnclick:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected) {
        [button setImage:[UIImage imageNamed:@"unselect"] forState:UIControlStateNormal];
        _anonymity = 0;
    } else {
        [button setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
        _anonymity = 1;
    }
}

#pragma mark -- 取消
- (void)cancelOnClick:(UIButton *)button {
    
    if ([_adviceTextView.text isEqualToString:@""]) {
        
        _adviceTextView.textColor =[UIColor lightGrayColor];
        _adviceTextView.text = @"请输入反馈内容";
        [_adviceTextView resignFirstResponder];
    }
    
    //[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- 立即反馈
- (void)sendOnClick:(UIButton *)button {
    
    //NSDictionary *data = @{@"id":@"",@"title":@"",@"askAndAnswer":_adviceTextView.text,@"style":@"3",@"parentId":@"",@"anonymity":@"1"};
    NSString *data = [NSString stringWithFormat:@"{\"askAndAnswer\":\"%@\",\"style\":\"3\",\"anonymity\":\"%ld\"}",_adviceTextView.text,_anonymity];
    
    [MBProgressHUD showMessage:@"正在反馈" toView:self.view];
    // 提交系统反馈
    NSString *ticket = [UserDefaults objectForKey:@"ticket"];
    NSString *des = [DES encryptUseDES:[[NSString stringWithFormat:@"action==noticeInfo/saveSysResponse.do?data=%@&%@",data,ticket] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] key:Key];
    DistServiceAPI *api = [[DistServiceAPI alloc] initWithDes:des DistServiceActionType:DistServiceActionTypeSaveSysResponse requestMethod:DistRequestMethodPost arguments:nil];
    [api startWithCompletionBlockWithSuccess:^(__kindof DistBaseRequest *request) {
        
        NSDictionary *JsonDic = request.responseJSONObject;
        
        if ([[JsonDic objectForKey:@"state"] isEqualToString:@"true"]) {
            
            if ([[JsonDic objectForKey:@"result"] isEqualToString:@"保存成功"]) {
                [MBProgressHUD showSuccess:@"反馈成功"];
                
                [self loadData];
            } else {
                [MBProgressHUD showError:@"没有权限"];
            }
        } else {
            // 单点登录超时(sessionTimeOut)
            [SingleLogin singleLoginActionWithSuccess:^(BOOL success) {
            }];
        }
        //加载提示框
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        
        
    } failure:^(__kindof DistBaseRequest *request, NSError *error) {
        [MBProgressHUD showError:@"反馈失败"];
        [MBProgressHUD hideHUDForView:self.view animated:NO];
    }];
}

#pragma mark - UITextView Delegate Methods
//点击键盘右下角的键收起键盘
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        if (_adviceTextView.text.length == 0) {
            _adviceTextView.textColor =[UIColor lightGrayColor];
            _adviceTextView.text = @"请输入反馈内容";
        } else {
            _adviceTextView.textColor = [UIColor blackColor];
        }
        [textView resignFirstResponder];
    }
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    if ([textView.text isEqualToString:@"请输入反馈内容"]) {
        
        _adviceTextView.text = @"";
    }
    textView.textColor =[UIColor blackColor];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    if ([textView.text isEqualToString:@""]) {
        
        _adviceTextView.textColor =[UIColor lightGrayColor];
        _adviceTextView.text = @"请输入反馈内容";
    }
}

- (void)textViewDidChange:(UITextView *)textView {

    // 删除空格符
    //_adviceTextView.text = [_adviceTextView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    [self judgeAdviceEnable];
}

#pragma mark -- 判断输入内容是否有效
- (void)judgeAdviceEnable {
    
    if (![_adviceTextView.text isEqualToString:@"请输入反馈内容"] && ![_adviceTextView.text isEqualToString:@""]) {
        
        self.sendButton.enabled = YES;
        self.sendButton.backgroundColor = HOMEBLUECOLOR;
        
    } else {
        
        self.sendButton.enabled = NO;
        self.sendButton.backgroundColor = [UIColor lightGrayColor];
    }
}

// 键盘升起/隐藏
- (void)keyboardWillShow:(NSNotification *)noti {
    // 获取键盘弹出的动画时间
    CGFloat durtion = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGSize keyboardSize = [noti.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue].size ;
    //    CGFloat keyboard_h = keyboardSize.height;
    //NSLog(@"1=====%@",noti.userInfo[@"UIKeyboardFrameEndUserInfoKey"]);
    if (SCREEN_HEIGHT <= 1024) {
        
        [UIView animateWithDuration:durtion animations:^{
            
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
            CGRect footerFrame = _footView.frame;
            
            footerFrame.origin.y = SCREEN_HEIGHT==480? SCREEN_HEIGHT-_footView.frame.size.height-keyboardSize.height-64+45 : SCREEN_HEIGHT-_footView.frame.size.height-keyboardSize.height-64;
            
            _footView.frame = footerFrame;
        }];
    }
}

- (void)keyboardWillHide:(NSNotification *)noti {
    
    [self createNotification];
    // 获取键盘弹出的动画时间
    CGFloat durtion = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    //CGSize keyboardSize = [noti.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue].size ;
    //CGFloat keyboard_h = keyboardSize.height;
    //NSLog(@"2=====%f",keyboard_h);
    [UIView animateWithDuration:durtion animations:^{
        
        CGRect foorterFrame = _footView.frame;
        foorterFrame.origin.y = SCREEN_HEIGHT-220-64;
        _footView.frame = foorterFrame;
        
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [_adviceTextView resignFirstResponder];
}

#pragma mark -- 滑动删除
//设置右侧删除按钮的文字(默认是Delete)
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return @"删除";
}

// 删除数据源,更改界面(****单个删除****)
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // 删除单个cell
    
    [self deleteFeedback:indexPath.row];
}

#pragma mark -- 删除操作
- (void)deleteFeedback:(NSInteger)index {
    
    
    NSString *Id = _IdArray[index];
    NSString *ticket = [UserDefaults objectForKey:@"ticket"];
    NSString *des = [DES encryptUseDES:[[NSString stringWithFormat:@"action==noticeInfo/deleteSysResponse.do?id=%@,%@",Id,ticket] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] key:Key];
    DistServiceAPI *api = [[DistServiceAPI alloc] initWithDes:des DistServiceActionType:DistServiceActionTypeDeleteSysResponse requestMethod:DistRequestMethodPost arguments:nil];
    [api startWithCompletionBlockWithSuccess:^(__kindof DistBaseRequest *request) {
        
        NSDictionary *JsonDic = request.responseJSONObject;
        
        if ([[JsonDic objectForKey:@"state"] isEqualToString:@"true"]) {
            
            if ([[JsonDic objectForKey:@"result"] isEqualToString:@"删除成功"]) {
                [MBProgressHUD showSuccess:@"删除成功"];
                [_dataArray removeObjectAtIndex:index];
                [_IdArray removeObjectAtIndex:index];
            } else  {
                [MBProgressHUD showError:@"删除失败"];
            }
            [self.tableView reloadData];
            
        } else {
            // 单点登录超时(sessionTimeOut)
            [SingleLogin singleLoginActionWithSuccess:^(BOOL success) {
            }];
        }
    } failure:^(__kindof DistBaseRequest *request, NSError *error) {
        [MBProgressHUD showError:@"删除失败"];
        DLog(@"%@",error);
    }];
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}


#pragma mark -- 添加意见反馈
- (void)addFeedback:(UIBarButtonItem *)barButton {
    
    FeedbackView *feedbackView = [[FeedbackView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    feedbackView.sendOnClickBlock = ^(NSString *content,NSInteger anonymity) {
        
        //NSDictionary *data = @{@"id":@"",@"title":@"",@"askAndAnswer":_adviceTextView.text,@"style":@"3",@"parentId":@"",@"anonymity":@"1"};
        NSString *data = [NSString stringWithFormat:@"{\"askAndAnswer\":\"%@\",\"style\":\"3\",\"anonymity\":\"1\"}",content];
        
        [MBProgressHUD showMessage:@"正在反馈" toView:self.view];
        // 提交系统反馈
        NSString *ticket = [UserDefaults objectForKey:@"ticket"];
        NSString *des = [DES encryptUseDES:[[NSString stringWithFormat:@"action==noticeInfo/saveSysResponse.do?data=%@&%@",data,ticket] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] key:Key];
        DistServiceAPI *api = [[DistServiceAPI alloc] initWithDes:des DistServiceActionType:DistServiceActionTypeSaveSysResponse requestMethod:DistRequestMethodPost arguments:nil];
        [api startWithCompletionBlockWithSuccess:^(__kindof DistBaseRequest *request) {
            
            NSDictionary *JsonDic = request.responseJSONObject;
            
            if ([[JsonDic objectForKey:@"state"] isEqualToString:@"true"]) {
                
                if ([[JsonDic objectForKey:@"result"] isEqualToString:@"保存成功"]) {
                    [MBProgressHUD showSuccess:@"反馈成功"];
                    
                    
                } else {
                    [MBProgressHUD showError:@"没有权限"];

                }
            } else {
                // 单点登录超时(sessionTimeOut)
                [SingleLogin singleLoginActionWithSuccess:^(BOOL success) {
                }];
            }
            
            [self.tableView reloadData];
            //加载提示框
            [MBProgressHUD hideHUDForView:self.view animated:NO];
            
        } failure:^(__kindof DistBaseRequest *request, NSError *error) {
            [MBProgressHUD showError:@"反馈失败"];
            [MBProgressHUD hideHUDForView:self.view animated:NO];
        }];
    };
    
    _feedbackView = feedbackView;
    [feedbackView showInView:self.view.window.rootViewController.view animated:YES];
}

#pragma mark -- 返回
- (void)backToLastViewController {
    [self popToViewControllerWithDirection:AnimationDirectionLeft type:NO superNavi:self.navigationController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
