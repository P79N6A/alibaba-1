package com.culturecloud.test.platform.activity;

import com.culturecloud.model.request.activity.ActivityOrderVO;
import com.culturecloud.model.request.activity.SysUserAnalyseVO;
import com.culturecloud.test.HttpRequest;
import com.culturecloud.test.TestRestService;
import org.junit.Test;

public class TestActivityOrder extends TestRestService {


    @Test
    public void addOrder(){

        ActivityOrderVO vo=new ActivityOrderVO();

        vo.setOrderName("电饭锅");

        System.out.println(HttpRequest.sendPost(BASE_URL+"/order/add", vo));

    }

    @Test
    public void userAnalyse(){
        SysUserAnalyseVO userAnalyse=new SysUserAnalyseVO();
        userAnalyse.setUserId("804c36600c744f9aa41a2ca5c9975607");
        userAnalyse.setTagId("314f1b8fd6e04f93b5b067ab19d48ea6");
        System.out.println(HttpRequest.sendPost(BASE_URL+"/order/userAnalyse", userAnalyse));

    }
}
