//
//  main.swift
//  PerfectTemplate
//
//  Created by Kyle Jessup on 2015-11-05.
//	Copyright (C) 2015 PerfectlySoft, Inc.
//
//===----------------------------------------------------------------------===//
//
// This source file is part of the Perfect.org open source project
//
// Copyright (c) 2015 - 2016 PerfectlySoft Inc. and the Perfect project authors
// Licensed under Apache License v2.0
//
// See http://perfect.org/licensing.html for license information
//
//===----------------------------------------------------------------------===//
//
import Foundation
import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

// An example request handler.
// This 'handler' function can be referenced directly in the configuration below.
func handler(data: [String:Any]) throws -> RequestHandler {
    return {
        request, response in
        // Respond with a simple message.
        response.setHeader(.contentType, value: "text/html")
        response.appendBody(string: "<html><title>Style Soft simulator server</title><body><font size='10'>Style Soft simulator server</font>" + "<br>" +
            "<font color='red'>Created by Vasilij Orlov. Apple Swift version 3.1 (swiftlang-802.0.53 clang-802.0.42)</font><font color='blue'>" + "<br>" + "<br>" +

            "../api/login          --> type:post --> input params: app_id, device_id  " + "<br>" + "<br>" +
            
            "../api/getData/sync   --> type:post --> input params:application specific param " + "<br>" +
            "../api/getData/async  --> type:post --> input params:application specific param " + "<br>" + "<br>" +
            
            "../api/status/ready   --> type:post --> input params:async_token " + "<br>" +
            "../api/status/noready --> type:post --> input params:async_token " + "<br>" + "<br>" +
            
            "../api/setData/sync   --> type:post --> input params:application specific param " + "<br>" +
            "../api/satData/async  --> type:post --> input params:application specific param " + "<br>" + "<br>" +
            
            "../api/ping           --> type:post " + "<br>" + "<br>" +
            
            "..</font></body></html>")
        // Ensure that response.completed() is called when your processing is done.
        
        if let acceptEncoding = request.header(.acceptEncoding) {
            print(acceptEncoding)
        }
        if let acceptEncoding = request.header(.authorization) {
            print(acceptEncoding)
        }
        response.completed()
    }
}
//MARK: - Request get Data
func login(data: [String:Any]) throws -> RequestHandler {
    return {
        request, response in
        response.setHeader(.contentType, value: "application/json")
        
        var authToken:String = ""
        
        if let appId = request.param(name: "app_id") {
            authToken = authToken + "appId-" + appId
        }
        if let deviceId = request.param(name: "device_id") {
            authToken = authToken + "-deviceId-" + deviceId
        }
        
        let result: [String:Any] = ["is_success":true, "message":"OK", "data":["auth_token": authToken]]
        
        do {
            try response.setBody(json: result)
        } catch {
            //error
        }
        response.completed()
    }
}

//MARK: - Request get Data

func getDataAsync(data: [String:Any]) throws -> RequestHandler {
    return {
        request, response in
        response.setHeader(.contentType, value: "application/json")
        
        let result: [String:Any] = ["is_success":true, "message": "wait 5 sec", "is_async": true, "async_token": "4b8080e1-ae0a-40f3-9add-23a80893bd10" ,"async_delay": 5000]
        
        do {
            try response.setBody(json: result)
        } catch {
            //error
        }
        response.completed()
    }
}
func getDataSync(data: [String:Any]) throws -> RequestHandler {
    return {
        request, response in
        response.setHeader(.contentType, value: "application/json")
        
        let result: [String:Any] = ["is_success":true, "message": "OK", "data":["locations": ["loc_id":111, "loc_source_id":123], "points_of_sale": ["pos_id":111, "pos_source_id":123]]]
        
        do {
            try response.setBody(json: result)
        } catch {
            //error
        }
        response.completed()
    }
}
//MARK: - Request set Data

func setDataAsync(data: [String:Any]) throws -> RequestHandler {
    return {
        request, response in
        response.setHeader(.contentType, value: "application/json")
        
        let result: [String:Any] = ["is_success":true, "message": "wait 5 sec", "is_async": true, "async_token": "4b8080e1-ae0a-40f3-9add-23a80893bd11" ,"async_delay": 5000]
        
        do {
            try response.setBody(json: result)
        } catch {
            //error
        }
        response.completed()
    }
}
func setDataSync(data: [String:Any]) throws -> RequestHandler {
    return {
        request, response in
        response.setHeader(.contentType, value: "application/json")
        
        let result: [String:Any] = ["is_success":true, "message":"OK"]
        
        do {
            try response.setBody(json: result)
        } catch {
            //error
        }
        response.completed()
    }
}

