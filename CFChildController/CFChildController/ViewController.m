//
//  ViewController.m
//  CFChildController
//
//  Created by crw on 11/15/15.
//  Copyright © 2015 crw. All rights reserved.
//

#import "ViewController.h"
#import "CFSegment.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "Masonry.h"

@interface ViewController ()<CFSegmentDelegate>

@property (nonatomic, strong) CFSegment               *segment;

@property (nonatomic, strong) FirstViewController     *firstVc;
@property (nonatomic, strong) SecondViewController    *secondVc;
@property (nonatomic, strong) ThirdViewController     *thirdVc;
@property (nonatomic, strong) UIViewController        *lastVc;

@property (nonatomic, strong) UIView                  *mainView;
@end

@implementation ViewController{
    BOOL flag;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Demo";
    
    [self.view addSubview:self.segment];
    [self.segment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(64);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(44));
    }];
    
    [self.view addSubview:self.mainView];
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.segment.mas_bottom);
    }];

    
    self.firstVc = [FirstViewController new];
    [self addChildViewController:self.firstVc];
    self.firstVc.view.frame = self.mainView.bounds;
    [self.mainView addSubview:self.firstVc.view];
    
    [self.firstVc  didMoveToParentViewController:self];
    self.lastVc = self.firstVc;
    NSLog(@"%@",self.view);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cf_segmentChangeIndex:(NSInteger)index{
    
    UIViewController *toViewController;
    
    switch (index) {
        case 0:
            toViewController = self.firstVc;
            break;
        case 1:
            toViewController = self.secondVc;
            break;
        case 2:
            toViewController = self.thirdVc;
            break;
            
        default:
            break;
    }
    
    if (![self.lastVc isEqual:toViewController]) {
        [self transFromViewController:self.lastVc toViewController:toViewController];
        self.lastVc = toViewController;
    }
}

- (void) transFromViewController:(UIViewController*) fromController toViewController:(UIViewController*) toController{
    
    dispatch_after(0, dispatch_get_main_queue(), ^(void){
        
        toController.view.frame = fromController.view.bounds;
        [self addChildViewController:toController];
        [fromController willMoveToParentViewController:nil];
        
        [self transitionFromViewController:fromController
                          toViewController:toController
                                  duration:0.2
                                   options:UIViewAnimationOptionCurveEaseIn
                                animations:nil
                                completion:^(BOOL finished) {
                                    
                                    [toController didMoveToParentViewController:self];
                                    [fromController removeFromParentViewController];
                                    
                                }];
    });
}

- (CFSegment *)segment{
    if (!_segment) {
        _segment = ({
            CFSegment *segment = [[CFSegment alloc] initWithTitleArray:@[@"第一个",@"第二个",@"第三个"] segmentHeight:44];
            segment.backgroundColor = [UIColor whiteColor];
            segment.delegate   = self;
            segment;
        });
    }
    return _segment;
}

- (FirstViewController *)firstVc{
    if (!_firstVc) {
        _firstVc = ({
            FirstViewController *vc = [FirstViewController new];
           
            [self addChildViewController:vc];
            [self.mainView addSubview:vc.view];
            
            vc;
        });
    }
    return _firstVc;
}

- (SecondViewController *)secondVc{
    if (!_secondVc) {
        _secondVc = ({
            [SecondViewController new];
        });
    }
    return _secondVc;
}

- (ThirdViewController *)thirdVc{
    if (!_thirdVc) {
        _thirdVc = ({
            [ThirdViewController new];
        });
    }
    return _thirdVc;
}

- (UIView *)mainView{
    if (!_mainView) {
        _mainView = ({
            UIView *view = [UIView new];
            view.backgroundColor = [UIColor greenColor];
            view;
        });
    }
    return _mainView;
}
@end
