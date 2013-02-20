//
//  SetCardDeck.m
//  Matchismo
//
//  Created by Felipe Valduga on 2/13/13.
//  Copyright (c) 2013 Felipe Valduga. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardDeck

-(id) init
{
    self = [super self];
    
    if (self) {
        
        for (NSUInteger i = 1; i <= 3; i++) {
            for (NSString *shape in [SetCard validShapes]) {
                for (NSString *color in [SetCard validColors]) {
                    for (NSString *shading in [SetCard validShadings]) {
                        
                        SetCard *card = [[SetCard alloc] init];
                        
                        card.number = i;
                        card.shape = shape;
                        card.color = color;
                        card.shading = shading;
                        
                        [self addCard:card atTop:YES];
                    }
                }
            }
        }
        
    }
    
    return self;
}

@end
