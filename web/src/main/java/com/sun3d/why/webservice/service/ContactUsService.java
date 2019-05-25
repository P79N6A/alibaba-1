package com.sun3d.why.webservice.service;

import com.sun3d.why.model.ContactUs;
import com.sun3d.why.util.Pagination;

import java.util.List;

/**
 * 联系我们
 */
public interface ContactUsService {

    /**
     * 保存联系我们的信息
     *
     * @param contact :联系方式
     * @return
     */
    String  saveContact(ContactUs contact);
    /**
     * 根据活动对象查询活动列表信息
     *
     * @return 活动列表信息
     */
    List<ContactUs> selectContact(Pagination page);
}
