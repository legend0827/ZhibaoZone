//
//  CoreDataOperation.swift
//  ZhibaoZone
//
//  Created by Kevin on 26/12/2017.
//  Copyright © 2017 Kevin. All rights reserved.
//

import UIKit
import CoreData

class CoreDataOperation: NSObject {
    func getData(){
        
        //获取管理的数据上下文，对象
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        
        //声明数据的请求
        let fetchRequest =  NSFetchRequest<UserAccount>(entityName:"UserAccount")
//        fetchRequest.fetchLimit = 10 //限定查询结果的数量
//        fetchRequest.fetchOffset = 0 //查询到偏移量

        
        // 设置查询条件
        let predicate = NSPredicate(format: "recentFlag = 'true'", "")
        fetchRequest.predicate = predicate
        
        //查询操作
        do {
            let fetchedObjects = try managedObjectContext.fetch(fetchRequest)
            
            //遍历查询结果
            for info in fetchedObjects{
                //更新数据
                info.userName = ""
                try managedObjectContext.save()
            }
        } catch  {
            fatalError("获取失败")
        }
    }
    
    func saveToken(token:String) {
        //获取管理的数据上下文，对象
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        
        //声明数据的请求
        let fetchRequest =  NSFetchRequest<TokenRestored>(entityName:"TokenRestored")
        fetchRequest.returnsObjectsAsFaults = false

        //设置查询条件
        let predicate = NSPredicate(format: "id = 1")
        fetchRequest.predicate = predicate
        //创建User对象
        let TokenRestored = NSEntityDescription.insertNewObject(forEntityName: "TokenRestored", into: context) as! TokenRestored
        
        
        //查询操作
        do {
            let fetchResults = try context.fetch(fetchRequest)
            
            if fetchResults.count != 0 {
                for info in fetchResults{
                    info.id = 1
                    info.token = token
                    print("token updated")
                }
            }else{
                //对象赋值
                TokenRestored.token = token
                TokenRestored.id = 1
                try context.save()
            }
            try context.save()
            print("token inserted or updated")
        } catch {
            fatalError("保存失败\(error)")
        }
    }
    
    func saveAccountInfo(userName:String,nickName:String,userId:Int64,roleType:Int64,password:String) {
        //获取管理的数据上下文，对象
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        
        //声明数据的请求
        let fetchRequest =  NSFetchRequest<UserAccount>(entityName:"UserAccount")
        fetchRequest.returnsObjectsAsFaults = false
        // 设置查询条件
        let predicate = NSPredicate(format: "id = 1")
        fetchRequest.predicate = predicate
        
        //创建User对象
        let userAccount = NSEntityDescription.insertNewObject(forEntityName: "UserAccount", into: context) as! UserAccount
        //查询操作
        do {
            let fetchResults = try context.fetch(fetchRequest)
            if fetchResults.count == 0 {
                //对象赋值
                userAccount.id = 1
                userAccount.nickName = nickName.lowercased()
                userAccount.roleType = roleType
                userAccount.userId = userId
                userAccount.userName = userName
                userAccount.password = password
                print("inserted recoreds in userAccount")
            }else{
                for info in fetchResults{
                    if info.userName != userName.lowercased(){
                        //删除手势密码
                        UserDefaults.standard.removeObject(forKey: gestureFinalSaveKey)
                        updateOrWriteDataToServer(isToOpen:false,isToDelete:true)
                    }
                    info.id = 1
                    info.userName = userName.lowercased()
                    info.nickName = nickName
                    info.roleType = roleType
                    info.userId = userId
                    info.password  = password
                }
            }
            try context.save()
            print("new records saved")
        } catch {
            fatalError("保存失败\(error)")
        }
    }
}
