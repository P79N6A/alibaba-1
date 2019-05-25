package com.sun3d.why.dao;

import com.sun3d.why.util.Pagination;

import java.util.List;

/**
 * Created by ct on 16/9/27.
 */
public interface BaseMapper<T>
{
    T update(T model);
    T selectOne(Object id);
    String selectOne();
    List<T> selectList(Pagination page);
}
