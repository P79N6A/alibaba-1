package com.sun3d.why.service.impl;

import com.sun3d.why.dao.UserAddressMapper;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.model.UserAddress;
import com.sun3d.why.service.SysUserAddressService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.UUIDUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;

@Transactional(rollbackFor = Exception.class)
@Service
public class SysUserAddressServiceImpl implements SysUserAddressService {

    @Autowired
    private UserAddressMapper userAddressMapper;


    @Override
    public List<UserAddress> userAddressList(String userId) {
        List<UserAddress> addressList = userAddressMapper.addressList(userId);
        return addressList;
    }

    @Override
    public String addUserAddress(UserAddress userAddress, SysUser sysUser) {
        userAddress.setAddressId(UUIDUtils.createUUId());
        userAddress.setCreateTime(new Date());
        userAddress.setUpdateTime(new Date());
        userAddress.setCreatBy(sysUser.getUserId());
        userAddress.setUpdateBy(sysUser.getUserId());
        int count = userAddressMapper.insertSelective(userAddress);
        if (count>0) {
            return Constant.RESULT_STR_SUCCESS;
        } else {
            return Constant.RESULT_STR_FAILURE;
        }
    }
    @Override
    public String editUserAddress(UserAddress userAddress, SysUser sysUser) {
        userAddress.setUpdateTime(new Date());
        userAddress.setUpdateBy(sysUser.getUserId());
        int editResult = userAddressMapper.updateByPrimaryKeySelective(userAddress);
        if (editResult>0) {
            return Constant.RESULT_STR_SUCCESS;
        } else {
            return Constant.RESULT_STR_FAILURE;
        }
    }

    @Override
    public String editUserDefaultAddress(String addressId, String userId) {
        int result= userAddressMapper.updateDefaultAddress(userId);
        result= userAddressMapper.setDefaultAddress(addressId);
        if (result>0) {
            return Constant.RESULT_STR_SUCCESS;
        } else {
            return Constant.RESULT_STR_FAILURE;
        }
    }

    @Override
    public String deleteUserDefaultAddress(String addressId) {
        int result= userAddressMapper.deleteByPrimaryKey(addressId);
        if (result>0) {
            return Constant.RESULT_STR_SUCCESS;
        } else {
            return Constant.RESULT_STR_FAILURE;
        }
    }
    @Override
    public  UserAddress editAddress(String addressId){
        return userAddressMapper.selectAddressById(addressId);
    }

    @Override
    public  UserAddress getAddress(String userId){
        UserAddress userAddress=new UserAddress();
        userAddress.setUserId(userId);
        userAddress.setDefaultAddress(1);
        return userAddressMapper.selectAddress(userAddress);
    }
}
