//
//  DamTreeView.m
//  WZYD
//
//  Created by 吴定如 on 16/12/4.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "DamTreeView.h"
#import "DamPeopleHeadTableViewCell.h"
#import "KOTreeItem.h"
#import "RATreeView.h"
#import "DamPeopleSelectTableCell.h"

//屏幕大小
#define SCREEN                     [[UIScreen mainScreen] bounds]
//#define SCREEN_WIDTH               [[UIScreen mainScreen]bounds].size.width

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define ARROW_IMG   1070
#define RIGHT_IMG   1080
#define SELECT_BTN  1090
#define BOOKMARK_WORD_LIMT  250

@interface DamTreeView () <RATreeViewDelegate, RATreeViewDataSource>

@property (strong, nonatomic) NSArray *data;
@property (strong, nonatomic) id expanded;
@property (strong, nonatomic) RATreeView *treeView;
@property (strong, nonatomic) NSMutableArray *selectedArray; /**<存放选择内容数组*/
@property (strong, nonatomic) id item;
@property (strong, nonatomic) RATreeNodeInfo *treeInfo;
@property (assign, nonatomic) BOOL isFail;
@property (assign, nonatomic) BOOL isFirst;
@property (assign, nonatomic) BOOL isSelectBtn;
@property (assign, nonatomic) BOOL haveHeadView;
@property (assign, nonatomic) BOOL isEqualX;


@end

@implementation DamTreeView

@synthesize treeItems;
@synthesize selectedTreeItems;
@synthesize item0, item1_1, item1_1_1, item1_1_1_1;

+ (DamTreeView *)instanceView
{
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"DamTreeView" owner:nil options:nil];
    return [nibs objectAtIndex:0];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (DamTreeView *) initTreeWithFrame:(CGRect)rect dataArray:(NSArray *)nodeArray haveHiddenSelectBtn:(BOOL)isHidden haveHeadView:(BOOL)haveHeadView isEqualX:(BOOL)isEqualX
{
    self.frame = rect;
    self.selectedArray = [[NSMutableArray alloc] init];
    self.treeItems     = [[NSMutableArray alloc] init];
    self.groups = [[NSMutableArray alloc]init];
    
    self.backgroundColor = [UIColor clearColor];
    CGFloat treeViewY;
    if (haveHeadView) {
        treeViewY = 0;
    }
    else
    {
        treeViewY = - 40;
        //
        treeViewY = 0;
    }
    _treeView = [[RATreeView alloc] initWithFrame:CGRectMake(0, treeViewY, rect.size.width, rect.size.height)];
    
    
    UINib *headNib = [UINib nibWithNibName:@"DamPeopleHeadTableViewCell" bundle:nil];
    UINib *rowNib = [UINib nibWithNibName:@"DamPeopleSelectTableCell" bundle:nil];
    [_treeView registerNib:headNib forCellReuseIdentifier:headCellID];
    [_treeView registerNib:rowNib forCellReuseIdentifier:rowCellID];
    
    for (UIView *subS in _treeView.subviews)
    {
        if ([subS isKindOfClass:[UITableView class]])
        {
            subS.frame = CGRectMake(0, 0, self.frame.size.width, _treeView.frame.size.height);
        }
    }
    
    _treeView.delegate   = self;
    _treeView.dataSource = self;
    _treeView.separatorStyle = RATreeViewCellSeparatorStyleNone;
    [self addSubview:_treeView];
    
    self.nodeArray    = nodeArray;
    self.isSelectBtn  = isHidden;
    self.haveHeadView = haveHeadView;
    self.isEqualX     = isEqualX;
    
    [self treeDataSetting];
    if ([DamPeopleCellModel sharedPeople].node.count == 0)
    {
        self.isFirst = YES;
    }
    return self;
    
}
#pragma mark -- 屏幕旋转
- (void)screenRotation
{
    CGFloat treeViewY;
    if (self.haveHeadView) {
        treeViewY = 0;
    }
    else
    {
        //
        treeViewY = - 40;
        treeViewY = 0;
    }
    _treeView.frame = CGRectMake(0, treeViewY, self.frame.size.width, self.frame.size.height);
    //[_treeView reloadData];
}

