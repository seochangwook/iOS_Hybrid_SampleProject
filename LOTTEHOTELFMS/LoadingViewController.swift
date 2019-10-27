//
//  SplashViewController.swift
//  LOTTEHOTELFMS
//
//  Created by seo on 2019/10/27.
//  Copyright © 2019 seo. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        print("splash viewDidLoad Call")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        print("splash viewDidAppear Call")
        
        var settingviewcode = 1
               
        if(settingviewcode == 1){
            print("settingview move")
                   
            performSegue(withIdentifier: "settingview", sender: self)
        } else if(settingviewcode == 2){
            print("mainwebview move")
                   
            performSegue(withIdentifier: "mainwebview", sender: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //스토리보드 이동(Modal, Push(Navigation)방식 모두 prepare에서 한다.)//
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        //이동할 스토리보드의 id저장.값이 변할 수 있는 것은 가변타입(var)로 한다. 고정값(상수)이면 let//
        var segue_id : String = ""
        segue_id = segue.identifier!
        
        //identifier값으로 비교한다.//
        print("segue id : ", segue_id+" id")
    
        //스토리보드의 id값을 가지고 이동할 스토리보드를 선택한다.//
        if(segue_id == "settingview")
        {
            print("settingview move")
        } else if(segue_id == "mainwebview"){
            print("mainview move")
        }
    }
}
