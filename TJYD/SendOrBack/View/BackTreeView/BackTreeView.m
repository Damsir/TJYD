//
//  BackTreeView.m
//  TJYD
//
//  Created by 吴定如 on 17/5/8.
//  Copyright © 2017年 Dist. All rights reserved.
//

#import "BackTreeView.h"
#import "DamPeopleHeadTableViewCell.h"
#import "KOTreeItem.h"
#import "RATreeView.h"
#import "SendPeopleSelectTableCell.h"

//屏幕大小
#define SCREEN                     [[UIScreen mainScreen]bounds]
//#define SCREEN_WIDTH               [[UIScreen mainScreen]bounds].size.width

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define ARROW_IMG   1070
#define RIGHT_IMG   1080
#define SELECT_BTN  1090
#define BOOKMARK_WORD_LIMT  250

@interface BackTreeView () <RATreeViewDelegate, RATreeViewDataSource>

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

@implementation BackTreeView

@synthesize treeItems;
@synthesize selectedTreeItems;
@synthesize item0, item1_1, item1_1_1, item1_1_1_1;

+ (BackTreeView *)instanceView
{
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"BackTreeView" owner:nil options:nil];
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

- (BackTreeView *) initTreeWithFrame:(CGRect)rect dataArray:(NSArray *)nodeArray haveHiddenSelectBtn:(BOOL)isHidden haveHeadView:(BOOL)haveHeadView isEqualX:(BOOL)isEqualX
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
    UINib *rowNib = [UINib nibWithNibName:@"SendPeopleSelectTableCell" bundle:nil];
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
    if ([BackPeopleCellModel sharedPeople].node.count == 0)
    {
        self.isFirst = YES;
    }
    return self;
    
}
#pragma mark -- 屏幕旋转
- (void)screenRotation {
    
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
- (void)treeDataSetting {
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
                    BackPeopleCellModel *modelFour = [BackPeopleCellModel dataObjectWithName:[[modelTwoArray objectAtIndex:k] valueForKey:@"name"] activityName:[[modelTwoArray objectAtIndex:k] valueForKey:@"activityName"] bpdid:[[modelTwoArray objectAtIndex:k] valueForKey:@"bpdid"] unkownId:[[modelTwoArray objectAtIndex:k] valueForKey:@"unkownId"] children:nil];
                    modelFour.name = [[modelTwoArray objectAtIndex:k] valueForKey:@"name"];
                    modelFour.activityName = [[modelTwoArray objectAtIndex:k] valueForKey:@"activityName"];
                    modelFour.bpdid = [[modelTwoArray objectAtIndex:k] valueForKey:@"bpdid"];
                    modelFour.unknowId = [[modelTwoArray objectAtIndex:k] valueForKey:@"unknowId"];
                    [mutableThree addObject:modelFour];
                }
                //                else
                //                {
                //                    NSMutableArray *mutableFour = [[NSMutableArray alloc] init];
                //                    for (int l = 0; l < modelThreeArray.count; l ++)
                //                    {
                //                        MKPeopleCellModel *modelFour = [MKPeopleCellModel dataObjectWithName:[[modelThreeArray objectAtIndex:l] valueForKey:@"activityName"] children:nil];
                //                        modelFour.userId = [[modelThreeArray objectAtIndex:l] valueForKey:@"userId"];
                //                        modelFour.activityID = [[modelThreeArray objectAtIndex:l] valueForKey:@"activityID"];
                //                        [mutableFour addObject:modelFour];
                //                    }
                //                    MKPeopleCellModel *modelThree = [MKPeopleCellModel dataObjectWithName:[[modelTwoArray objectAtIndex:k] valueForKey:@"activityName"] children:mutableFour];
                //                    [mutableThree addObject:modelThree];
                //                }
            }
            BackPeopleCellModel *modelTwo = [BackPeopleCellModel dataObjectWithName:[[modelOneArray objectAtIndex:j] valueForKey:@"name"] activityName:[[modelOneArray objectAtIndex:j] valueForKey:@"activityName"] bpdid:[[modelOneArray objectAtIndex:j] valueForKey:@"bpdid"] unkownId:[[modelOneArray objectAtIndex:j] valueForKey:@"unknowId"] children:mutableThree];

            [mutabletwo addObject:modelTwo];
        }
        BackPeopleCellModel *modelOne = [BackPeopleCellModel dataObjectWithName:[[self.nodeArray objectAtIndex:i] valueForKey:@"name"] activityName:[[self.nodeArray objectAtIndex:i] valueForKey:@"activityName"] bpdid:[[self.nodeArray objectAtIndex:i] valueForKey:@"bpdid"] unkownId:[[self.nodeArray objectAtIndex:i] valueForKey:@"unknowId"] children:mutabletwo];

        [mutableOne addObject:modelOne];
        
    }
    BackPeopleCellModel *model = [BackPeopleCellModel dataObjectWithName:@"选择收件人" activityName:@"activityName" bpdid:@"bpdid" unkownId:@"unknowId" children:mutableOne];

    self.data = [NSArray arrayWithObject:model];
    [_treeView reloadData];
}