#pragma mark -- 数据设置
- (void)treeDataSetting
{
    //根据自己的的数据源进行解析
    NSMutableArray *mutableOne = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.nodeArray.count; i ++)
    {
        NSArray *modelOneArray = [[self.nodeArray objectAtIndex:i] valueForKey:@"children"];
        NSMutableArray *mutabletwo = [[NSMutableArray alloc] init];
        
        for (int j = 0; j < modelOneArray.count; j ++)
        {
            NSArray *modelTwoArray = [[modelOneArray objectAtIndex:j] valueForKey:@"children"];
            NSMutableArray *mutableThree = [[NSMutableArray alloc] init];
            for (int k = 0; k < modelTwoArray.count; k ++)
            {
                NSArray *modelThreeArray = [[modelTwoArray objectAtIndex:k] valueForKey:@"children"];
                
                if (modelThreeArray.count == 0)
                {
                    DamPeopleCellModel *modelFour = [DamPeopleCellModel dataObjectWithNAME:[[modelTwoArray objectAtIndex:k] valueForKey:@"NAME"] MOBILEPHONE:[[modelTwoArray objectAtIndex:k] valueForKey:@"MOBILEPHONE"] FIXEDPHONE:[[modelTwoArray objectAtIndex:k] valueForKey:@"FIXEDPHONE"] LOGINNAME:[[modelTwoArray objectAtIndex:k] valueForKey:@"LOGINNAME"] ID:[[modelTwoArray objectAtIndex:k] valueForKey:@"ID"] PARENTID:[[modelTwoArray objectAtIndex:k] valueForKey:@"PARENTID"] SORTID:[[modelTwoArray objectAtIndex:k] valueForKey:@"SORTID"] DATATYPE:[[modelTwoArray objectAtIndex:k] valueForKey:@"DATATYPE"] children:nil];
                    modelFour.Id = [[modelTwoArray objectAtIndex:k] valueForKey:@"ID"];
                    modelFour.name = [[modelTwoArray objectAtIndex:k] valueForKey:@"NAME"];
                    modelFour.mobilePhone = [[modelTwoArray objectAtIndex:k] valueForKey:@"MOBILEPHONE"];
                    modelFour.dataType = [[modelTwoArray objectAtIndex:k] valueForKey:@"DATATYPE"];
                    
                    [mutableThree addObject:modelFour];
                    
                } else {
                    NSMutableArray *mutableFour = [[NSMutableArray alloc] init];
                    for (int l = 0; l < modelThreeArray.count; l ++)
                    {
                        DamPeopleCellModel *modelFour = [DamPeopleCellModel dataObjectWithNAME:[[modelThreeArray objectAtIndex:l] valueForKey:@"NAME"] MOBILEPHONE:[[modelThreeArray objectAtIndex:l] valueForKey:@"MOBILEPHONE"] FIXEDPHONE:[[modelThreeArray objectAtIndex:l] valueForKey:@"FIXEDPHONE"] LOGINNAME:[[modelThreeArray objectAtIndex:l] valueForKey:@"LOGINNAME"] ID:[[modelThreeArray objectAtIndex:l] valueForKey:@"ID"] PARENTID:[[modelThreeArray objectAtIndex:l] valueForKey:@"PARENTID"] SORTID:[[modelThreeArray objectAtIndex:l] valueForKey:@"SORTID"] DATATYPE:[[modelThreeArray objectAtIndex:l] valueForKey:@"DATATYPE"] children:nil];
                        modelFour.Id = [[modelThreeArray objectAtIndex:l] valueForKey:@"ID"];
                        modelFour.name = [[modelThreeArray objectAtIndex:l] valueForKey:@"NAME"];
                        modelFour.mobilePhone = [[modelThreeArray objectAtIndex:l] valueForKey:@"MOBILEPHONE"];
                        modelFour.dataType = [[modelThreeArray objectAtIndex:l] valueForKey:@"DATATYPE"];
                        [mutableFour addObject:modelFour];
                        
                    }
                    DamPeopleCellModel *modelThree = [DamPeopleCellModel dataObjectWithNAME:[[modelTwoArray objectAtIndex:k] valueForKey:@"NAME"] MOBILEPHONE:[[modelTwoArray objectAtIndex:k] valueForKey:@"MOBILEPHONE"] FIXEDPHONE:[[modelTwoArray objectAtIndex:k] valueForKey:@"FIXEDPHONE"] LOGINNAME:[[modelTwoArray objectAtIndex:k] valueForKey:@"LOGINNAME"] ID:[[modelTwoArray objectAtIndex:k] valueForKey:@"ID"] PARENTID:[[modelTwoArray objectAtIndex:k] valueForKey:@"PARENTID"] SORTID:[[modelTwoArray objectAtIndex:k] valueForKey:@"SORTID"] DATATYPE:[[modelTwoArray objectAtIndex:k] valueForKey:@"DATATYPE"] children:mutableFour];
                    [mutableThree addObject:modelThree];
                }
            }
            DamPeopleCellModel *modelTwo = [DamPeopleCellModel dataObjectWithNAME:[[modelOneArray objectAtIndex:j] valueForKey:@"NAME"] MOBILEPHONE:[[modelOneArray objectAtIndex:j] valueForKey:@"MOBILEPHONE"] FIXEDPHONE:[[modelOneArray objectAtIndex:j] valueForKey:@"FIXEDPHONE"] LOGINNAME:[[modelOneArray objectAtIndex:j] valueForKey:@"LOGINNAME"] ID:[[modelOneArray objectAtIndex:j] valueForKey:@"ID"] PARENTID:[[modelOneArray objectAtIndex:j] valueForKey:@"PARENTID"] SORTID:[[modelOneArray objectAtIndex:j] valueForKey:@"SORTID"] DATATYPE:[[modelOneArray objectAtIndex:j] valueForKey:@"DATATYPE"] children:mutableThree];
            [mutabletwo addObject:modelTwo];
        }
        DamPeopleCellModel *modelOne = [DamPeopleCellModel dataObjectWithNAME:[[self.nodeArray objectAtIndex:i] valueForKey:@"NAME"] MOBILEPHONE:[[self.nodeArray objectAtIndex:i] valueForKey:@"MOBILEPHONE"] FIXEDPHONE:[[self.nodeArray objectAtIndex:i] valueForKey:@"FIXEDPHONE"] LOGINNAME:[[self.nodeArray objectAtIndex:i] valueForKey:@"LOGINNAME"] ID:[[self.nodeArray objectAtIndex:i] valueForKey:@"ID"] PARENTID:[[self.nodeArray objectAtIndex:i] valueForKey:@"PARENTID"] SORTID:[[self.nodeArray objectAtIndex:i] valueForKey:@"SORTID"] DATATYPE:[[self.nodeArray objectAtIndex:i] valueForKey:@"DATATYPE"] children:mutabletwo];
        [mutableOne addObject:modelOne];
        
    }
    
    DamPeopleCellModel *model = [DamPeopleCellModel dataObjectWithNAME:@"选择收件人" MOBILEPHONE:@"MOBILEPHONE" FIXEDPHONE:@"FIXEDPHONE" LOGINNAME:@"LOGINNAME" ID:@"ID" PARENTID:@"PARENTID" SORTID:@"SORTID" DATATYPE:@"DATATYPE" children:mutableOne];

    self.data = [NSArray arrayWithObject:model];
    [_treeView reloadData];
}

