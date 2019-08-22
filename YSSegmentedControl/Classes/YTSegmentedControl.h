//
//  YXSegmentedControl.h
//  FSO
//
//  全局外观支持
//    UIImage *selectedImage = [[UIImage imageNamed:@"segmented_selected"] stretchableImageWithLeftCapWidth:[UIImage imageNamed:@"segmented_selected"].size.width/2 topCapHeight:[UIImage imageNamed:@"segmented_selected"].size.height/2];
//    UIImage *unSelectedImage = [[UIImage imageNamed:@"segmented_bg"] stretchableImageWithLeftCapWidth:[UIImage imageNamed:@"segmented_bg"].size.width/2 topCapHeight:[UIImage imageNamed:@"segmented_bg"].size.height/2];
//    [[YTSegmentedControl appearance] setSelectedItemBgImage:selectedImage];
//    [[YTSegmentedControl appearance] setNormalItemBgImage:unSelectedImage];
//    [[YTSegmentedControl appearance] setNormalAttributeDictionary:@{NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName:[UIColor blueColor]}];
//    [[YTSegmentedControl appearance] setSelectedAttributeDictionary:@{NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName:[UIColor grayColor]}];
//    [[YTSegmentedControl appearance] setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
//    [[YTSegmentedControl appearance] setItemWidth:80];
//
//  实例
//    YTSegmentedItem *activity = [[YTSegmentedItem alloc] initWithTitle:NSLocalizedString(@"activity", nil) image:[UIImage imageNamed:@"activity"] selectImage:[UIImage imageNamed:@"activity"]];
//    YTSegmentedItem *product = [[YTSegmentedItem alloc] initWithTitle:NSLocalizedString(@"product", nil) image:[UIImage imageNamed:@"product"] selectImage:[UIImage imageNamed:@"product"]];
//    YTSegmentedItem *video = [[YTSegmentedItem alloc] initWithTitle:NSLocalizedString(@"video", nil) image:[UIImage imageNamed:@"video"] selectImage:[UIImage imageNamed:@"video"]];
//    YTSegmentedItem *top = [[YTSegmentedItem alloc] initWithTitle:NSLocalizedString(@"top", nil) image:[UIImage imageNamed:@"top"] selectImage:[UIImage imageNamed:@"top"]];
//
//    activity.itemLayout = product.itemLayout = video.itemLayout = top.itemLayout = YTSegmentedItemLayoutIconAtRight;
//    activity.iconTitleGap = product.iconTitleGap = video.iconTitleGap = top.iconTitleGap = 15;
//
//    _segmented = [[YTSegmentedControl alloc] initWithItems:@[activity, product, video, top]];
//    _segmented.frame = CGRectMake(0, 0, self.view.width, 110);
//    _segmented.normalAttributeDictionary = @{NSFontAttributeName:[UIFont systemFontOfSize:13], NSForegroundColorAttributeName:[UIColor colorWithRGBA:0x666666ff]};
//    _segmented.selectedAttributeDictionary = @{NSFontAttributeName:[UIFont systemFontOfSize:13], NSForegroundColorAttributeName:[UIColor colorWithRGBA:0x666666ff]};
//    [_segmented addTarget:self action:@selector(segmentedSelected:) forControlEvents:UIControlEventValueChanged];
//
//  Created by songyutao on 14-11-25.
//  Copyright (c) 2014年 Creditease. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YTSegmentedItemLayout)
{
    YTSegmentedItemLayoutIconAtLeft,
    YTSegmentedItemLayoutIconAtTop,
    YTSegmentedItemLayoutIconAtRight,
    YTSegmentedItemLayoutIconAtBottom,
};

@interface YTSegmentedItem : NSObject

- (id)initWithTitle:(NSString *)title image:(UIImage *)image selectImage:(UIImage *)selectImage;

@property(nonatomic, strong)UIImage         *image;
@property(nonatomic, strong)UIImage         *selectImage;
@property(nonatomic, strong)NSString        *title;
@property(nonatomic, assign)YTSegmentedItemLayout   itemLayout;
@property(nonatomic, assign)CGFloat         iconTitleGap;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface YTSegmentedControl : UIControl

@property(nonatomic, assign)UIEdgeInsets    contentEdgeInsets                   UI_APPEARANCE_SELECTOR;
@property(nonatomic, copy  )UIColor         *tintColor                          UI_APPEARANCE_SELECTOR;
@property(nonatomic, copy  )NSDictionary    *normalAttributeDictionary          UI_APPEARANCE_SELECTOR;//support NSFontAttributeName and NSForegroundColorAttributeName
@property(nonatomic, copy  )NSDictionary    *selectedAttributeDictionary        UI_APPEARANCE_SELECTOR;
@property(nonatomic, copy  )UIImage         *normalItemBgImage                  UI_APPEARANCE_SELECTOR;
@property(nonatomic, copy  )UIImage         *selectedItemBgImage                UI_APPEARANCE_SELECTOR;
@property(nonatomic, assign)CGFloat         contentCorner;
@property(nonatomic, assign)CGFloat         itemGap                             UI_APPEARANCE_SELECTOR;//default : 0
@property(nonatomic, assign)CGFloat         itemWidth                           UI_APPEARANCE_SELECTOR;//default : 60，If this value is multiplied by the item number less than contentview, the value will be re calculated.
@property(nonatomic, assign)BOOL            dynamicItemWidth                    UI_APPEARANCE_SELECTOR;//default : YES，dynamic calculation item width

@property(nonatomic, strong)UIView          *backgroundView;
@property(nonatomic, assign)NSUInteger      selectedIndex;

- (id)initWithItems:(NSArray *)items;

- (void)addItem:(YTSegmentedItem *)item atIndex:(NSUInteger)index;

- (void)clearItem;

- (void)onlySetSelectedIndex:(NSUInteger)index;//just change the current selected index, does not send UIControlEventValueChanged event.

@end
