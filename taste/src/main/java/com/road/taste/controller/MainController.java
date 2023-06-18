package com.road.taste.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping(value = "/")
public class MainController {

    @GetMapping("/")
    public String index(){
        return "index";
    };

    @ResponseBody
    public String tasteList(){
        return "abc";
    }
}