#pragma mark TreeView Data Source
- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    DamPeopleHeadTableViewCell *headCell = [_treeView dequeueReusableCellWithIdentifier:headCellID];
    DamPeopleSelectTableCell *rowCell = [_treeView dequeueReusableCellWithIdentifier:rowCellID];
    
    if (headCell == nil){
        headCell = [[DamPeopleHeadTableViewCell alloc] init];
    }
    if (rowCell == nil) {
        rowCell = [[DamPeopleSelectTableCell alloc] init];
    }
    
    if (!_haveHeadView) {
        headCell.choseConnectImage.hidden = YES;
        headCell.choseConnectLabel.hidden = YES;
        headCell.choseCountLabel.hidden   = YES;
        headCell.lineView.hidden          = YES;
        headCell.backgroundColor = [UIColor clearColor];
    }
    
    headCell.selectionStyle = UITableViewCellSelectionStyleNone;
    //rowCell.selectionStyle = UITableViewCellSelectionStyleNone;
//    rowCell.selectedBackgroundView = [[UIView alloc] initWithFrame:rowCell.bounds];
//    rowCell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:37.0/255.0 green:189.0/255.0 blue:21.0/255.0 alpha:1];
    
    /**
     *  返回选择的联系人个数
     */
    //headCell.choseCountLabel.text = [NSString stringWithFormat:@"(%ld)",(unsigned long)[[MKSelectArray sharedInstance] initObject].selectArray.count];
    headCell.choseCountLabel.text = [NSString stringWithFormat:@"(%ld)",(unsigned long)self.selectedArray.count];
    
    
    // 数据模型
    DamPeopleCellModel *peopleModel = treeNodeInfo.item;
    
    //标题
    if (_isEqualX) {
        rowCell.titleLabel.frame = CGRectMake(40 + 0 * treeNodeInfo.treeDepthLevel, 10, self.frame.size.width - 40 - 0 * treeNodeInfo.treeDepthLevel-50, 20);
    }
    else
    {
        if ([peopleModel.dataType isEqualToString:@"org"]) {
            rowCell.titleLabel.frame = CGRectMake(15 + 15 * treeNodeInfo.treeDepthLevel, 10, self.frame.size.width - 15 - 15 * treeNodeInfo.treeDepthLevel - 50, 20);
            rowCell.titleLabel_left.constant = 15 * treeNodeInfo.treeDepthLevel;
        } else if ([peopleModel.dataType isEqualToString:@"user"]) {
            rowCell.titleLabel.frame = CGRectMake(15 , 10, self.frame.size.width - 15 - 50, 20);
            rowCell.titleLabel_left.constant = 15 * 1;
        }
    }
    
    rowCell.titleLabel.font = [UIFont systemFontOfSize:15.0];
    // rowCell.titleLabel.textColor = [UIColor colorWithRed:0x33/255.f green:0x33/255.f blue:0x33/255.f alpha:1.0f];
    
    
    /**<树状展开的深度，层次级别*/
    if (treeNodeInfo.treeDepthLevel == 1) {
//        rowCell.titleLabel.textColor = [UIColor colorWithRed:0x22/255.f green:0x22/255.f blue:0x22/255.f alpha:1.0f];
        rowCell.titleLabel.textColor = BLUECOLOR;
    }
    else if(treeNodeInfo.treeDepthLevel == 2 && ![peopleModel.dataType isEqualToString:@"user"]) {
//        rowCell.titleLabel.textColor = [UIColor colorWithRed:0x66/255.f green:0x66/255.f blue:0x66/255.f alpha:1.0f];
        rowCell.titleLabel.textColor = BLUECOLOR;
    }
    else if(treeNodeInfo.treeDepthLevel == 3 && ![peopleModel.dataType isEqualToString:@"user"]) {
//        rowCell.titleLabel.textColor = [UIColor colorWithRed:0x88/255.f green:0x88/255.f blue:0x88/255.f alpha:1.0f];
        rowCell.titleLabel.textColor = BLUECOLOR;
    }
    else {
        //rowCell.titleLabel.textColor = [UIColor colorWithRed:0x0/255.f green:0x64/255.f blue:0x128/255.f alpha:1.0f];
        rowCell.titleLabel.textColor = [UIColor blackColor];
    }
    
    /**
     *  判断隐藏手机号,固话,下划线
     */
    if ([peopleModel.dataType isEqualToString:@"org"]) {
        rowCell.mobilePhone.hidden = rowCell.fixedPhone.hidden = rowCell.lineView.hidden = YES;
        rowCell.lineView_up.hidden = NO;
    } else if ([peopleModel.dataType isEqualToString:@"user"]) {
        rowCell.mobilePhone.hidden = rowCell.fixedPhone.hidden = rowCell.lineView.hidden = NO;
        rowCell.lineView_up.hidden = YES;
        // 赋值
        rowCell.mobilePhone.text = [NSString stringWithFormat:@"手机号: %@",peopleModel.mobilePhone];
        rowCell.fixedPhone.text = [peopleModel.fixedPhone isEqualToString:@""] ? @"": [NSString stringWithFormat:@"固话: %@",peopleModel.fixedPhone];
    }
    
    rowCell.titleLabel.textAlignment = NSTextAlignmentLeft;
    
    //去除掉首尾的空白字符和换行字符
    NSString *nameStr = ((DamPeopleCellModel *)item).name;
    nameStr = [nameStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    nameStr = [nameStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    nameStr = [nameStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    NSMutableString *titleStr = [NSMutableString stringWithString:nameStr];
    
    // 对cell进行赋值
    rowCell.titleLabel.text = titleStr;
    
    if (!self.isSelect) {
        headCell.choseConnectImage.image = [UIImage imageNamed:@"shousuo"];
    } else {
        [UIView animateWithDuration:0.f animations:^{
            headCell.choseConnectImage.transform = CGAffineTransformMakeRotation(M_PI * (180)/180);}];
    }
    headCell.choseConnectImage.tag = ARROW_IMG;

    
    //左侧勾选按钮(隐藏还是显示)
    if (!self.isSelectBtn) {
        /**<树状展开的深度，层次级别*/
        //        if (treeNodeInfo.treeDepthLevel == 1) {
        //            rowCell.chooseButton.frame = CGRectMake(15, 0, 26, 26);
        //            rowCell.titleLabel.frame = CGRectMake(CGRectGetMaxX(rowCell.chooseButton.frame)+20, 0, 26, 26);
        //
        //        }
        //        else if(treeNodeInfo.treeDepthLevel == 2){
        //            rowCell.chooseButton.frame = CGRectMake(15 + 26, -2, 26, 26);
        //            rowCell.titleLabel.frame = CGRectMake(CGRectGetMaxX(rowCell.chooseButton.frame)+20, 0, 26, 26);
        //        }
        //        else if (treeNodeInfo.treeDepthLevel == 3){
        //            rowCell.chooseButton.frame = CGRectMake(15 + 26*2, -2, 26, 26);
        //            rowCell.titleLabel.frame = CGRectMake(CGRectGetMaxX(rowCell.chooseButton.frame)+20, 0, 26, 26);
        //        }
        //rowCell.chooseButton.center = CGPointMake(rowCell.chooseButton.center.x, rowCell.titleLabel.center.y);

        rowCell.chooseButton.frame = CGRectMake(CGRectGetMinX(rowCell.titleLabel.frame)- 27 - 5, 10, 20, 20);
        
    }
    else
    {
        if (_isEqualX) {
            rowCell.titleLabel.frame = CGRectMake(10 + 0 * treeNodeInfo.treeDepthLevel, 10, self.frame.size.width - 10 - 0 * treeNodeInfo.treeDepthLevel-50, 20);
        }
        else
        {
            rowCell.titleLabel.frame = CGRectMake(10 + 25 * treeNodeInfo.treeDepthLevel, 10, self.frame.size.width - 10 - 25 * treeNodeInfo.treeDepthLevel-50, 20);
        }
        rowCell.chooseButton.hidden = YES;
    }
    
    //右侧三角箭头图标
    rowCell.arrowImageView.frame = CGRectMake(self.frame.size.width - 40, 10, 20, 20);
    if (treeNodeInfo.expanded == YES)
    {
        rowCell.arrowImageView.image = [UIImage imageNamed:@"zhankai"];
    }
    else
    {
        rowCell.arrowImageView.image = [UIImage imageNamed:@"shousuo"];
    }
    
    rowCell.arrowImageView.tag  = RIGHT_IMG;
    
    // 判断是否为最后一层(人员姓名)
    if ([peopleModel.dataType isEqualToString:@"org"])
    {
        rowCell.arrowImageView.hidden = NO;
        rowCell.callImage.hidden = YES;
    }
    else if ([peopleModel.dataType isEqualToString:@"user"])
    {
        rowCell.arrowImageView.hidden = YES;
        rowCell.callImage.hidden = NO;
    }
    rowCell.item = item;
    rowCell.treeNodeInfo = treeNodeInfo;
    rowCell.delegate = self;
    
    /**
     *   headCell 是否返回头部
     */
    if (treeNodeInfo.positionInSiblings == 0 && treeNodeInfo.treeDepthLevel == 0){
        return headCell;
    }
    
    //初始化的时候检查cell有没有被勾选
    DamPeopleCellModel *model = item;
    if (self.isSend)
    {
        model.isCheck = NO;
        rowCell.select = NO;
    }
    else
    {
        rowCell.select = model.isCheck;
    }
    return rowCell;
}

#pragma mark MKPeopleTableCellDelegate
- (void)treeTableViewCell:(DamPeopleSelectTableCell *)cell tapIconWithTreeItem:(id)item WithInfo:(RATreeNodeInfo *)treeNodeInfo
{
    self.isSend = NO;
    cell.select = !cell.select;
    [self recursion:treeNodeInfo index:treeNodeInfo.positionInSiblings treeTableViewCell:cell];
    
    if (cell.select == NO)
    {
        [self parent:treeNodeInfo treeTableViewCell:cell treeLever:treeNodeInfo.treeDepthLevel];
    }
    
    DamPeopleCellModel *model = treeNodeInfo.parent.item;
    NSArray *childArray = [model peoples];
    NSInteger selectCount = 0;
    
    for (int i = 0; i < childArray.count; i ++)
    {
        DamPeopleCellModel *model = [childArray objectAtIndex:i];
        if (model.isCheck)
        {
            selectCount ++;
        }
        if (selectCount == childArray.count)
        {
            [self childChangeParent:treeNodeInfo treeTableViewCell:cell treeLever:treeNodeInfo.treeDepthLevel childArray:childArray selectCount:selectCount];
        }
    }
    
    // 返回选择人员数组
    if (self.delegate && [self.delegate respondsToSelector:@selector(itemSelectArray:)]) {
        
        //[self.delegate itemSelectArray:[[MKSelectArray sharedInstance] initObject].selectArray];
        [self.delegate itemSelectArray:self.selectedArray];
    }
    /**
     *  刷新
     */
    // [self.treeView reloadData];
}

#pragma mark - Child节点选择改变父节点
- (id)childChangeParent:(RATreeNodeInfo*)treeNodeInfo treeTableViewCell:(DamPeopleSelectTableCell *)cell treeLever:(NSInteger)lever childArray:(NSArray *)childArray selectCount:(NSInteger)selectCount
{
    DamPeopleCellModel *model = treeNodeInfo.parent.item;
    if ([model.name isEqualToString:@"选择收件人"]) {
        return model.name;
    }
    else
    {
        if (selectCount != childArray.count)
        {
            return model.name;
        }
        else
        {
            DamPeopleCellModel *model = treeNodeInfo.parent.item;
            model.isCheck = cell.select;
            NSInteger selectCount = 0;
            
            DamPeopleCellModel *parentModel = [treeNodeInfo.parent parent].item;
            for (int i = 0; i < [parentModel peoples].count; i ++)
            {
                DamPeopleCellModel *childModel = [[parentModel peoples] objectAtIndex:i];
                if (childModel.isCheck)
                {
                    selectCount ++;
                }
            }
            [self childChangeParent:treeNodeInfo.parent treeTableViewCell:cell treeLever:(lever - 1) childArray:[parentModel peoples] selectCount:selectCount];
            return treeNodeInfo.parent;
        }
        
    }
    return nil;
}

#pragma maek - Parent节点
- (id)parent:(RATreeNodeInfo*)treeNodeInfo treeTableViewCell:(DamPeopleSelectTableCell *)cell treeLever:(NSInteger)lever
{
    DamPeopleCellModel *model = treeNodeInfo.parent.item;
    if ([model.name isEqualToString:@"选择收件人"]) {
        return model.name;
    }
    else
    {
        DamPeopleCellModel *model = treeNodeInfo.parent.item;
        model.isCheck = cell.select;
        [self parent:treeNodeInfo.parent treeTableViewCell:cell treeLever:(lever - 1)];
        return treeNodeInfo.parent;
    }
    return nil;
}

#pragma mark 递归
-(id)recursion:(RATreeNodeInfo*)treeNodeInfo index:(NSInteger)index treeTableViewCell:(DamPeopleSelectTableCell *)cell
{
    //    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    if ([treeNodeInfo children].count == 0)
    {
        DamPeopleCellModel *model = treeNodeInfo.item;
        model.isCheck = cell.select;
        if (model.name != nil)
        {
            // 判断点击的cell是否是user
            if ([model.dataType isEqualToString:@"user"]) {
                
                self.selectedArray = [NSMutableArray array];
                [self.selectedArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:model.mobilePhone, @"mobilePhone", model.name, @"name", model.fixedPhone, @"fixedPhone", nil]];
            }
            
//            if (cell.select == YES && (treeNodeInfo.treeDepthLevel == 3 || [model.dataType isEqualToString:@"org"]))
//            {
//                if (![self.selectedArray containsObject:[NSDictionary dictionaryWithObjectsAndKeys:model.Id, @"id", model.name, @"name", nil]])
//                {
//                    [self.selectedArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:model.Id, @"id", model.name, @"name", nil]];
//                }
//            }
//            else if (cell.select == NO && ( treeNodeInfo.treeDepthLevel == 3 || [model.dataType isEqualToString:@"org"]))
//            {
//                [self.selectedArray removeObject:[NSDictionary dictionaryWithObjectsAndKeys:model.Id, @"id", model.name, @"name", nil]];
//            }
        }
        self.treeView.isClose = YES;
        // NSLog(@"selecteArray:%@",[[MKSelectArray sharedInstance] initObject].selectArray);
        //NSLog(@"selecteArray:%@",self.selectedArray);
        // 将选择的子节点的 模型 返回
        return treeNodeInfo.item; //RADataObject  叶子节点  要 return 节点
    }
    else
    {
        DamPeopleCellModel *model = treeNodeInfo.item;
        model.isCheck = cell.select;
        NSMutableArray *datas = [NSMutableArray array];
        NSArray *dics = [treeNodeInfo children];
        for (RATreeNodeInfo *child in dics)
        {
            [datas addObject:[self recursion:child index:((NSInteger)index + 1) treeTableViewCell:cell]];
        }
        return [treeNodeInfo children];//RADataObject  根节点   要return
    }
    return nil;
}

- (NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(id)item
{
    if (item == nil) {
        return [self.data count];
    }
    DamPeopleCellModel *data = item;
    return [data.peoples count];
}

- (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(id)item
{
    DamPeopleCellModel *data = item;
    if (item == nil) {
        return [self.data objectAtIndex:index];
    }
    return [data.peoples objectAtIndex:index];
}

#pragma mark TreeView Delegate methods
- (CGFloat)treeView:(RATreeView *)treeView heightForRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    DamPeopleCellModel *model = treeNodeInfo.item;

    // 如果是头部返回高度 0.0
    if (treeNodeInfo.positionInSiblings == 0 && treeNodeInfo.treeDepthLevel == 0){
        return 0.0;
    } else if ([model.dataType isEqualToString:@"org"]) {
        return 37.0;
    } else if ([model.dataType isEqualToString:@"user"]) {
        return 60.0;
    }
    return 37.0;
}

- (NSInteger)treeView:(RATreeView *)treeView indentationLevelForRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    return 3 * treeNodeInfo.treeDepthLevel;
}

#pragma mark TreeView Delegate methods
- (BOOL)treeView:(RATreeView *)treeView shouldExpandRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    if (treeNodeInfo.children.count) {
        return YES;
    }
    return NO;
}

