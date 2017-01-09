
#import "ViewCamClick.h"
#import "ClsSettings.h"

@interface ViewCamClick () <MyNavigationBarDelegate> {
    IBOutlet UIButton *btnUse;
    IBOutlet UIImageView *imvCaptured;
}
@end

@implementation ViewCamClick

- (void)viewDidLoad {
    [super viewDidLoad];

    [btnUse setTitle:keyLang(@"viewCamClick.Use") forState:UIControlStateNormal];
    imvCaptured.contentMode = UIViewContentModeScaleAspectFit;
    imvCaptured.image = self.imgCaptured;
    imvCaptured.backgroundColor = [MyColor myGreyLight];
    
#if TARGET_IPHONE_SIMULATOR
//    [self gotoNext];
#endif
}

- (void) myNavigatorBackButtonTapped {
#if TARGET_IPHONE_SIMULATOR
    [self.navigationController popToRootViewControllerAnimated:YES];
#else
    [self.navigationController popViewControllerAnimated:YES];
#endif
}

- (IBAction) gotoNext {
    [self performSelectorInBackground:@selector(saveInBackground) withObject:nil];
    [self performSegueWithIdentifier:@"ViewFotoInfo" sender:self];
}

- (void) saveInBackground {
    NSData *dat = UIImageJPEGRepresentation(self.imgCaptured, 0.8);
    [ClsSettings setObj:@[ dat ] ForKey:userArrayDataForPicsToUpload];
}
@end
