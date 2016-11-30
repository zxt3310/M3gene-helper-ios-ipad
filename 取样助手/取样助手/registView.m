//
//  registView.m
//  取样助手
//
//  Created by Zxt3310 on 2016/11/30.
//  Copyright © 2016年 xxx. All rights reserved.
//

#import "registView.h"

@interface contentLable : UILabel

@end
@implementation contentLable
- (instancetype)initWithFrame:(CGRect)frame andText:(NSString *)text
{
    self = [super initWithFrame:frame];
    if(self)
    {
        CGRect temp = self.frame;
        temp.size.width = (text.length + 1)*18;
        temp.size.height = 22;
        self.frame = temp;
        
        self.font = [UIFont fontWithName:@"STHeitiSC-Light" size:18];
        self.textColor = [UIColor colorWithMyNeed:74 green:74 blue:74 alpha:1];
        
    }
    return self;
}

@end

@interface contentTF : UITextField

@end
@implementation contentTF

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        CGRect temp = self.frame;
        temp.size.width = 188*SCREEN_WEIGHT/1024;
        temp.size.height = 22;
        self.frame = temp;
        
        self.textColor = [UIColor colorWithMyNeed:151 green:151 blue:151 alpha:1];
        self.font = [UIFont fontWithName:@"STHeitiSC-Light" size:16];
    }
    return self;
}

@end

//单选控件
@interface comboBox : UIView
@property (nonatomic) NSArray *itemList; //选项文字
@property (nonatomic) NSArray *itemId;   //选项对应输出
@property (nonatomic) NSString *switchId; //选中标识
@end

@implementation comboBox
- (void)setItemList:(NSArray *)itemList
{
    CGFloat x = 0;
    for(int i = 0;i<itemList.count;i++ )
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0 + x, 0, 16*SCREEN_WEIGHT/1024, 16*SCREEN_HEIGHT/768)];
        imageView.userInteractionEnabled = YES;
        imageView.image = [UIImage imageNamed:@"oval107"];
        imageView.tag = 10 + i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [imageView addGestureRecognizer:tap];
        [self addSubview:imageView];
        
        UILabel *itemLable = [[UILabel alloc]init];
        itemLable.text = itemList[i];
        itemLable.frame = CGRectMake(imageView.frame.origin.x + imageView.frame.size.width * 2, 0,itemLable.text.length * 20,20);
        itemLable.font = [UIFont fontWithName:@"STHeitiSC-Light" size:18];
        
        x = x + itemLable.frame.origin.x + itemLable.frame.size.width + 20;
                                                                      
    }
}

- (void)setItemId:(NSArray *)itemId
{
    
}

- (void)setSwitchId:(NSString *)switchId
{
    for(int n =0;n<_itemId.count;n++)
    {
        if([_itemId[n]isEqualToString:switchId])
        {
            for (int i = 10; i<10 + self.itemList.count; i++) {
                UIImageView *imageView = (UIImageView *)[self viewWithTag:i];
                imageView.image = [UIImage imageNamed:@"oval107"];
                if(i-10 == n)
                {
                    imageView.image = [UIImage imageNamed:@"nv"];
                }

        }
    }

}
}



- (void)tapAction:(UITapGestureRecognizer *)sender
{
    for (int i = 10; i<10 + self.itemList.count; i++) {
        UIImageView *imageView = (UIImageView *)[self viewWithTag:i];
        imageView.image = [UIImage imageNamed:@"oval107"];
        if(i == sender.view.tag)
        {
            imageView.image = [UIImage imageNamed:@"nv"];
            self.switchId = self.itemId[i - 10];
        }
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        
    }
    return self;
}

@end




@implementation registView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        
    }
    return self;
}

- (void)show
{
    
}

@end
