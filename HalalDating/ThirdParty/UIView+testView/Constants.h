//
//  Header.h
//  FoodDelivery
//
//  Created by Redixbit on 29/09/16.
//  Copyright (c) 2016 ExpressTemplate. All rights reserved.
//


#ifndef FoodDelivery_Header_h
#define FoodDelivery_Header_h

#define DEFAULTS_KEY_LANGUAGE_CODE @"Language"
#define CustomLocalisedString(key, comment) \
[[LanguageManager sharedLanguageManager] getTranslationForKey:key]

#define country @"ar"
#define character 2



#define SERVERURL @""



#define SCREEN_SIZE [UIScreen mainScreen].bounds.size

#define listRow 7

//Iphone Model
#define iPhoneVersion ([[UIScreen mainScreen] bounds].size.height == 568 ? 5 : ([[UIScreen mainScreen] bounds].size.height == 480 ? 4 : ([[UIScreen mainScreen] bounds].size.height == 667 ? 6 : ([[UIScreen mainScreen] bounds].size.height == 736 ? 61 : ([[UIScreen mainScreen] bounds].size.height == 812 ? 10 : 999)))))

#define ScreenWidth (iPhoneVersion == 812 ? 375.0 : 320.0)
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define kDefaultEdgeInsets UIEdgeInsetsMake(5, 10, 5, 10)

#define NUMBERS @"0123456789"
#define ALPHABETS @" ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopwrstuvwxyz"

#define transitionDuration 0.5f


//OderStatus page Color
#define Color_light_grey  [UIColor colorWithRed:0.53 green:0.53 blue:0.53 alpha:1.0]
#define pickedcolor       [UIColor colorWithRed:0.95 green:0.38 blue:0.11 alpha:1.0]
#define greaySetting        [UIColor colorWithRed:0.33 green:0.33 blue:0.33 alpha:1.0]

#define RFontBoldItalic     @"OpenSans-BoldItalic"
#define RFontSemibold       @"OpenSans-Semibold"
#define RFontRegular        @"OpenSans"








#endif
