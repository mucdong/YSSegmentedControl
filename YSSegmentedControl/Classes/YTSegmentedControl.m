//
//  YXSegmentedControl.m
//  FSO
//
//  Created by songyutao on 14-11-25.
//  Copyright (c) 2014年 Creditease. All rights reserved.
//

#import "YTSegmentedControl.h"

static const CGFloat KDefaultItemWidth = 60;

@implementation YTSegmentedItem

- (id)initWithTitle:(NSString *)title image:(UIImage *)image  selectImage:(UIImage *)selectImage
{
    self = [super init];
    if (self) {
        
        self.title = title;
        self.image = image;
        self.selectImage = selectImage;
        self.iconTitleGap = 10;
        self.itemLayout = YTSegmentedItemLayoutIconAtLeft;
        
    }
    return self;
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface YTSegmentedControlItemView : UIControl
@property(nonatomic, strong)YTSegmentedItem     *item;
@property(nonatomic, strong)UIImageView         *iconView;
@property(nonatomic, strong)UILabel             *titleLabel;
@property(nonatomic, strong)UIImageView         *backgroundImageView;

@property(nonatomic, strong)UIImage             *backgroundImage;
@property(nonatomic, strong)UIColor             *backgroundColor;

@property(nonatomic, copy  )NSDictionary        *normalAttributeDictionary;
@property(nonatomic, copy  )NSDictionary        *selectedAttributeDictionary;

- (instancetype)initWithItem:(YTSegmentedItem *)item;

@end

@implementation YTSegmentedControlItemView

- (instancetype)initWithItem:(YTSegmentedItem *)item
{
    self = [super init];
    if (self) {
        self.item = item;
    }
    return self;
}

- (void)setItem:(YTSegmentedItem *)item
{
    _item = item;
    self.iconView.image = item.image;
    self.iconView.frame = CGRectMake(0, 0, item.image.size.width, item.image.size.height) ;
    self.titleLabel.text = item.title;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.clipsToBounds = YES;
        
        self.backgroundImageView = [[UIImageView alloc] init];
        [self addSubview:self.backgroundImageView];
        self.backgroundColor = [UIColor clearColor];
        
        self.iconView = [[UIImageView alloc] init];
        [self addSubview:self.iconView];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.titleLabel];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    const CGFloat width = self.bounds.size.width;
    const CGFloat height = self.bounds.size.height;
    
    self.backgroundImageView.frame = self.bounds;
    
    CGSize imageSize = self.iconView.image.size;
    CGSize titleSize = [self.titleLabel.text boundingRectWithSize:CGSizeMake(width-imageSize.width-self.item.iconTitleGap, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleLabel.font} context:nil].size;
    
    switch (self.item.itemLayout)
    {
        case YTSegmentedItemLayoutIconAtRight:
        {
            self.titleLabel.frame = CGRectMake((width-imageSize.width-titleSize.width-(imageSize.width>0 ? self.item.iconTitleGap : 0))/2, (height-titleSize.height)/2, titleSize.width, titleSize.height);
            self.iconView.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame)+(imageSize.width>0 ? self.item.iconTitleGap : 0), (height-imageSize.height)/2, imageSize.width, imageSize.height);
            
            break;
        }
        case YTSegmentedItemLayoutIconAtTop:
        {
            titleSize = [self.titleLabel.text boundingRectWithSize:CGSizeMake(width, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleLabel.font} context:nil].size;
            self.iconView.frame = CGRectMake((width-imageSize.width)/2, (height-imageSize.height-titleSize.height-(imageSize.width>0 ? self.item.iconTitleGap : 0))/2, imageSize.width, imageSize.height);
            self.titleLabel.frame = CGRectMake((width-titleSize.width)/2, CGRectGetMaxY(self.iconView.frame)+(imageSize.width>0 ? self.item.iconTitleGap : 0), titleSize.width, titleSize.height);
            
            break;
        }
        case YTSegmentedItemLayoutIconAtBottom:
        {
            titleSize = [self.titleLabel.text boundingRectWithSize:CGSizeMake(width, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleLabel.font} context:nil].size;
            self.titleLabel.frame = CGRectMake((width-titleSize.width)/2, (height-imageSize.height-titleSize.height-(imageSize.width>0 ? self.item.iconTitleGap : 0))/2, titleSize.width, titleSize.height);
            self.iconView.frame = CGRectMake((width-imageSize.width)/2, CGRectGetMaxY(self.titleLabel.frame)+(imageSize.width>0 ? self.item.iconTitleGap : 0), imageSize.width, imageSize.height);
            break;
        }
        default:
        {
            self.iconView.frame = CGRectMake((width-imageSize.width-titleSize.width-(imageSize.width>0 ? self.item.iconTitleGap : 0))/2, (height-imageSize.height)/2, imageSize.width, imageSize.height);
            self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.iconView.frame)+(imageSize.width>0 ? self.item.iconTitleGap : 0), (height-titleSize.height)/2, titleSize.width, titleSize.height);
        }
    }
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    NSDictionary *dictionary = selected ? self.selectedAttributeDictionary : self.normalAttributeDictionary;
    
    self.iconView.image = selected ? self.item.selectImage : self.item.image;
    self.iconView.frame = CGRectMake(0, 0, self.iconView.image.size.width, self.iconView.image.size.height);
    self.titleLabel.font = [dictionary objectForKey:NSFontAttributeName];
    self.titleLabel.textColor = [dictionary objectForKey:NSForegroundColorAttributeName];
    self.backgroundImageView.image = self.backgroundImage;
    
    [self setNeedsLayout];
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize imageSize = self.iconView.image.size;
    CGSize titleSize = [self.titleLabel.text boundingRectWithSize:CGSizeMake(size.width, size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleLabel.font} context:nil].size;
    
    switch (self.item.itemLayout)
    {
        case YTSegmentedItemLayoutIconAtRight:
        case YTSegmentedItemLayoutIconAtLeft:
        {
            return CGSizeMake(imageSize.width+titleSize.width+self.item.iconTitleGap, MAX(imageSize.height, titleSize.height));
        }
        case YTSegmentedItemLayoutIconAtTop:
        case YTSegmentedItemLayoutIconAtBottom:
        {
            return CGSizeMake(MAX(imageSize.width, titleSize.width), imageSize.height+titleSize.height+self.item.iconTitleGap);
        }
    }
    return CGSizeZero;
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface YTSegmentedControl ()

