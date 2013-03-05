//
//  SetCard.m
//  Matchismo
//
//  Created by Felipe Valduga on 2/13/13.
//  Copyright (c) 2013 Felipe Valduga. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard


-(int)match:(NSArray *)otherCards
{
    int score = 0;
   
    //Set of 3 cards
    if ([otherCards count] == 2) {
        
        BOOL numberMatched = NO;
        BOOL colorMatched = NO;
        BOOL shapeMatched = NO;
        BOOL shadingMatched = NO;
        
        SetCard *c1 = self;
        SetCard *c2 = nil;
        SetCard *c3 = nil;
        
        if ([otherCards[0] isKindOfClass:[SetCard class]]) {
            c2 = (SetCard *)otherCards[0];
        }
        if ([otherCards[1] isKindOfClass:[SetCard class]]) {
            c3 = (SetCard *)otherCards[1];
        }
        
        //check if numbers are the same or different from each other
        
        if ((c1.number == c2.number && c1.number == c3.number) || 
            (c1.number != c2.number && c1.number != c3.number && c2.number != c3.number)) { 
            numberMatched = YES;
        }
        
        //check if colors are the same or different from each other
        
        if (([c1.color isEqualToString:c2.color] && [c1.color isEqualToString:c3.color]) ||
            (![c1.color isEqualToString:c2.color] && ![c1.color isEqualToString:c3.color] && ![c2.color isEqualToString:c3.color])) {
            colorMatched = YES;
        }
        
        //check if shapes are the same or different from each other
        
        if (([c1.shape isEqualToString:c2.shape] && [c1.shape isEqualToString:c3.shape]) ||
            (![c1.shape isEqualToString:c2.shape] && ![c1.shape isEqualToString:c3.shape] && ![c2.shape isEqualToString:c3.shape])) {
            shapeMatched = YES;
        }
        
        //check if shading are the same or different from each other
        
        if (([c1.shading isEqualToString:c2.shading] && [c1.shading isEqualToString:c3.shading]) ||
            (![c1.shading isEqualToString:c2.shading] && ![c1.shading isEqualToString:c3.shading] && ![c2.shading isEqualToString:c3.shading])) {
            shadingMatched = YES;
        }
        
        
        if (numberMatched && colorMatched && shapeMatched && shadingMatched) {
            score = 2;
        }
        
        
    }
    
    return score;
}

//Return shapes
-(NSString *)contents
{
    return [self.shape stringByPaddingToLength:self.number withString:self.shape startingAtIndex:0];
}

-(NSString *)description
{
    return [self.contents stringByAppendingFormat:@"-%@-%@",self.color,self.shading];
}

+(NSArray *)validColors
{
    static NSArray *colors = nil;
    if (!colors) colors = @[@"red",@"green",@"blue"];
    return colors;
}

+(NSArray *)validShapes
{
    static NSArray *shapes = nil;
    if (!shapes) shapes = @[@"■",@"●",@"▲"];
    return shapes;
}

+(NSArray *)validShadings
{
    static NSArray *shadings = nil;
    if (!shadings) shadings = @[@"solid",@"faded",@"open"];
    return shadings;
}


-(void)setNumber:(NSUInteger)number
{
    _number = number;
    
    if (number < 1) _number = 1;
    else if (number > 3) _number = 3;
}

-(void)setColor:(NSString *)color
{
    if ([[SetCard validColors] containsObject:color]) {
        _color = color;
    }
}

-(void)setShape:(NSString *)shape
{
    if ([[SetCard validShapes] containsObject:shape]) {
        _shape = shape;
    }
}

-(void)setShading:(NSString *)shading
{
    if([[SetCard validShadings] containsObject:shading]) {
        _shading = shading;
    }
}




@end