#pragma mark TreeView Data Source

- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    DamPeopleHeadTableViewCell *headCell = [_treeView dequeueReusableCellWithIdentifier:headCellID];
    SendPeopleSelectTableCell *rowCell = [_treeView dequeueReusableCellWithIdentifier:rowCellID];
    
    if (headCell == nil)
    {
        headCell = [[DamPeopleHeadTableViewCell alloc] init];
    }
    if (rowCell == nil) {
        rowCell = [[SendPeopleSelectTableCell alloc] init];
    }
    
    if (!_haveHeadView) {
        headCell.choseConnectImage.hidden = YES;
        headCell.choseConnectLabel.hidden = YES;
        headCell.choseCountLabel.hidden   = YES;
        headCell.lineView.hidden          = YES;
        headCell.backgroundColor = [UIColor clearColor];
        
    }
    
    headCell.selectionStyle = UITableViewCellSelectionStyleNone;
    rowCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    /**
     *  返回选择的联系人个数
     */
    //headCell.choseCountLabel.text = [NSString stringWithFormat:@"(%ld)",(unsigned long)[[MKSelectArray sharedInstance] initObject].selectArray.count];
    headCell.choseCountLabel.text = [NSString stringWithFormat:@"(%ld)",(unsigned long)self.selectedArray.count];
    
    
    //标题
    if (_isEqualX) {
        rowCell.titleLabel.frame = CGRectMake(40 + 0 * treeNodeInfo.treeDepthLevel, 10, self.frame.size.width - 40 - 0 * treeNodeInfo.treeDepthLevel-50, 20);
    }
    else
    {
        rowCell.titleLabel.frame = CGRectMake(40 + 15 * treeNodeInfo.treeDepthLevel, 10, self.frame.size.width - 40 - 15 * treeNodeInfo.treeDepthLevel - 50, 20);
        rowCell.selectButton_left.constant = 20 * treeNodeInfo.treeDepthLevel;
    }
    
    rowCell.titleLabel.font = [UIFont systemFontOfSize:15.0];
    // rowCell.titleLabel.textColor = [UIColor colorWithRed:0x33/255.f green:0x33/255.f blue:0x33/255.f alpha:1.0f];
    
    BackPeopleCellModel *peopleModel = treeNodeInfo.item;
    
    /**<树状展开的深度，层次级别*/
    if (treeNodeInfo.treeDepthLevel == 1 && [peopleModel.type isEqualToString:@"activity"] && treeNodeInfo.children.count != 0) {
        rowCell.titleLabel.textColor = [UIColor colorWithRed:0x22/255.f green:0x22/255.f blue:0x22/255.f alpha:1.0f];
    }
    else if(treeNodeInfo.treeDepthLevel == 2 && [peopleModel.type isEqualToString:@"activity"] && treeNodeInfo.children.count != 0){
        rowCell.titleLabel.textColor = [UIColor colorWithRed:0x66/255.f green:0x66/255.f blue:0x66/255.f alpha:1.0f];
    }
    else {
        //rowCell.titleLabel.textColor = [UIColor colorWithRed:0x0/255.f green:0x64/255.f blue:0x128/255.f alpha:1.0f];
        rowCell.titleLabel.textColor = BLUECOLOR;
    }
    
    /**
     *  人员选中后颜色变为选中色
     */
    if (rowCell.select) {
        
        rowCell.titleLabel.textColor = [UIColor colorWithRed:233/255.0 green:129/255.0 blue:39/255.0 alpha:1.0];
    }
    
    rowCell.titleLabel.textAlignment = NSTextAlignmentLeft;
    
    //去除掉首尾的空白字符和换行字符
    NSString *nameStr = ((BackPeopleCellModel *)item).name;
    nameStr = [nameStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    nameStr = [nameStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    nameStr = [nameStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    NSMutableString *titleStr = [NSMutableString stringWithString:nameStr];
    
    rowCell.titleLabel.text = titleStr;
    
    if (!self.isSelect)
    {
        headCell.choseConnectImage.image = [UIImage imageNamed:@"ico_blue_arrow"];
    }
    else
    {
        [UIView animateWithDuration:0.f animations:^{
            headCell.choseConnectImage.transform = CGAffineTransformMakeRotation(M_PI * (180)/180);}];
    }
    headCell.choseConnectImage.tag = ARROW_IMG;
    
    if (rowCell.select == YES) {
        rowCell.backgroundColor = HOMETABLECOLOR;
    }
    
    
    //左侧勾选按钮
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
        rowCell.chooseButton.frame = CGRectMake(CGRectGetMinX(rowCell.titleLabel.frame)- 27 - 5, 10, 20, 20);
        //rowCell.chooseButton.center = CGPointMake(rowCell.chooseButton.center.x, rowCell.titleLabel.center.y);
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
        rowCell.arrowImageView.image = [UIImage imageNamed:@"ico_blue_arrow_up"];
    }
    else
    {
        rowCell.arrowImageView.image = [UIImage imageNamed:@"ico_blue_arrow"];
    }
    
    rowCell.arrowImageView.tag  = RIGHT_IMG;
    
    // 只有一层(环节 和 名字)
    rowCell.arrowImageView.hidden = YES;
    
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
    BackPeopleCellModel *model = item;
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
- (void)treeTableViewCell:(SendPeopleSelectTableCell *)cell tapIconWithTreeItem:(id)item WithInfo:(RATreeNodeInfo *)treeNodeInfo
{
    self.isSend = NO;
    cell.select = !cell.select;
    [self recursion:treeNodeInfo index:treeNodeInfo.positionInSiblings treeTableViewCell:cell];
    
    if (cell.select == NO)
    {
        [self parent:treeNodeInfo treeTableViewCell:cell treeLever:treeNodeInfo.treeDepthLevel];
    }
    
    BackPeopleCellModel *model = treeNodeInfo.parent.item;
    NSArray *childArray = [model peoples];
    NSInteger selectCount = 0;
    
    for (int i = 0; i < childArray.count; i ++)
    {
        BackPeopleCellModel *model = [childArray objectAtIndex:i];
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
    
    [self.treeView reloadData];
}

#pragma mark - Child节点选择改变父节点
- (id)childChangeParent:(RATreeNodeInfo*)treeNodeInfo treeTableViewCell:(SendPeopleSelectTableCell *)cell treeLever:(NSInteger)lever childArray:(NSArray *)childArray selectCount:(NSInteger)selectCount
{
    BackPeopleCellModel *model = treeNodeInfo.parent.item;
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
            BackPeopleCellModel *model = treeNodeInfo.parent.item;
            model.isCheck = cell.select;
            NSInteger selectCount = 0;
            
            BackPeopleCellModel *parentModel = [treeNodeInfo.parent parent].item;
            for (int i = 0; i < [parentModel peoples].count; i ++)
            {
                BackPeopleCellModel *childModel = [[parentModel peoples] objectAtIndex:i];
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
- (id)parent:(RATreeNodeInfo*)treeNodeInfo treeTableViewCell:(SendPeopleSelectTableCell *)cell treeLever:(NSInteger)lever
{
    BackPeopleCellModel *model = treeNodeInfo.parent.item;
    if ([model.name isEqualToString:@"选择收件人"]) {
        return model.name;
    }
    else
    {
        BackPeopleCellModel *model = treeNodeInfo.parent.item;
        model.isCheck = cell.select;
        [self parent:treeNodeInfo.parent treeTableViewCell:cell treeLever:(lever - 1)];
        return treeNodeInfo.parent;
    }
    return nil;
}

#pragma mark 递归
-(id)recursion:(RATreeNodeInfo*)treeNodeInfo index:(NSInteger)index treeTableViewCell:(SendPeopleSelectTableCell *)cell
{
    //    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    if ([treeNodeInfo children].count == 0)
    {
        BackPeopleCellModel *model = treeNodeInfo.item;
        model.isCheck = cell.select;
        if (model.name != nil)
        {
            if (cell.select == YES)
            {
                
                if (![self.selectedArray containsObject:[NSDictionary dictionaryWithObjectsAndKeys: model.name, @"name", model.activityName, @"activityName", model.bpdid, @"bpdid", nil]])
                {
                    [self.selectedArray addObject:[NSDictionary dictionaryWithObjectsAndKeys: model.name, @"name", model.activityName, @"activityName", model.bpdid, @"bpdid", nil]];
                }
                
            } else if (cell.select == NO)
            {
                [self.selectedArray removeObject:[NSDictionary dictionaryWithObjectsAndKeys: model.name, @"name", model.activityName, @"activityName", model.bpdid, @"bpdid", nil]];
            }
        }
        self.treeView.isClose = YES;
        // NSLog(@"selecteArray:%@",[[MKSelectArray sharedInstance] initObject].selectArray);
        //        DLog(@"selecteArray:%@",self.selectedArray);
        // 将选择的子节点的 模型 返回
        return treeNodeInfo.item; //RADataObject  叶子节点  要 return 节点
    } else {
        BackPeopleCellModel *model = treeNodeInfo.item;
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
    BackPeopleCellModel *data = item;
    return [data.peoples count];
}

- (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(id)item
{
    BackPeopleCellModel *data = item;
    if (item == nil) {
        return [self.data objectAtIndex:index];
    }
    return [data.peoples objectAtIndex:index];
}

#pragma mark TreeView Delegate methods
- (CGFloat)treeView:(RATreeView *)treeView heightForRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    // 如果是头部返回高度 0.0
    if (treeNodeInfo.positionInSiblings == 0 && treeNodeInfo.treeDepthLevel == 0){
        return 0.0;
    }
    return 44.0;
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
        // 默认展开(YES:展开  NO:收缩)
        if (treeDepthLevel == 0) {
            return YES;
        }
        return YES;
    }
    else
    {
        if (treeDepthLevel == 0) {
            return YES;
        }
        return YES;
    }
}

- (void)treeView:(RATreeView *)treeView willDisplayCell:(UITableViewCell *)cell forItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    //cell.backgroundColor = UIColorFromRGB(0xF7F7F7);
    cell.backgroundColor = UIColorFromRGB(0xFFFFFF);
    if (treeNodeInfo.positionInSiblings == 0 && treeNodeInfo.treeDepthLevel == 0){
        cell.backgroundColor = [UIColor clearColor];
    }
}

- (void)treeView:(RATreeView *)treeView didSelectRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
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
        SendPeopleSelectTableCell *cell = (SendPeopleSelectTableCell *)[treeView cellForItem:item];
        if (treeNodeInfo.children.count != 0 && treeNodeInfo.expanded == YES)
        {
            cell.arrowImageView.image = [UIImage imageNamed:@"ico_blue_arrow"];
            
        }
        else
        {
            cell.arrowImageView.image = [UIImage imageNamed:@"ico_blue_arrow_up"];
            if (treeNodeInfo.children.count == 0)
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
        //        if (treeNodeInfo.expanded == YES)
        //        {
        //            cell.arrowImageView.image = [UIImage imageNamed:@"ico_blue_arrow"];
        //
        //        }
        //        else
        //        {
        //            cell.arrowImageView.image = [UIImage imageNamed:@"ico_blue_arrow_up"];
        //            if (treeNodeInfo.children.count == 0)
        //            {
        //                // 最后一层 点击cell (选人)
        //                //cell.select = !cell.select;
        //                //model.isCheck = cell.select;
        //                [self treeTableViewCell:cell tapIconWithTreeItem:item WithInfo:treeNodeInfo];
        //                if ([self.delegate respondsToSelector:@selector(itemSelectInfo:)]) {
        //                    [self.delegate itemSelectInfo:item];
        //                }
        //            }
        //        }
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
