package com.sun3d.why.controller;

import com.sun3d.why.model.SysUser;
import com.sun3d.why.model.UserAddress;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.SysUserAddressService;
import com.sun3d.why.util.Constant;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import java.util.List;

@RequestMapping("/sysUserAddress")
@Controller
public class SysUserAddressController {
    private Logger logger = LoggerFactory.getLogger(SysUserAddressController.class);
    @Autowired
    private HttpSession session;
    @Autowired
    private SysUserAddressService sysUserAddressService;
    @Autowired
    private StaticServer staticServer;

    /**
     * 用户地址列表页
     *
     * @return
     */
    @RequestMapping("/addressIndex")
    private ModelAndView addressIndex(HttpServletRequest request, String userId) {
        ModelAndView model = new ModelAndView();
        try {
            SysUser sysUser = (SysUser) session.getAttribute("user");
            if (sysUser != null && StringUtils.isNotBlank(sysUser.getUserId())) {
                if (StringUtils.isBlank(userId)) {
                    userId = sysUser.getUserId();
                }
                List<UserAddress> userAddresses = sysUserAddressService.userAddressList(userId);
                model.addObject("userId", userId);
                model.addObject("userAddresses", userAddresses);
                model.setViewName("admin/user/userAddressIndex");
            } else {
            	model.addObject("cityName", staticServer.getCityInfo().split(",")[1]);
                model.setViewName("admin/user/userLogin");
            }
        } catch (Exception e) {
            logger.error("addressIndex error {}", e);
        }
        return model;
    }

    /**
     * 用户添加地址
     *
     * @return
     */
    @RequestMapping(value = "/addAdd")
    public ModelAndView addAdd(String userId) {
        ModelAndView model = new ModelAndView();
        model.addObject("userId", userId);
        model.setViewName("admin/user/userAddAddress");
        return model;
    }

    /**
     * 添加
     *
     * @return
     */
    @RequestMapping(value = "/addAddress", method = RequestMethod.POST)
    @ResponseBody
    public String addAddress(UserAddress userAddress) {
        try {
            //从session中获取用户信息
            SysUser sysUser = (SysUser) session.getAttribute("user");
            if (sysUser != null) {
                if (StringUtils.isBlank(userAddress.getUserId())) {
                    userAddress.setUserId(sysUser.getUserId());
                }
                String result = sysUserAddressService.addUserAddress(userAddress, sysUser);
                if (result.equals("success")) {
                    return Constant.RESULT_STR_SUCCESS;
                } else {
                    return Constant.RESULT_STR_FAILURE;
                }
            } else {
                logger.error("当前登录用户不存在或没有登录，添加操作终止!");
            }

        } catch (Exception e) {
            logger.error("添加广告信息时出错!", e);
        }
        return Constant.RESULT_STR_FAILURE;

    }

    /**
     * @return
     */
    @RequestMapping("/editUserDefaultAddress")
    @ResponseBody
    public String editUserDefaultAddress(String addressId, String userId) {
        try {
            SysUser sysUser = (SysUser) session.getAttribute("user");
            if (userId == null && StringUtils.isBlank(userId)) {
                userId = sysUser.getUserId();
            }
            String result = sysUserAddressService.editUserDefaultAddress(addressId, userId);
            return Constant.RESULT_STR_SUCCESS;
        } catch (Exception e) {
            logger.error("activityIndex error {}", e);
        }
        return Constant.RESULT_STR_FAILURE;
    }
    /**
     * @return
     */
    @RequestMapping("/deleteUserDefaultAddress")
    @ResponseBody
    public String deleteUserDefaultAddress(String addressId) {
        try {

            String result = sysUserAddressService.deleteUserDefaultAddress(addressId);
            return Constant.RESULT_STR_SUCCESS;
        } catch (Exception e) {
            logger.error("activityIndex error {}", e);
        }
        return Constant.RESULT_STR_FAILURE;
    }
    /**
     * 用户添加地址
     *
     * @return
     */
    @RequestMapping(value = "/editAdd")
    public ModelAndView editAdd(String userId, String addressId) {
        ModelAndView model = new ModelAndView();
        UserAddress address = sysUserAddressService.editAddress(addressId);
        model.addObject("userId", userId);
        model.addObject("address", address);
        model.setViewName("admin/user/userEditAddress");
        return model;
    }

    /**
     * 添加
     *
     * @return
     */
    @RequestMapping(value = "/editAddress", method = RequestMethod.POST)
    @ResponseBody
    public String editAddress(UserAddress userAddress) {
        try {
            //从session中获取用户信息
            SysUser sysUser = (SysUser) session.getAttribute("user");
            if (sysUser != null) {
                if (StringUtils.isBlank(userAddress.getUserId())) {
                    userAddress.setUserId(sysUser.getUserId());
                }
                String result = sysUserAddressService.editUserAddress(userAddress, sysUser);
                if (result.equals("success")) {
                    return Constant.RESULT_STR_SUCCESS;
                } else {
                    return Constant.RESULT_STR_FAILURE;
                }
            } else {
                logger.error("当前登录用户不存在或没有登录，添加操作终止!");
            }

        } catch (Exception e) {
            logger.error("添加广告信息时出错!", e);
        }
        return Constant.RESULT_STR_FAILURE;

    }

    /**
     * 用户地址列表页
     *
     * @return
     */
    @RequestMapping("/getAddress")
    @ResponseBody
    private UserAddress getAddress(HttpServletRequest request, String userId) {
        try {
            SysUser sysUser = (SysUser) session.getAttribute("user");
            if (sysUser != null && StringUtils.isNotBlank(sysUser.getUserId())) {
                if (StringUtils.isBlank(userId)) {
                    userId = sysUser.getUserId();
                }
                return  sysUserAddressService.getAddress(userId);
            } else {
            }
        } catch (Exception e) {
            logger.error("addressIndex error {}", e);
        }
        return null;
    }
}