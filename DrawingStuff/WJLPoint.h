@class WJLDrawing;

@interface WJLPoint : NSManagedObject

@property (strong, nonatomic) NSNumber *x;
@property (strong, nonatomic) NSNumber *y;
@property (strong, nonatomic) WJLPoint *nextPoint;
@property (strong, nonatomic) WJLPoint *previousPoint;
@property (strong, nonatomic) WJLDrawing *drawing;
@property (strong, nonatomic) UIColor *color;

@end
