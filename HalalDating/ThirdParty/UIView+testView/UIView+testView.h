//
//  UIView+testView.h
//  QuranHindi
//
//  Created by Karan Champ on 03/10/17.
//  Copyright © 2017 Redixbit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (testView)
@property (nonatomic) IBInspectable UIColor *borderColor;
@property (nonatomic) IBInspectable CGFloat borderWidth;
@property (nonatomic) IBInspectable CGFloat shadowRadius;
@property (nonatomic) IBInspectable UIColor *shadowColor;
@property (nonatomic) IBInspectable CGSize shadowOffset;
@property (nonatomic) IBInspectable CGFloat shadowOpacity;
@property (nonatomic) IBInspectable BOOL shadowPath;

@property (nonatomic) IBInspectable NSString *cornerRadius;
@property (nonatomic) IBInspectable BOOL masksToBounds;

@property (nonatomic) IBInspectable BOOL autoHeightWidth;
@end

@interface UILabel (testView)

@property (nonatomic) IBInspectable BOOL autoFontSize;

@end

@interface UIButton (testView1)
@property (nonatomic) IBInspectable BOOL TemplateImage;
@property (nonatomic) IBInspectable BOOL aspectFit;
@property (nonatomic) IBInspectable BOOL autoFontSize;


@end

@interface UIImageView (testView1)
@property (nonatomic) IBInspectable BOOL TemplateImage;
@end

@interface UITextField (padding)
@property (nonatomic) IBInspectable CGFloat padding;
@property (nonatomic) IBInspectable BOOL autoFontSize;
@end

@interface UITextView (autoFont)
@property (nonatomic) IBInspectable BOOL autoFontSize;
@end

@interface NSLayoutConstraint (autoConstant)
@property (nonatomic) IBInspectable BOOL autoConstant;
@end