@property(nonatomic, strong)NSMutableArray      *itemButtonArray;
@property(nonatomic, strong)UIScrollView        *contentView;
@property(nonatomic, assign)BOOL                onlySelected;

@property(nonatomic, strong)UIImageView         *selectedBgView;

@end

@implementation YTSegmentedControl

+ (void)initialize
{
    [[YTSegmentedControl appearance] setTintColor:[UIColor colorWithRed:0/255 green:91/255.0 blue:255/255.0 alpha:1]];
    [[YTSegmentedControl appearance] setContentEdgeInsets:UIEdgeInsetsZero];
    
    [[YTSegmentedControl appearance] setNormalAttributeDictionary:@{NSFontAttributeName:[UIFont systemFontOfSize:14],
                                                                    NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    [[YTSegmentedControl appearance] setSelectedAttributeDictionary:@{NSFontAttributeName:[UIFont systemFontOfSize:14],
                                                                      NSForegroundColorAttributeName:[UIColor blueColor]}];
    
    [[YTSegmentedControl appearance] setItemWidth:KDefaultItemWidth];
    
    [[YTSegmentedControl appearance] setItemGap:0];
}

- (id)initWithItems:(NSArray *)items
{
    self = [super init];
    if (self) {
        
        CGFloat index = 0;
        for (YTSegmentedItem *segmentedItem in items)
        {
            [self addItem:segmentedItem atIndex:index++];
        }
        
        self.selectedIndex = 0;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        
        self.itemButtonArray = [NSMutableArray array];
        
        self.contentCorner = 0;
        
        self.backgroundColor = [UIColor clearColor];
        
        self.contentView = [[UIScrollView alloc] init];
        self.contentView.clipsToBounds = YES;
        self.contentView.backgroundColor = [UIColor clearColor];
        self.contentView.showsHorizontalScrollIndicator = NO;
        self.contentView.showsVerticalScrollIndicator = NO;
        [self addSubview:self.contentView];
        
        self.selectedBgView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.selectedBgView];

    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [self onlySetSelectedIndex:self.selectedIndex];
    
    if (self.itemButtonArray.count > 0)
    {
        YTSegmentedControlItemView *itemView = [self.itemButtonArray objectAtIndex:self.selectedIndex];
        itemView.selected = YES;
    }
}

- (void)addItem:(YTSegmentedItem *)item atIndex:(NSUInteger)index
{
    if (index <= self.itemButtonArray.count)
    {
        YTSegmentedControlItemView *itemView = [[YTSegmentedControlItemView alloc] initWithItem:item];
        [itemView addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [itemView setNormalAttributeDictionary:self.normalAttributeDictionary];
        [itemView setSelectedAttributeDictionary:self.selectedAttributeDictionary];
        [itemView setSelected:NO];
        [self.itemButtonArray insertObject:itemView atIndex:index];
        [self.contentView addSubview:itemView];
    }
}

- (void)clearItem
{
    for (UIView *view in self.contentView.subviews) {
        if (self.selectedBgView != view)
        {
            [view removeFromSuperview];
        }
    }
    [self.itemButtonArray removeAllObjects];
}

- (void)setBackgroundView:(UIView *)backgroundView
{
    [_backgroundView removeFromSuperview];
    
    _backgroundView = backgroundView;
    [self addSubview:_backgroundView];
    [self sendSubviewToBack:_backgroundView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backgroundView.frame = self.bounds;
    
    self.contentView.frame = UIEdgeInsetsInsetRect(self.bounds, self.contentEdgeInsets);
    
    if (self.contentCorner != 0)
    {
        self.contentView.layer.cornerRadius = self.contentCorner;
        self.contentView.clipsToBounds = YES;
        
        self.contentView.layer.borderWidth = 1.0f;
        self.contentView.layer.borderColor = self.tintColor.CGColor;
    }
    else
    {
        self.contentView.clipsToBounds = NO;
    }
    
    CGRect contentRect = self.contentView.bounds;
    
    if (self.contentCorner != 0)
    {
        self.itemWidth = self.itemButtonArray.count*self.itemWidth <= contentRect.size.width ? (contentRect.size.width / self.itemButtonArray.count) : self.itemWidth;
    }
    CGFloat margin = 0;
    if (!self.dynamicItemWidth)
    {
        margin = self.itemButtonArray.count*self.itemWidth > contentRect.size.width ? 0 : (contentRect.size.width-self.itemButtonArray.count*self.itemWidth-(self.itemButtonArray.count-1)*self.itemGap)/2;
    }
    
    CGFloat offX = 0;
    for (YTSegmentedControlItemView *itemView in self.itemButtonArray)
    {
        [self layoutItemAttribute:itemView];
        CGSize itemSize = CGSizeMake(self.itemWidth, contentRect.size.height);
        if (self.dynamicItemWidth)
        {
            itemSize = [itemView sizeThatFits:CGSizeMake(contentRect.size.width, contentRect.size.height)];
        }
        
        itemView.frame = CGRectMake(offX, contentRect.origin.y, itemSize.width, contentRect.size.height);
        offX += itemSize.width + self.itemGap;
        
        if (itemView.selected) {
            self.selectedBgView.frame = itemView.frame;
        }
    }
    offX -= self.itemGap;
    if (!self.dynamicItemWidth)
        offX += margin < 0 ? 0 : margin;
    self.contentView.contentSize = CGSizeMake(offX, contentRect.size.height);
}

- (void)setTintColor:(UIColor *)tintColor
{
    _tintColor = tintColor;
    [self setNeedsLayout];
}

- (void)layoutItemAttribute:(YTSegmentedControlItemView *)button
{
    for (YTSegmentedControlItemView *button in self.itemButtonArray)
    {
        if (!self.normalItemBgImage)
        {
            [button setBackgroundColor:self.backgroundColor];
        }
        else
        {
            [button setBackgroundImage:self.normalItemBgImage];
        }
        
        [self setItemWithAttributeDictionary:self.normalAttributeDictionary item:button];
        [self setItemWithAttributeDictionary:self.selectedAttributeDictionary item:button];
        
        [button setSelected:button.selected];
    }
}

- (void)setItemWithAttributeDictionary:(NSDictionary *)attribute item:(YTSegmentedControlItemView *)itemView
{
    [itemView.titleLabel setFont:[attribute objectForKey:NSFontAttributeName]];
    [itemView.titleLabel setTextColor:[attribute objectForKey:NSForegroundColorAttributeName]];
}

- (void)setNormalAttributeDictionary:(NSDictionary *)normalAttributeDictionary
{
    _normalAttributeDictionary = normalAttributeDictionary;
    for (YTSegmentedControlItemView *itemView in self.itemButtonArray)
    {
        [itemView setNormalAttributeDictionary:normalAttributeDictionary];
    }
}

- (void)setSelectedAttributeDictionary:(NSDictionary *)selectedAttributeDictionary
{
    _selectedAttributeDictionary = selectedAttributeDictionary;
    for (YTSegmentedControlItemView *itemView in self.itemButtonArray)
    {
        [itemView setSelectedAttributeDictionary:selectedAttributeDictionary];
    }
}

- (void)setNormalItemBgImage:(UIImage *)normalItemBgImage
{
    _normalItemBgImage = normalItemBgImage;
    for (YTSegmentedControlItemView *itemView in self.itemButtonArray)
    {
        [itemView setBackgroundImage:normalItemBgImage];
    }
}

- (void)setSelectedItemBgImage:(UIImage *)selectedItemBgImage
{
    _selectedItemBgImage = selectedItemBgImage;
    self.selectedBgView.image = selectedItemBgImage;
}

- (void)onlySetSelectedIndex:(NSUInteger)index
{
    self.onlySelected = YES;
    self.selectedIndex = index;
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    NSUInteger oldSelectedIndex = self.selectedIndex;
    if (selectedIndex < self.itemButtonArray.count)
    {
        _selectedIndex = selectedIndex;
        
        YTSegmentedControlItemView *itemView = [self.itemButtonArray objectAtIndex:selectedIndex];
        YTSegmentedControlItemView *oldItemView = [self.itemButtonArray objectAtIndex:oldSelectedIndex];
        [oldItemView setSelected:NO];
        [itemView setSelected:YES];
        
        CGRect rect = UIEdgeInsetsInsetRect(self.selectedBgView.frame, UIEdgeInsetsMake(0, 3, 0, 3));
        [UIView animateWithDuration:0.1 animations:^{
            self.selectedBgView.frame = rect;
        } completion:^(BOOL finished) {
            CGRect goRect = UIEdgeInsetsInsetRect(itemView.frame, UIEdgeInsetsMake(0, 3, 0, 3));
            [UIView animateWithDuration:0.1 animations:^{
                self.selectedBgView.frame = goRect;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.1 animations:^{
                    self.selectedBgView.frame = itemView.frame;
                }];
            }];
        }];
        
        CGFloat contentWidth = self.contentView.contentSize.width;
        CGFloat contentOffx = self.contentView.contentOffset.x;
        
        CGFloat minVisualX = contentOffx;
        CGFloat maxVisualX = minVisualX + self.contentView.frame.size.width > contentWidth ? contentWidth : minVisualX + self.contentView.frame.size.width;
        if (CGRectGetMaxX(itemView.frame) > maxVisualX || CGRectGetMinX(itemView.frame) < minVisualX)
        {
            CGFloat maxContentOffx = 0;
            if (CGRectGetMaxX(itemView.frame)-self.contentView.frame.size.width+self.contentView.frame.size.width/2 < 0)
            {
                maxContentOffx = 0;
            }
            else if (CGRectGetMaxX(itemView.frame)-self.contentView.frame.size.width+self.contentView.frame.size.width/2 > contentWidth-self.contentView.frame.size.width)
            {
                maxContentOffx = CGRectGetMaxX(itemView.frame) - self.contentView.frame.size.width;
            }
            else
            {
                maxContentOffx = CGRectGetMaxX(itemView.frame)-self.contentView.frame.size.width+self.contentView.frame.size.width/2;
            }
            [self.contentView setContentOffset:CGPointMake(maxContentOffx, itemView.frame.origin.y)  animated:YES];
        }
        
        if (!self.onlySelected)
        {
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
        self.onlySelected = NO;
    }
    [self setNeedsLayout];
}

- (void)buttonTapped:(UIButton *)button
{
    NSUInteger selectedIndex = [self.itemButtonArray indexOfObject:button];
    [self setSelectedIndex:selectedIndex];
}

@end
