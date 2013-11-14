//
//  ViewController.m
//  JCMenuSample
//
//  Created by Jean-Baptiste Castro on 17/09/2013.

#import "ViewController.h"

#import "JCMenu.h"
#import "JCMenuItem.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*
     Without selected image
     */
    
//    JCMenuItem *menu1 = [[JCMenuItem alloc] initWithImage:[UIImage imageNamed:@"menu1"] selectedImage:nil action:^(JCMenuItem *item){
//        [self.textLabel setText:@"Menu 1"];
//    }];
//    
//    JCMenuItem *menu2 = [[JCMenuItem alloc] initWithImage:[UIImage imageNamed:@"menu2"] selectedImage:nil action:^(JCMenuItem *item){
//        [self.textLabel setText:@"Menu 2"];
//    }];
//    
//    JCMenuItem *menu3 = [[JCMenuItem alloc] initWithImage:[UIImage imageNamed:@"menu3"] selectedImage:nil action:^(JCMenuItem *item){
//        [self.textLabel setText:@"Menu 3"];
//    }];
//    
//    JCMenuItem *menu4 = [[JCMenuItem alloc] initWithImage:[UIImage imageNamed:@"menu4"] selectedImage:nil action:^(JCMenuItem *item){
//        [self.textLabel setText:@"Menu 4"];
//    }];
    
    /*
     With selected image
     */
    
    JCMenuItem *menu1 = [[JCMenuItem alloc] initWithImage:[UIImage imageNamed:@"menu1"] selectedImage:[UIImage imageNamed:@"menu1_selected"] action:^(JCMenuItem *item){
        [self.textLabel setText:@"Menu 1"];
    }];
    
    JCMenuItem *menu2 = [[JCMenuItem alloc] initWithImage:[UIImage imageNamed:@"menu2"] selectedImage:[UIImage imageNamed:@"menu2_selected"] action:^(JCMenuItem *item){
        [self.textLabel setText:@"Menu 2"];
    }];
    
    JCMenuItem *menu3 = [[JCMenuItem alloc] initWithImage:[UIImage imageNamed:@"menu3"] selectedImage:[UIImage imageNamed:@"menu3_selected"] action:^(JCMenuItem *item){
        [self.textLabel setText:@"Menu 3"];
    }];
    
    JCMenuItem *menu4 = [[JCMenuItem alloc] initWithImage:[UIImage imageNamed:@"menu4"] selectedImage:[UIImage imageNamed:@"menu4_selected"] action:^(JCMenuItem *item){
        [self.textLabel setText:@"Menu 4"];
    }];
    
    JCMenu *menu = [[JCMenu alloc] initWithFrame:CGRectMake(10, self.view.frame.size.height - 60, self.view.frame.size.width - 20, 50) items:@[menu1, menu2, menu3, menu4]];
    [menu setSelectedItem:menu1];
    [menu setMenuTintColor:[UIColor colorWithWhite:0 alpha:0.1]];
    [self.view addSubview:menu];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
