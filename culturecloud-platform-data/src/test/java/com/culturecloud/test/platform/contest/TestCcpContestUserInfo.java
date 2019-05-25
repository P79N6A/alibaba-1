package com.culturecloud.test.platform.contest;


import com.culturecloud.coreutils.UUIDUtils;
import com.culturecloud.dao.contest.CcpContestUserInfoMapper;
import com.culturecloud.model.request.contest.ContestUserInfoVO;
import com.culturecloud.test.HttpRequest;
import com.culturecloud.test.TestRestService;
import org.junit.Test;

import javax.annotation.Resource;
import java.util.Calendar;
import java.util.Date;

public class TestCcpContestUserInfo extends TestRestService {
    private char[] value;
    @Resource
    private CcpContestUserInfoMapper ccpContestUserInfoMapper;

    @Test
    public void getRight() {

        double num = 0;
        int[] rights = new int[5];
        rights[0] = 1;
        rights[1] = 0;
        rights[2] = 1;
        rights[3] = 0;
        rights[4] = 1;
        for (int i = 0; i < rights.length; i++) {
            if (rights[i] > 0) {
                num += Math.pow(2, i);
            }
        }
        System.out.println(num);
    }


    @Test
    public void getInt() {

        String num = "sdfasdf";
        char[] rights = num.toCharArray();
        Integer[] rig = new Integer[5];

        for (int i = 0; i < 5; i++) {
            if (i < rights.length) {
                rig[i] = Integer.parseInt(String.valueOf(rights[i]));
            } else {
                rig[i] = 0;
            }
        }

        System.out.println(num.codePointCount(0, 3));
    }


    @Test
    public void getIndexof() {

        System.out.println(Calendar.getInstance().getTime());
        StringBuilder a = new StringBuilder();
        for (int i = 0; i < 1000000; i++) {
            a.append(UUIDUtils.createUUId());
        }


        System.out.println(Calendar.getInstance().getTime());

        System.out.println(a.indexOf(UUIDUtils.createUUId()));

        System.out.println(Calendar.getInstance().getTime());


    }

    @Test
    public void getDate() {

        int now = Calendar.DAY_OF_YEAR;

        Date date = new Date();
        Calendar cal = Calendar.getInstance();
        cal.setTime(date);

        Date dates = cal.getTime();
        System.out.println(Calendar.DAY_OF_YEAR);

        System.out.println(dates.getDate());

    }

    @Test
    public void selectTop() {
        ContestUserInfoVO a = new ContestUserInfoVO();
        a.setContestSystemType(2);
        a.setUserId("b7dcc4aa408244dd970b62345106c5d6");
        System.out.println(HttpRequest.sendPost(BASE_URL+"/contestUserInfo/getTopHelpList", a));

//        int b = ccpContestUserInfoMapper.selectTop(a);
//        System.out.println(b);
    }
}
