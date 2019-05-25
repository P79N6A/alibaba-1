package com.culturecloud.aspect;

import com.culturecloud.annotation.DataSource;
import com.culturecloud.server.DynamicDataSourceHolder;
import com.culturecloud.util.Constants;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.reflect.MethodSignature;

import java.lang.reflect.Method;

/**
 * Created by ct on 2017/5/16.
 */
public class DatasourceAspect
{

    public void intercept(JoinPoint point) throws Throwable
    {
        Class<?> target = point.getTarget().getClass();
        MethodSignature signature = (MethodSignature) point.getSignature();
        // 默认使用目标类型的注解，如果没有则使用其实现接口的注解
        for (Class<?> clazz : target.getInterfaces()) {
            resolveDataSource(clazz, signature.getMethod());
        }
        resolveDataSource(target, signature.getMethod());
    }

    private void resolveDataSource(Class<?> clazz, Method method)
    {
        try
        {
            Class<?>[] types = method.getParameterTypes();
            // 默认使用类型注解
            if (clazz.isAnnotationPresent(DataSource.class)) {
                DataSource source = clazz.getAnnotation(DataSource.class);
                DynamicDataSourceHolder.setDataSource(source.value());
            }
            // 方法注解可以覆盖类型注解
            Method m = clazz.getMethod(method.getName(), types);
            if (m != null && m.isAnnotationPresent(DataSource.class)) {
                DataSource source = m.getAnnotation(DataSource.class);
                DynamicDataSourceHolder.setDataSource(source.value());
            }
            else
            {
                DynamicDataSourceHolder.setDataSource(Constants.DATASOURCE_SHANGHAI);
            }
        } catch (Exception e)
        {
            System.out.println(clazz + ":" + e.getMessage());
        }
    }
}
