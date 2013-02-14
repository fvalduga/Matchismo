//
//  SetCard.h
//  Matchismo
//
//  Created by Felipe Valduga on 2/13/13.
//  Copyright (c) 2013 Felipe Valduga. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card

@property (nonatomic) NSUInteger number;
@property (strong,nonatomic) NSString *color;
@property (strong, nonatomic) NSString *shape;
@property (strong, nonatomic) NSString *shading;

+(NSArray *)validColors;
+(NSArray *)validShapes;
+(NSArray *)validShadings;


@end
