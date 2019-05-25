package com.sun3d.why.util;

import com.sun3d.why.dao.*;
import com.sun3d.why.model.CmsActivityRoom;
import com.sun3d.why.model.CmsRoomBook;
import com.sun3d.why.model.CmsRoomOrder;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.service.CacheService;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;
import java.util.concurrent.Callable;

/**
 * 订单一系列操作
 */
public class roomOrderCallable implements Callable{
   private CmsRoomBook cmsRoomBook;
    private CmsVenueMapper cmsVenueMapper;
    private CmsTerminalUserMapper userMapper;
    private String userId;
    private  String bookId;
    private CmsRoomBookMapper cmsRoomBookMapper;
    private  CacheService cacheService;
    private CmsRoomOrderMapper cmsRoomOrderMapper;
    public roomOrderCallable(CmsRoomBook cmsRoomBook, String userId, String bookId,CmsVenueMapper cmsVenueMapper, CmsTerminalUserMapper userMapper,CmsRoomBookMapper cmsRoomBookMapper,CacheService cacheService,CmsRoomOrderMapper cmsRoomOrderMapper) {
        this.cmsRoomBook=cmsRoomBook;
        this.cmsVenueMapper=cmsVenueMapper;
        this.userMapper=userMapper;
        this.userId=userId;
        this.bookId=bookId;
        this.cmsRoomBookMapper=cmsRoomBookMapper;
        this.cacheService=cacheService;
        this.cmsRoomOrderMapper=cmsRoomOrderMapper;
    }
    @Override
    public Object call() throws Exception {
        CmsTerminalUser cmsTerminalUser = userMapper.queryTerminalUserById(userId);
        String venueId=cmsVenueMapper.queryVenueByBookId(bookId);
        CmsRoomOrder msgOrder = null;
        cmsRoomBook.setBookStatus(2);
        int count = cmsRoomBookMapper.editCmsRoomBook(cmsRoomBook);
        if (count>0) {
            //添加活动室订单信息
            CmsRoomOrder cmsRoomOrder = new CmsRoomOrder();
            cmsRoomOrder.setRoomOrderId(UUIDUtils.createUUId());
            cmsRoomOrder.setOrderNo(cacheService.genOrderNumber());
            cmsRoomOrder.setVenueId(venueId);
            cmsRoomOrder.setRoomId(cmsRoomBook.getRoomId());
            cmsRoomOrder.setBookId(bookId);
            cmsRoomOrder.setUserTel(cmsRoomBook.getUserTel());
            cmsRoomOrder.setUserId(userId);
            cmsRoomOrder.setUserName(cmsRoomBook.getUserName());
            cmsRoomOrder.setTuserId(cmsRoomBook.getTuserId());
            //cmsRoomOrder.setSysId(cmsRoomBook.getSysId());
           // cmsRoomOrder.setSysNo(cmsRoomBook.getSysNo());
            //取票码
            cmsRoomOrder.setValidCode(cmsRoomOrder.getOrderNo() + (100 + new Random().nextInt(999)));
            //状态1为预定成功 默认为0 待审核
            cmsRoomOrder.setBookStatus(0);
            cmsRoomOrder.setOrderCreateTime(new Date());
            cmsRoomOrder.setOrderUpdateTime(new Date());
            cmsRoomOrder.setOrderUpdateUser(cmsTerminalUser.getUserName());
            //int insertCount = 1;
            //活动室预定订单接口暂未对接
            int insertCount = cmsRoomOrderMapper.addRoomOrder(cmsRoomOrder);
            if(insertCount>0) {
                msgOrder = cmsRoomOrderMapper.querySendMsg(cmsRoomOrder.getRoomOrderId());
             }
             else {
                return null;
            }
        }else {
               return null;
        }
          return msgOrder;
    }
}
