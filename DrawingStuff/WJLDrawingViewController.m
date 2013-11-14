#import "WJLDrawingViewController.h"

#import "WJLDrawing.h"
#import "WJLPoint.h"
#import "WJLDrawingView.h"
#import "WJLAppDelegate.h"

@implementation WJLDrawingViewController

- (void)viewDidAppear:(BOOL)animated
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        WJLAppDelegate *delegate = [UIApplication sharedApplication].delegate; // yuck
        NSManagedObjectContext *moc = [delegate managedObjectContext];
        NSFetchRequest *fetchReq = [NSFetchRequest fetchRequestWithEntityName:@"WJLDrawing"];
        WJLDrawing *drawing = [[moc executeFetchRequest:fetchReq error:nil] lastObject];
        [(WJLDrawingView *)self.view setDrawing:drawing];

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view setNeedsDisplay];
        });
    });
}

@end