- (BOOL)treeView:(RATreeView *)treeView shouldItemBeExpandedAfterDataReload:(id)item treeDepthLevel:(NSInteger)treeDepthLevel
{
    if (_haveHeadView) {
        // 默认不展开
//        if ([item isEqual:self.expanded]) {
//            return YES;
//        }
        // 默认展开
        if (treeDepthLevel == 0) {
            return YES;
        }
        return NO;
    }
    else
    {
        if (treeDepthLevel == 0) {
            return YES;
        }
        return NO;
    }
}

- (void)treeView:(RATreeView *)treeView willDisplayCell:(UITableViewCell *)cell forItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    //cell.backgroundColor = UIColorFromRGB(0xF7F7F7);
    //cell.backgroundColor = UIColorFromRGB(0xFFFFFF);
    DamPeopleCellModel *model = treeNodeInfo.item;
    
    // 如果是头部
    if (treeNodeInfo.positionInSiblings == 0 && treeNodeInfo.treeDepthLevel == 0){
        cell.backgroundColor = [UIColor clearColor];
    }else if ([model.dataType isEqualToString:@"org"]) {
//        cell.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:250/255.0 alpha:1.0];
        cell.backgroundColor = [UIColor whiteColor];
    } else {
//        cell.backgroundColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor colorWithRed:235/255.0 green:240/255.0 blue:245/255.0 alpha:1.0];
    }
}

