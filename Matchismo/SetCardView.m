//
//  SetCardView.m
//  Matchismo
//
//  Created by Felipe Valduga on 3/13/13.
//  Copyright (c) 2013 Felipe Valduga. All rights reserved.
//

#import "SetCardView.h"

@implementation SetCardView

- (void)setNumber:(NSUInteger)number
{
    _number = number;
    
    if (number < 1) _number = 1;
    else if (number > 3) _number = 3;
    
    [self setNeedsDisplay];
}

- (void)setSymbol:(NSString *)symbol
{
    _symbol = symbol;
    [self setNeedsDisplay];
}

- (void)setColor:(UIColor *)color
{
    _color = color;
    [self setNeedsDisplay];
}

- (void)setShading:(NSString *)shading
{
    _shading = shading;
    [self setNeedsDisplay];
}

- (void)setFaceUp:(BOOL)faceUp
{
    _faceUp = faceUp;
    [self setNeedsDisplay];
}

#define CORNER_RADIUS 0.1 //percent of view bounds width


#define HORIZONTAL_MARGIN 0.2 //Percent of view bounds width
#define SYMBOL_HEIGHT 0.2 //Percent of view bounds height
#define SYMBOL_OFFSET 0.05 //Percent of view bounds height

#define STROKE_WIDTH 1.0
#define STRIPE_LINE_GAP 0.1

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.bounds.size.width * CORNER_RADIUS];
    
    [roundedRect addClip];
    
    UIColor *backgroundColor = (self.faceUp) ? [UIColor colorWithWhite:0.75 alpha:1.0] : [UIColor whiteColor];
    
    [backgroundColor setFill];
    UIRectFill(self.bounds);
    
    [self.color setFill];
    [self.color setStroke];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    
    CGRect symbolRect = CGRectInset(self.bounds, self.bounds.size.width * HORIZONTAL_MARGIN, self.bounds.size.height * SYMBOL_HEIGHT * 2);
    
    UIBezierPath *symbolPath = [self drawSymbolInRect:symbolRect];
    [symbolPath setLineWidth:STROKE_WIDTH];
    
    // Translate context to start position according to total number of symbols
    CGFloat initialHeightOffset = 0.0;
    
    if (self.number == 2) initialHeightOffset = self.bounds.size.height * (SYMBOL_OFFSET + SYMBOL_HEIGHT) / 2;
    else if (self.number == 3) initialHeightOffset = self.bounds.size.height * (SYMBOL_OFFSET + SYMBOL_HEIGHT);
    
    CGContextTranslateCTM(context, 0.0 , - initialHeightOffset);
    
    for (int i = 0 ;  i < self.number ; i++) {
        
        if ([self.shading isEqualToString:@"open"]) {
            [symbolPath stroke];
        } else if ([self.shading isEqualToString:@"solid"]) {
            [symbolPath fill];
        } else if ([self.shading isEqualToString:@"striped"]) {
            [symbolPath stroke];
            CGContextSaveGState(context);
            [symbolPath addClip];
            [self drawStripes:symbolPath.bounds];
            CGContextRestoreGState(context);
        }
        
        CGContextTranslateCTM(context, 0.0 , self.bounds.size.height * (SYMBOL_OFFSET + SYMBOL_HEIGHT));
    }
    
    CGContextRestoreGState(context);
    
}

- (UIBezierPath *)drawSymbolInRect: (CGRect)rect
{
    UIBezierPath *symbolPath = nil;
    
    if ([self.symbol isEqualToString:@"diamond"]) {
        symbolPath = [self drawDiamondSymbolInRect:rect];
    } else if ([self.symbol isEqualToString:@"squiggle"]) {
        symbolPath = [self drawSquiggleSymbolInRect:rect];
    } else if ([self.symbol isEqualToString:@"oval"]) {
        symbolPath = [self drawOvalSymbolInRect:rect];
    }
    
    return symbolPath;
}

- (UIBezierPath *)drawDiamondSymbolInRect: (CGRect)rect
{
    UIBezierPath *diamondShape = [UIBezierPath bezierPath];
    
    [diamondShape moveToPoint:CGPointMake(rect.origin.x, rect.origin.y + rect.size.height * 0.5)];
    [diamondShape addLineToPoint:CGPointMake(rect.origin.x + rect.size.width * 0.5, rect.origin.y)];
    [diamondShape addLineToPoint:CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height * 0.5)];
    [diamondShape addLineToPoint:CGPointMake(rect.origin.x + rect.size.width * 0.5, rect.origin.y + rect.size.height)];
    [diamondShape closePath];
    
    return diamondShape;
}

