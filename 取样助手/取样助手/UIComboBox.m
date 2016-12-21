//
//  UIComboBox.m
//  取样助手
//
//  Created by Zxt3310 on 2016/12/13.
//  Copyright © 2016年 xxx. All rights reserved.
//

#import "UIComboBox.h"

@implementation UIComboBox
{
    UITextField *comboTF;
    UIButton *comboLb;
    UITableView *tableview;
    BOOL isShow;
    CGRect orignFrame;
    NSIndexPath *currentIndex;
    
    CGRect cellLenth;
}
@synthesize comboList = _comboList;
@synthesize layerColor = _layerColor;
@synthesize comborColor = _comborColor;
@synthesize textFont = _textFont;
@synthesize textColor = _textColor;
@synthesize placeColor = _placeColor;

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        isShow = NO;
        
        orignFrame = frame;
        
        comboTF = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - self.frame.size.height, self.frame.size.height)];
        comboTF.layer.borderWidth = 1;
        comboTF.enabled = NO;
        comboTF.leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 1)];
        comboTF.leftViewMode = UITextFieldViewModeAlways;

        [self addSubview:comboTF];
        
        comboLb = [UIButton buttonWithType:UIButtonTypeSystem];
        comboLb.frame = CGRectMake(comboTF.frame.size.width, 0, self.frame.size.height, self.frame.size.height);
        comboLb.layer.borderWidth = 1;
        [comboLb setTitle:@"▼" forState:UIControlStateNormal];
        comboLb.titleLabel.textAlignment = NSTextAlignmentCenter;
        comboLb.tintColor = [UIColor blackColor];
        comboLb.titleLabel.font = [UIFont systemFontOfSize:self.frame.size.height * 0.77];
        [self addSubview:comboLb];
        
        tableview = [[UITableView alloc]initWithFrame:CGRectMake(self.frame.origin.x,self.frame.origin.y + self.frame.size.height + 3,self.frame.size.width,40)];
        tableview.delegate = self;
        tableview.dataSource = self;
        tableview.layer.borderWidth = 1;
        tableview.layer.cornerRadius = 10;
        tableview.tableFooterView = [[UITableView alloc] initWithFrame:CGRectZero];
        [comboLb addTarget:self action:@selector(showTable) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (UIColor *)layerColor
{
    return _layerColor;
}
- (void)setLayerColor:(UIColor *)layerColor
{
    _layerColor = layerColor;
    comboTF.layer.borderColor = layerColor.CGColor;
}

- (UIColor *)comborColor
{
    return _comborColor;
}
- (void)setComborColor:(UIColor *)comborColor
{
    _comborColor = comborColor;
    comboLb.layer.borderColor = comborColor.CGColor;
    comboLb.tintColor = comborColor;
}

- (UIFont *)textFont
{
    return _textFont;
}
- (void)setTextFont:(UIFont *)textFont
{
    _textFont = textFont;
    comboTF.font = textFont;
}

- (UIColor *)textColor
{
    return _textColor;
}
- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    comboTF.textColor = textColor;
}

- (UIColor *)placeColor
{
    return _placeColor;
}
- (void)setPlaceColor:(UIColor *)placeColor
{
    _placeColor = placeColor;
    comboTF.textColor = comboLb.tintColor = placeColor;
    comboTF.layer.borderColor = comboLb.layer.borderColor = placeColor.CGColor;
}

- (NSArray *)comboList
{
    return _comboList;
}
- (void)setComboList:(NSArray *)comboList
{
    _comboList = comboList;
    
    CGRect temp = tableview.frame;
    if (comboList.count > 4) {
        temp.size.height = 200;
    }
    else
    {
        temp.size.height = (comboList.count + 1) * 40;
    }

    tableview.frame = temp;
    cellLenth = temp;
    
    [tableview reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _comboList.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect tableTemp = cellLenth;
//    CGRect selfTemp = self.frame;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"-请选择-";
    }
    else
    {
        cell.textLabel.text = _comboList[indexPath.row - 1];
        if(indexPath == currentIndex)
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    cellLenth.size.width = cell.textLabel.text.length * cell.textLabel.font.pointSize + 50;
    if(tableTemp.size.width > tableView.frame.size.width)
    {
        if (cellLenth.size.width > tableTemp.size.width) {
           
            tableView.frame = cellLenth;
        }
        else
        {
            tableView.frame = tableTemp;
        }
    }
//    //重新计算控件宽度
//    selfTemp.size.width = tableView.frame.size.width;
//    self.frame = selfTemp;
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!(indexPath.row == 0))
    {
        _selectString = comboTF.text = _comboList[indexPath.row - 1];

        currentIndex = indexPath;
        
        if(self.delegate)
        {
            [_delegate UIComboBox:self didSelectRow:indexPath];
        }
    }
    [self dismissTable];
}

- (void)showTable
{
    if(!isShow)
    {
        [UIView animateWithDuration:.15 animations:^{
            tableview.alpha = 1;
            tableview.transform = CGAffineTransformMakeScale(1, 1);
        }];
        
//        //重新计算控件高度
//        CGRect temp = orignFrame;
//        temp.size.height += tableview.frame.size.height + 3;
//        self.frame = temp;
        
        [self.superview addSubview:tableview];
        
        isShow = YES;
    }
}

- (void)dismissTable
{
    if(isShow)
    {
        [UIView animateWithDuration:.15 animations:^{
            tableview.transform = CGAffineTransformMakeScale(1.3, 1.3);
            tableview.alpha = 0.0;
        } completion:^(BOOL finished) {
            if (finished) {
                self.frame = orignFrame;
                [tableview removeFromSuperview];
                [tableview reloadData];
                isShow = NO;
            }
        }];
    }
}

@end
