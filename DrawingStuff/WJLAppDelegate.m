#import "WJLAppDelegate.h"

#import "WJLDrawing.h"
#import "WJLPoint.h"

#import "WJLDrawingViewController.h"

@implementation WJLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSManagedObjectContext *moc = [self managedObjectContext];

    NSEntityDescription *drawingEntityDescription = [NSEntityDescription entityForName:@"WJLDrawing"
                                                                inManagedObjectContext:moc];
    NSEntityDescription *pointEntityDescription = [NSEntityDescription entityForName:@"WJLPoint"
                                                              inManagedObjectContext:moc];


    WJLDrawing *drawing = [[WJLDrawing alloc] initWithEntity:drawingEntityDescription insertIntoManagedObjectContext:moc];
    [moc save:nil];

    WJLPoint *point, *nextPoint;
    for (int i = 0; i < 1000; i++) {
        point = [[WJLPoint alloc] initWithEntity:pointEntityDescription insertIntoManagedObjectContext:moc];
        point.drawing = drawing;

        // Taste the rainbow
        point.color = @[
            [UIColor redColor],
            [UIColor orangeColor],
            [UIColor yellowColor],
            [UIColor greenColor],
            [UIColor blueColor],
            [UIColor purpleColor]
        ][arc4random() % 6];

        point.x = @(arc4random() % 768);
        point.y = @(arc4random() % 1024);

        point.nextPoint = nextPoint;
        nextPoint.previousPoint = point;
        nextPoint = point;
    }

    drawing.firstPoint = point;

    [moc save:nil];

    // -----

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    self.window.rootViewController = [[WJLDrawingViewController alloc] initWithNibName:@"WJLDrawingViewController" bundle:nil];

    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [[self managedObjectContext] save:nil];
}

#pragma mark - Core Data stack

- (NSManagedObjectContext *)managedObjectContext
{
    static NSManagedObjectContext *_managedObjectContext;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:[self persistentStoreCoordinator]];
    });
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    static NSManagedObjectModel *_managedObjectModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DrawingStuff" withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    });
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    static NSPersistentStoreCoordinator *_persistentStoreCoordinator;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"DrawingStuff.sqlite"];

        NSError *error = nil;
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
    });
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
