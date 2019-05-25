package com.sun3d.why.annotation;

import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

import com.culturecloud.enumeration.operation.OperatFunction;

/****************************************
 * 系统业务日志注解类
 * @author zhangchenxi
 * @since 2015-04-22
 * @version 1.0
 *
 ****************************************/
@Target({ElementType.METHOD,ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface SysBusinessLog {
	String remark() default "sysbussineslog......";//用于业务方法日志描述
	OperatFunction operation() default OperatFunction.WHY;
}