- (void)treeView:(RATreeView *)treeView didSelectRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    DamPeopleCellModel *model = treeNodeInfo.item;
    if (treeNodeInfo.positionInSiblings == 0 &&treeNodeInfo.treeDepthLevel == 0)//若是选择收件栏cell，旋转图标
    {
        UIImageView *imgView = (UIImageView *)[self viewWithTag:ARROW_IMG];
        if(treeNodeInfo.expanded){
            self.isSelect = NO;
            [UIView animateWithDuration:0.5f animations:^{
                imgView.transform = CGAffineTransformMakeRotation(M_PI * (0)/180);}];
        }
        else
        {
            self.isSelect = YES;
            UIImageView *imgView = (UIImageView *)[self viewWithTag:ARROW_IMG];
            [UIView animateWithDuration:0.5f animations:^{
                imgView.transform = CGAffineTransformMakeRotation(M_PI * (180)/180);}];
        }
    }
    else//若不是，旋转选中的Cell的右侧图标
    {
        DamPeopleSelectTableCell *cell = (DamPeopleSelectTableCell *)[treeView cellForItem:item];
        if (treeNodeInfo.expanded == YES)
        {
            cell.arrowImageView.image = [UIImage imageNamed:@"shousuo"];
            
        }
        else
        {
            cell.arrowImageView.image = [UIImage imageNamed:@"zhankai"];
            if (treeNodeInfo.children.count == 0 && [model.dataType isEqualToString:@"user"])
            {
                // 最后一层 点击cell (选人)
                //cell.select = !cell.select;
                //model.isCheck = cell.select;
                [self treeTableViewCell:cell tapIconWithTreeItem:item WithInfo:treeNodeInfo];
                if ([self.delegate respondsToSelector:@selector(itemSelectInfo:)]) {
                    [self.delegate itemSelectInfo:item];
                }
            }
        }
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end