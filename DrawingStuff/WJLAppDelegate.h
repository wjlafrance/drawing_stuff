@interface WJLAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (NSManagedObjectContext *)managedObjectContext;

@end
