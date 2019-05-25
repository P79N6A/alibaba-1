package com.sun3d.why.dao;

import com.sun3d.why.model.UserAddress;

import java.util.List;

public interface UserAddressMapper {
    int deleteByPrimaryKey(String addressId);

    int insertSelective(UserAddress record);

    int updateByPrimaryKeySelective(UserAddress record);

    int updateDefaultAddress(String userId);

    int setDefaultAddress(String addressId);

    List<UserAddress> addressList(String userId);

    UserAddress selectAddressById(String addressId);

    UserAddress selectAddress(UserAddress record);
}