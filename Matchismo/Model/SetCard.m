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
    
    // implements the logic for comparing cards
    
    return score;
}

-(NSString *)contents
{
    NSString *shape = nil;
    for (int i = 1; i < self.number; i++) {
        shape = [self.shape stringByAppendingString:self.shape];
    }
    
    return [NSString stringWithFormat:@"%@, %@, %@",shape,self.color,self.shading];
}

-(NSString *)description
{
    return self.contents;
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
