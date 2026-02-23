//
//  UIView+testView.m
//  QuranHindi
//
//  Created by Karan Champ on 03/10/17.
//  Copyright © 2017 Redixbit. All rights reserved.
//

#import "UIView+testView.h"
#import "Constants.h"

@implementation UIView (testView)
@dynamic borderColor,borderWidth,cornerRadius,masksToBounds,autoHeightWidth,shadowColor,shadowOffset,shadowRadius,shadowOpacity,shadowPath;

-(void)setBorderColor:(UIColor *)borderColor{
    [self.layer setBorderColor:borderColor.CGColor];
}

-(void)setBorderWidth:(CGFloat)borderWidth{
    [self.layer setBorderWidth:borderWidth];
}
-(void)setShadowColor:(UIColor *)shadowColor
{
    self.layer.shadowColor = shadowColor.CGColor;
}
-(void)setShadowOffset:(CGSize)shadowOffset
{
    self.layer.shadowOffset = shadowOffset;
}
-(void)setShadowRadius:(CGFloat)shadowRadius
{
    self.layer.shadowRadius = shadowRadius;
}
-(void)setShadowOpacity:(CGFloat)shadowOpacity
{
    self.layer.shadowOpacity = shadowOpacity;
}
-(void)setShadowPath:(BOOL)shadowPath
{
    if (shadowPath)
    {
        self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    }
}

-(void)setCornerRadius:(NSString*)cornerRadiu{
    
    if ([cornerRadiu isEqualToString:@"circle"])
        [self.layer setCornerRadius:self.frame.size.height / 2];
    else
        [self.layer setCornerRadius:[cornerRadiu floatValue]];
}

-(void)setMasksToBounds:(BOOL)masksToBounds{
    [self.layer setMasksToBounds:masksToBounds];
}
-(void)setAutoHeightWidth:(BOOL)autoHeightWidth
{
//    NSLog(@"Testing : %@",NSStringFromCGRect([UIScreen mainScreen].bounds));
    NSLog(@"Testing : %@",NSStringFromCGRect(self.frame));
    if (autoHeightWidth)
    {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, (self.frame.size.height/320.0)*SCREEN_SIZE.width);
    }

    NSLog(@"Testing : %@",NSStringFromCGRect(self.frame));
}
@end

@implementation UILabel (testView)
@dynamic autoFontSize;

-(void)setAutoFontSize:(BOOL)autoFontSize
{
    self.font = [UIFont fontWithName:self.font.fontName size:(self.font.pointSize / ScreenWidth) * SCREEN_SIZE.width];
}
@end
@implementation UIButton (testView1)
@dynamic autoFontSize,TemplateImage,aspectFit;
-(void)setAspectFit:(BOOL)aspectFit
{
    if (aspectFit)
    {
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    }
}
-(void)setTemplateImage:(BOOL)TemplateImage
{
    if (TemplateImage)
    {
        [self setImage:[self.currentImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    }
}

-(void)setAutoFontSize:(BOOL)autoFontSize
{
    if (autoFontSize)
    {
        self.titleLabel.font = [UIFont fontWithName:self.titleLabel.font.fontName size:(self.titleLabel.font.pointSize / ScreenWidth) * SCREEN_SIZE.width];
    }
}
@end
@implementation UIImageView (testView1)
@dynamic TemplateImage;
-(void)setTemplateImage:(BOOL)TemplateImage
{
    if (TemplateImage)
    {
        self.image = [self.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
}
@end

@implementation UITextField (padding)
@dynamic padding, autoFontSize;
-(void)setPadding:(CGFloat)padding
{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, padding, 0)];
    self.leftView = paddingView;
    self.leftViewMode = UITextFieldViewModeAlways;
}
-(void)setAutoFontSize:(BOOL)autoFontSize
{
    if (autoFontSize)
    {
        self.font = [UIFont fontWithName:self.font.fontName size:(self.font.pointSize / ScreenWidth) * SCREEN_SIZE.width];
    }
}
@end
@implementation UITextView (autoFont)
@dynamic autoFontSize;

-(void)setAutoFontSize:(BOOL)autoFontSize
{
    if (autoFontSize)
    {
        self.font = [UIFont fontWithName:self.font.fontName size:(self.font.pointSize / ScreenWidth) * SCREEN_SIZE.width];
    }
}
@end

@implementation NSLayoutConstraint (autoConstant)
@dynamic autoConstant;

-(void)setAutoConstant:(BOOL)autoConstant
{
    if (autoConstant)
    {
        self.constant = (self.constant / ScreenWidth) * SCREEN_SIZE.width;
    }
}
@end

