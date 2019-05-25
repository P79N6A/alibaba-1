package com.sun3d.why.dao;

import com.sun3d.why.model.ContactUs;

import java.util.List;
import java.util.Map;

public interface ContactUsMapper {


    int insert(ContactUs record);

    List<ContactUs>  selectContact(Map<String, Object> map);
    /**
     * 联系我们条数
     *
     */
    int selectContactCount(Map<String, Object> map);


}