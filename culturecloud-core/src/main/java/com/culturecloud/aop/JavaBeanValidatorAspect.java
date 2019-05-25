package com.culturecloud.aop;

import java.util.Set;

import javax.validation.ConstraintViolation;
import javax.validation.Validation;
import javax.validation.Validator;
import javax.validation.ValidatorFactory;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.springframework.stereotype.Component;

import com.culturecloud.bean.ValidatorBean;
import com.culturecloud.exception.BizException;

@Component
@Aspect
public class JavaBeanValidatorAspect {

	@Before("execution(* com.culturecloud.*.rs.*..*.*(..))")
	public void validate(JoinPoint jp) {
		Object[] args = jp.getArgs();
		for (Object o : args) {
			if (o instanceof ValidatorBean) {
				/* 创建效验工厂 */
				ValidatorFactory validatorFactory = Validation
						.buildDefaultValidatorFactory();
				Validator validator = validatorFactory.getValidator();
				/* 将类型装载效验 */
				Set<ConstraintViolation<Object>> set = validator.validate(o);
				if (!set.isEmpty()) {
					for (ConstraintViolation<Object> constraintViolation : set) {
						String msg = constraintViolation.getMessage();
						BizException.Throw(ExceptionDisplay.display.getValue(), msg);
					}
				}
			}
		}
	}

}
