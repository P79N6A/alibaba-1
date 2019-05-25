package com.culturecloud.test.api;

import com.culturecloud.model.bean.activity.CmsActivityEvent;
import com.culturecloud.model.bean.activity.CmsActivityOrderDetail;
import com.culturecloud.model.request.api.*;
import com.culturecloud.test.HttpRequest;
import com.culturecloud.test.TestRestService;
import org.junit.Test;

import java.lang.reflect.Constructor;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class ApiResourceTest extends TestRestService {

    @Test
    public void createActivity() {
        List<ActivityCreateApi> b = new ArrayList<ActivityCreateApi>();
        ActivityCreateApi a = new ActivityCreateApi();
        a.setActivityName("qweqwe");
        a.setActivityId("52cf7d492f664521a99d5fcf0c72ec5r");
        a.setVenueId("a8a96b0901ad460d9eca558b3ed89173");
        a.setActivityIconUrl("http://img1.wenhuayun.cn/admin/45/201608/Img/Imgd5ec347aa35e430cae4f1ff605b9b70a.jpg");
        a.setActivityArea("57,嘉定区");
        a.setActivityCity("qwe");
        a.setActivityProvince("qwe");
        a.setActivityAddress("上海松江区上海市松江区三新北路900弄635号\"");
        a.setActivityStartTime("2016-09-5");
        a.setActivityEndTime("2016-09-10");
        a.setActivityIsReservation(1);
        a.setActivityLon(23.2134);
        a.setActivityLat(23.2134);
        a.setActivityMemo("''''''''fghjfghjfgjh''");
        List<CmsActivityEvent> list = new ArrayList<CmsActivityEvent>();
        CmsActivityEvent event = new CmsActivityEvent();
        event.setEventId("52cf7d492f664521a99d5fcf0c72ec0r");
        event.setEventDateTime("2016-09-10 08:00-11:00");
        event.setEventTime("08:00-11:00");
        event.setAvailableCount(100);
        list.add(event);
        a.setEventList(list);
        b.add(a);
        ActivityCreateVO c = new ActivityCreateVO();
        c.setPlatSource("57");
        c.setActivityList(b);
        Constructor[] fs = a.getClass().getDeclaredConstructors();
        for (Constructor field : fs) {
            field.setAccessible(true);
            System.out.println(field);
        }
        System.out.println(HttpRequest.sendPost("http://pre.whycm.sh.cn:10019/api/activity/update", c));
//        System.out.println(HttpRequest.sendPost("http://pre.whycm.sh.cn:10019/api/activity/create", c));
    }

    @Test
    public void String() {
        String a = "2016-08-31 07:00-10:00";
        String b = "2016-08-30 07:00-10:00";
        String c = "";
        String d = "2016-09-31 07:00-10:00";
        System.out.println(a.compareTo(b));
        System.out.println(a.compareTo(c));
        System.out.println(a.compareTo(d));


    }

    @Test
    public void createOrder() {
        List<ActivityOrderCreateApi> activityOrderCreateApi = new ArrayList<ActivityOrderCreateApi>();
        ActivityOrderCreateApi a = new ActivityOrderCreateApi();
        a.setOrderName("qweqwe");
        a.setActivityOrderId("edfsdf");
        a.setActivityId("82a9a6d17f214913925ef1f32c24339f");
        a.setEventId("82a9a6d17f214913925ef1f32c24339f");
        a.setOrderPhoneNo("13103664657");
        a.setUserId("c9a342f2aa18c83495bb913801c9d229");
        List<CmsActivityOrderDetail> list = new ArrayList<CmsActivityOrderDetail>();
        CmsActivityOrderDetail orderDetail = new CmsActivityOrderDetail();
        orderDetail.setSeatCode("1234");
        orderDetail.setOrderLine(1);
        orderDetail.setSeatStatus(1);

        list.add(orderDetail);
        a.setOrderDetailList(list);
        activityOrderCreateApi.add(a);
        ActivityOrderCreateVO b = new ActivityOrderCreateVO();
        b.setOrderList(activityOrderCreateApi);
        b.setPlatSource("45");
        System.out.println(HttpRequest.sendPost(BASE_URL + "/api/order/create", b));
    }

    @Test
    public void createVenue() {
        List<VenueCreateApi> venueCreateApis = new ArrayList<VenueCreateApi>();
        VenueCreateApi a = new VenueCreateApi();
        a.setVenueName("qweqwe");
        venueCreateApis.add(a);
        VenueCreateVO b = new VenueCreateVO();
        b.setVenueList(venueCreateApis);
        b.setPlatSource("45");
        System.out.println(HttpRequest.sendPost(BASE_URL + "/api/venue/create", b));
    }


    @Test
    public void createUser() {
        List<HashMap> userList = new ArrayList<>();
        HashMap a = new HashMap();
        a.put("userId", "640f814e24004009ab5d73484f3e0b37");
        a.put("userName", "bfef51d6deea4ee9b0dc1b3d8c58cfc8");
        a.put("userPwd", "bfef51d6deea4ee9b0dc1b3d8c58cfc8");
//        a.put("userHeadImgUrl", "bfef51d6deea4ee9b0dc1b3d8c58cfc8");
        a.put("userTelephone", "13104665678");
        userList.add(a);
        HashMap b = new HashMap();
        b.put("platSource", "嘉定区 57");
        b.put("userList", userList);

        System.out.println(HttpRequest.sendPost(BASE_URL + "/api/user/create", b));
    }

    @Test
    public void addActivity() {
        String qweqwe = new String("123");
        MyClass myClass = new MyClass(0); //一般做法

        System.out.println(myClass.getClass().getDeclaredFields());
        myClass.increase(2);
        System.out.println("Normal -> " + myClass.count);
        try {


            Constructor constructor = MyClass.class.getConstructor(int.class); //获取构造方法
            System.out.println(constructor);

            MyClass myClassReflect = (MyClass) constructor.newInstance(10); //创建对象
            System.out.println(myClassReflect);

            Method method = MyClass.class.getMethod("increase", int.class);  //获取方法
            System.out.println(method);

            method.invoke(myClassReflect, 5); //调用方法
            Field field = MyClass.class.getField("count"); //获取域
            System.out.println("Reflect -> " + field.getInt(myClassReflect)); //获取域的值
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

}