//MARK: - Request status
func statusReady(data: [String:Any]) throws -> RequestHandler {
    return {
        request, response in
        response.setHeader(.contentType, value: "application/json")
        if let asyncToken = request.param(name: "async_token") {
            print("asuncToken \(asyncToken)")
        }
        
        let result: [String:Any] = ["is_success":true, "message":"OK", "data":["locations": ["loc_id":111, "loc_source_id":123], "points_of_sale": ["pos_id":111, "pos_source_id":123]]]
        do {
            try response.setBody(json: result)
        } catch {
            //error
        }
        response.completed()
    }
}
func statusNoReady(data: [String:Any]) throws -> RequestHandler {
    return {
        request, response in
        response.setHeader(.contentType, value: "application/json")
        
        if let asyncToken = request.param(name: "async_token") {
            print("asuncToken \(asyncToken)")
        }
        
        let result: [String:Any] = ["is_success":true, "message":"wait 5 sec", "is_async": true, "async_token": "4b8080e1-ae0a-40f3-9add-23a80893bd12" ,"async_delay": 5000]
        
        do {
            try response.setBody(json: result)
        } catch {
            //error
        }
        response.completed()
    }
}

//MARK: - Request ping
func ping(data: [String:Any]) throws -> RequestHandler {
    return {
        request, response in
        response.setHeader(.contentType, value: "application/json")

        let result: [String:Any] = ["is_success":true, "message":"OK", "data":["commands": [["name":"get_data", "params":["param1":"param1", "param2": "param2"]],["name":"get_data2", "params":["param1_":"param1_", "param2_": "param2_"]]]]]
        do {
            try response.setBody(json: result)
        } catch {
            //error
        }
        response.completed()
    }
}
// Configuration data for two example servers.
// This example configuration shows how to launch one or more servers
// using a configuration dictionary.

let port1 = 8080, port2 = 8181

let confData = [
    "servers": [
        // Configuration data for one server which:
        //	* Serves the hello world message at <host>:<port>/
        //	* Serves static files out of the "./webroot"
        //		directory (which must be located in the current working directory).
        //	* Performs content compression on outgoing data when appropriate.
        [
            "name":"localhost",
            "port":port1,
            "routes":[
                ["method":"get", "uri":"/", "handler":handler],
                
                ["methods":["post"],"uri":"/api/login/**","handler":login],
                
                ["methods":["post"],"uri":"/api/getData/async/**","handler":getDataAsync],
                ["methods":["post"],"uri":"/api/getData/sync/**","handler":getDataSync],
                
                ["methods":["post"],"uri":"/api/setData/async/**","handler":setDataAsync],
                ["methods":["post"],"uri":"/api/setData/sync/**","handler":setDataSync],
                
                ["methods":["post"],"uri":"/api/status/ready/**","handler":statusReady],
                ["methods":["post"],"uri":"/api/status/noready/**","handler":statusNoReady],
                
                ["methods":["post"],"uri":"/api/setData/ready/**","handler":statusReady],
                ["methods":["post"],"uri":"/api/setData/noready/**","handler":statusNoReady],
                
                ["methods":["post"],"uri":"/api/ping/**","handler":ping],
                
                ["method":"get", "uri":"/**", "handler":PerfectHTTPServer.HTTPHandler.staticFiles,
                 "documentRoot":"./webroot",
                 "allowResponseFilters":true]
            ],
            "filters":[
                [
                    "type":"response",
                    "priority":"high",
                    "name":PerfectHTTPServer.HTTPFilter.contentCompression,
                    ]
            ]
        ],
        // Configuration data for another server which:
        //	* Redirects all traffic back to the first server.
        [
            "name":"localhost",
            "port":port2,
            "routes":[
                ["method":"get", "uri":"/**", "handler":PerfectHTTPServer.HTTPHandler.redirect,
                 "base":"http://localhost:\(port1)"]
            ]
        ]
    ]
]

do {
    // Launch the servers based on the configuration data.
    try HTTPServer.launch(configurationData: confData)
} catch {
    fatalError("\(error)") // fatal error launching one of the servers
}

