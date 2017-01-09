
#import "ViewPetSrvSrchType.h"
@interface ViewPetSrvSrchType () {
    IBOutlet UIView *viewSelLoc;
    IBOutlet UIView *viewMyPos;
    IBOutlet UIView *viewByAddr;
}
@end

@implementation ViewPetSrvSrchType

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(tapViewPetSrvSelLoc)];
    viewSelLoc.userInteractionEnabled = YES;
    [viewSelLoc addGestureRecognizer:tap];

    UITapGestureRecognizer *tapMyPos = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(tapViewPetSrvMyPos)];
    viewMyPos.userInteractionEnabled = YES;
    [viewMyPos addGestureRecognizer:tapMyPos];

    UITapGestureRecognizer *tapByAddr = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                               action:@selector(tapViewPetSrvByAddr)];
    viewByAddr.userInteractionEnabled = YES;
    [viewByAddr addGestureRecognizer:tapByAddr];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.myNavigationBar.titolo = @"#petSrvSrcType.title";
}

- (void) tapViewPetSrvSelLoc {
    [self showTapOnWiew:viewSelLoc];
    [self performSegueWithIdentifier:@"SelectCity" sender:self];
}

- (void) tapViewPetSrvMyPos {
    [self showTapOnWiew:viewMyPos];
    [self performSegueWithIdentifier:@"SrchMyPos" sender:self];
}

- (void) tapViewPetSrvByAddr {
    [self showTapOnWiew:viewByAddr];
    [self performSegueWithIdentifier:@"SrchByAddr" sender:self];
}

- (void) showTapOnWiew:(UIView *) viewTapped {
    UIColor *color = viewTapped.backgroundColor;
    viewTapped.backgroundColor = [UIColor whiteColor];
    [UIView animateWithDuration:0.3f
                     animations:^{
                         viewTapped.backgroundColor = color;
                     }
                     completion:^(BOOL fine) {
                     }];
}

- (void) pushViewCtrl:(NSString *) strViewCtrl {
    UIViewController *ctrl = [self.storyboard instantiateViewControllerWithIdentifier:strViewCtrl];
    [self.navigationController showViewController:ctrl sender:self];
}
@end
