//
//  MyBaseViewController.m
//

#import "MyBaseViewController.h"
//#import "MyNavigationBarDelegate.h"

@implementation MyBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myNavigationBar = (MYNavigationBar *) self.navigationController.navigationBar;
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.myNavigationBar.hidden = NO;
    if (self.titolo) {
        self.myNavigationBar.titolo = self.titolo;
    }
    else {
        self.myNavigationBar.titolo = @"";
    }
    self.myNavigationBar.barDelegate = self;

    if (self.dxIcon) {
        self.myNavigationBar.optionButtonImage = self.dxIcon;
        self.myNavigationBar.dxButton.hidden = NO;
    }
    else {
        self.myNavigationBar.dxButton.hidden = YES;
    }
    self.myNavigationBar.backButtonImage = [UIImage imageNamed:@"Back"];
}

#pragma mark -

- (void) myNavigatorBackButtonTapped {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) myNavigatorOptionButtonTapped {
    NSLog(@"myNavigatorOptionButtonTapped");
}

@end
