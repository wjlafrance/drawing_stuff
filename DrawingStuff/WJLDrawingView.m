#import "WJLDrawingView.h"

#import "WJLDrawing.h"
#import "WJLPoint.h"

@implementation WJLDrawingView

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();

    CGContextSetLineWidth(ctx, 1.0);

    WJLPoint *point = self.drawing.firstPoint;
    do {
        // Begin the line at the source point
        CGContextMoveToPoint(ctx, [point.x doubleValue], [point.y doubleValue]);

        point = point.nextPoint;

        // Use the color indicated by the destination point
        CGContextSetStrokeColorWithColor(ctx, point.color.CGColor);

        // Put some random dashes in about half of the time
        if (arc4random() % 1 == 1) {
            CGFloat lengths[] = { arc4random() % 10, arc4random() % 10, arc4random() % 10, arc4random() % 10 };
            CGContextSetLineDash(ctx, 0, lengths, 4);
        } else {
            CGContextSetLineDash(ctx, 0, (CGFloat[]) { 1 }, 1);
        }

        // Draw the line
        CGContextAddLineToPoint(ctx, [point.x doubleValue], [point.y doubleValue]);
        CGContextStrokePath(ctx);

    } while (point.nextPoint != nil);
}

@end
