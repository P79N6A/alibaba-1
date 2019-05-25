package com.sun3d.why.webservice.service.impl;

import com.sun3d.why.dao.ContactUsMapper;
import com.sun3d.why.model.ContactUs;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;
import com.sun3d.why.webservice.service.ContactUsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@Transactional(rollbackFor = Exception.class)
public class ContactUsServiceImpl implements ContactUsService {
    @Autowired
    private ContactUsMapper contactUsMapper;

    /**
     * 保存联系我们的信息
     *
     * @param contact :联系方式
     * @return
     */
    @Override
    public String saveContact(ContactUs contact) {
        try {
            ContactUs contactus = new ContactUs();
            contactus.setContactId(UUIDUtils.createUUId());
            contactus.setContactTime(new Date());
            contactus.setContact(contact.getContact());
            contactus.setContactName(contact.getContactName());
            contactus.setCorporation(contact.getCorporation());

            int result = contactUsMapper.insert(contactus);
            if (result > 0) {
                return Constant.RESULT_STR_SUCCESS;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return Constant.RESULT_STR_FAILURE;
    }

    /**
     * 后台查询联系我们的信息
     *
     * @return
     */
    @Override
    public List<ContactUs> selectContact(Pagination page) {
        try {
            Map<String, Object> map = new HashMap<String, Object>();
            //网页分页
            if (page != null && page.getFirstResult() != null && page.getRows() != null) {
                map.put("firstResult", page.getFirstResult());
                map.put("rows", page.getRows());
                page.setTotal(contactUsMapper.selectContactCount(map));
            }
            return contactUsMapper.selectContact(map);

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

}
