//
//  VybeUtil.h
//  Vybe
//
//  Created by Ryan Quinn on 2/18/14.
//  Copyright (c) 2014 vybe. All rights reserved.
//

#ifndef Vybe_VybeUtil_h
#define Vybe_VybeUtil_h


#define UIColorFromRGB(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]


#define PURP 0xAB57FE

#define DRK_BLUE 0x21496B

#define LT_BLUE 0x85B7FF

#define VYBE_FONT(s) [UIFont fontWithName:@"Circula-Medium" size:s]

//Color definitions

#define BG_COL 0xB4D6E0

#define BABY_BLUE 0x89cff0 // 137 , 207 , 240

#define HOT_PINK 0xF4C2C2 // 244 , 192, 192

#define WET_ASPHALT 0x34495E
#define NEPHRITIS 0x27ae60
#define EMERALD 0x2ecc71

#define MIDNIGHT_BLUE 0x2c3e50 // 44 62 80

#define CONCRETE 0x95a5a6 // 149 165 166

#define CLOUDS 0xecf0f1
#define SILVER 0x7f8c8d
#define TURQUOISE 0x1abc9c
#define POMEGRANATE 0xc0392b

#define WISTERIA 0x8e44ad

#define ALIZARIN 0xe74c3c

#define MASCOT_IMG @"VybeMascot.jpg"

#define NEARBY_CAT_IMG @"map-small.png"


#define ATMOS_CAT_IMG @"atmos-small.png"
#define ATMOS_LOW_IMG @"beer2-small.png"
#define ATMOS_HIGH_IMG @"dancing-small.png"


#define RATIO_LOW_IMG @"guy-small.png"
#define RATIO_HIGH_IMG @"girl-small.png"

#define WAIT_CAT_IMG @"red_carpet-small.png"
#define WAIT_HIGH_IMG @"line-small.png"
#define WAIT_LOW_IMG @"noline-small.png"

#define CROWD_CAT_IMG @"crowd-cat-small.png"
#define CROWD_LOW_IMG @"nocrowd-small.png"
#define CROWD_HIGH_IMG @"crowded-small.png"

#define RATIO_CAT_IMG @"gender-small.png"

#define COVER_CAT_IMG @"2_dollar-small.png"

#endif
