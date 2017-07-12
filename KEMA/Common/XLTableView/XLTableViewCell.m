//
//  TestTableViewCell.m
//  CellFly
//
//  Created by 张雷 on 16/9/8.
//  Copyright © 2016年 ImanZhang. All rights reserved.
//


#import "XLTableViewCell.h"
#import "Color.h"

@interface XLTableViewCell()
{
    //NSNumber *transFromValue;
}
@end
@implementation XLTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)animationForIndexPath:(NSIndexPath *)indexPath direction:(ScrollDirection)direc duration:(NSTimeInterval)dur isExtend:(BOOL)isExtend{
    [self animationForIndexPath:indexPath direction:direc duration:dur isExtend:isExtend isInit:NO count:0];
}
- (void)animationForIndexPath:(NSIndexPath *)indexPath direction:(ScrollDirection)direc duration:(NSTimeInterval)dur isExtend:(BOOL)isExtend isInit:(BOOL)init count:(NSInteger)count{
    
    if (_forbidAnim == YES) {
        return;
    }
    
//    if (indexPath.row != 0) {
//        return;
//    }
    
    if (isExtend) {
        return;
    }
    
    CALayer *layer = self.layer;//[[self.layer sublayers] objectAtIndex:0];
    
    // Translation Animation
    CABasicAnimation *translationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    
    
    //if (indexPath.row == 0) {
//    if (init) {
//        translationAnimation.fromValue = @(58*(count+1)*(direc%2 == 1 ? 1:-1));//@((20*(2*count+1)+38)*(direc%2 == 1 ? 1:-1));
//    }else{
//        translationAnimation.fromValue = @(58*(direc%2 == 1 ? 1:-1));//@((20*(2*count+1)+38)*(direc%2 == 1 ? 1:-1));
//    }
    translationAnimation.fromValue = @(58*(count+1)*(direc%2 == 1 ? 1:-1));//@((20*(2*count+1)+38)*(direc%2 == 1 ? 1:-1));
    
        //transFromValue = translationAnimation.fromValue;
        //NSLog(@"main:%@", transFromValue);
        
    //}
    //NSLog(@"dir:%ld %@",direc,translationAnimation.fromValue);
    translationAnimation.toValue = @0.f;
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = dur;
    animationGroup.animations = @[ translationAnimation];
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [layer addAnimation:animationGroup forKey:@"spinAnimation"];
    
}

- (void)setSelect{
    self.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.layer.borderWidth = 2;
    [self setDeSelect];
}

- (void)setDeSelect{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.layer.borderWidth = 0;
    });
    
}

@end