- (UIBezierPath *)drawOvalSymbolInRect: (CGRect)rect
{
    UIBezierPath *ovalShape = [UIBezierPath bezierPath];
    
    [ovalShape moveToPoint:CGPointMake(rect.origin.x + rect.size.width * 0.25, rect.origin.y)];
    [ovalShape addLineToPoint:CGPointMake(rect.origin.x + rect.size.width * 0.75, rect.origin.y)];
    
    [ovalShape addArcWithCenter:CGPointMake(rect.origin.x + rect.size.width * 0.75, rect.origin.y + rect.size.height * 0.5)
                         radius:rect.size.height * 0.5
                     startAngle: 3 * M_PI / 2
                       endAngle: M_PI / 2
                      clockwise:YES];
    
    [ovalShape addLineToPoint:CGPointMake(rect.origin.x + rect.size.width * 0.25, rect.origin.y + rect.size.height)];
    
    [ovalShape addArcWithCenter:CGPointMake(rect.origin.x + rect.size.width * 0.25, rect.origin.y + rect.size.height * 0.5)
                         radius:rect.size.height * 0.5
                     startAngle: M_PI / 2
                       endAngle: 3 * M_PI / 2
                      clockwise:YES];
    
    return ovalShape;
}

- (UIBezierPath *)drawSquiggleSymbolInRect: (CGRect)rect
{
    UIBezierPath *squiggleShape = [UIBezierPath bezierPath];
    
    //Rect is divided by 8 (width) by 8 segments (height) to distribute the points and control points
    
    [squiggleShape moveToPoint:CGPointMake(rect.origin.x , rect.origin.y + rect.size.height * 0.5)];
    [squiggleShape addCurveToPoint:CGPointMake(rect.origin.x + rect.size.width * 0.25, rect.origin.y + rect.size.height * 0.125)
                     controlPoint1:CGPointMake(rect.origin.x, rect.origin.y + rect.size.height * 0.25)
                     controlPoint2:CGPointMake(rect.origin.x + rect.size.width * 0.125, rect.origin.y + rect.size.height * 0.125)];
    
    [squiggleShape addCurveToPoint:CGPointMake(rect.origin.x + rect.size.width * 0.625, rect.origin.y + rect.size.height * 0.25)
                     controlPoint1:CGPointMake(rect.origin.x + rect.size.width * 0.365, rect.origin.y + rect.size.height * 0.125)
                     controlPoint2:CGPointMake(rect.origin.x + rect.size.width * 0.5, rect.origin.y + rect.size.height * 0.25)];
    
    [squiggleShape addCurveToPoint:CGPointMake(rect.origin.x + rect.size.width * 0.875, rect.origin.y)
                     controlPoint1:CGPointMake(rect.origin.x + rect.size.width * 0.75, rect.origin.y + rect.size.height * 0.25)
                     controlPoint2:CGPointMake(rect.origin.x + rect.size.width * 0.75, rect.origin.y)];
    
    [squiggleShape addCurveToPoint:CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height * 0.5)
                     controlPoint1:CGPointMake(rect.origin.x + rect.size.width, rect.origin.y)
                     controlPoint2:CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height * 0.25)];
    
    [squiggleShape addCurveToPoint:CGPointMake(rect.origin.x + rect.size.width * 0.75, rect.origin.y + rect.size.height * 0.875)
                     controlPoint1:CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height * 0.75)
                     controlPoint2:CGPointMake(rect.origin.x + rect.size.width * 0.875, rect.origin.y + rect.size.height * 0.875)];
    
    [squiggleShape addCurveToPoint:CGPointMake(rect.origin.x + rect.size.width * 0.365, rect.origin.y + rect.size.height * 0.75)
                     controlPoint1:CGPointMake(rect.origin.x + rect.size.width * 0.625, rect.origin.y + rect.size.height * 0.875)
                     controlPoint2:CGPointMake(rect.origin.x + rect.size.width * 0.5, rect.origin.y + rect.size.height * 0.75)];
    
    [squiggleShape addCurveToPoint:CGPointMake(rect.origin.x + rect.size.width * 0.125, rect.origin.y + rect.size.height)
                     controlPoint1:CGPointMake(rect.origin.x + rect.size.width * 0.25, rect.origin.y + rect.size.height * 0.75)
                     controlPoint2:CGPointMake(rect.origin.x + rect.size.width * 0.25, rect.origin.y + rect.size.height)];
    
    [squiggleShape addCurveToPoint:CGPointMake(rect.origin.x, rect.origin.y + rect.size.height * 0.5)
                     controlPoint1:CGPointMake(rect.origin.x, rect.origin.y + rect.size.height)
                     controlPoint2:CGPointMake(rect.origin.x, rect.origin.y + rect.size.height * 0.75)];
    
    [squiggleShape closePath];
    
    
    return squiggleShape;
}

- (void) drawStripes:(CGRect)inRect;
{
    UIBezierPath *stripes = [UIBezierPath bezierPath];    
    CGFloat lineGap = inRect.size.width * STRIPE_LINE_GAP;
    
    for (CGFloat k = 0; k < inRect.size.width; k += lineGap) {
        [stripes moveToPoint:CGPointMake(inRect.origin.x + k, inRect.origin.y)];
        [stripes addLineToPoint:CGPointMake(inRect.origin.x + k, inRect.origin.y + inRect.size.height)];
    }
    [stripes stroke];
}

- (void)setup
{
    // do initialization here
}

- (void)awakeFromNib
{
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}


@end
