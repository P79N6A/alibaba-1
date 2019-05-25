package com.sun3d.why.service;

import com.sun3d.why.model.SysUser;
import com.sun3d.why.model.UserAddress;

import java.util.List;

public interface SysUserAddressService {

    /**
     * 根据活动对象查询活动列表信息
     *
     * @param userId 用户Id
     * @return 活动列表信息
     */
    List<UserAddress> userAddressList(String userId);

    String addUserAddress(UserAddress userAddress, SysUser sysuser);

    String editUserAddress(UserAddress userAddress, SysUser sysUser);

    String editUserDefaultAddress(String addressId, String userId);

    String deleteUserDefaultAddress(String addressId);

    UserAddress editAddress(String addressId);

    UserAddress getAddress(String userId);

}
