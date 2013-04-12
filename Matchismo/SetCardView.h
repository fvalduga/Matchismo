//
//  SetCardView.h
//  Matchismo
//
//  Created by Felipe Valduga on 3/13/13.
//  Copyright (c) 2013 Felipe Valduga. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetCardView : UIView

//Number should be an integer between 1 and 3
@property (nonatomic) NSUInteger number;

//Symbols are @"diamond", @"oval" or "squiggle"
@property (nonatomic, strong) NSString *symbol;

//Colors are @"red", @"green" or @"purple"
@property (nonatomic, strong) NSString *color;

//Shadings are @"open", @"solid" or @"striped"
@property (nonatomic, strong) NSString *shading;

@property (nonatomic) BOOL faceUp;

@end
