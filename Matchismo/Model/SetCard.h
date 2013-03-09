//
//  SetCard.h
//  Matchismo
//
//  Created by Felipe Valduga on 2/13/13.
//  Copyright (c) 2013 Felipe Valduga. All rights reserved.
//

#import "Card.h"
/*
 Set cards has four features: 
 
 - number (one, two, or three);
 - symbol (diamond, squiggle, oval);
 - shading (solid, striped, or open);
 - color (red, green, or purple).
 
*/


@interface SetCard : Card

@property (nonatomic) NSUInteger number;
@property (strong, nonatomic) NSString *symbol;
@property (strong, nonatomic) NSString *shading;
@property (strong,nonatomic) NSString *color;

+(NSArray *)validSymbols;
+(NSArray *)validShadings;
+(NSArray *)validColors;


@end
