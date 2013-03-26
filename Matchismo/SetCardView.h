//
//  SetCardView.h
//  Matchismo
//
//  Created by Felipe Valduga on 3/13/13.
//  Copyright (c) 2013 Felipe Valduga. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetCardView : UIView

@property (nonatomic) NSUInteger number;
@property (nonatomic, strong) NSString *symbol;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) NSString *shading;
@property (nonatomic) BOOL faceUp;

@end
