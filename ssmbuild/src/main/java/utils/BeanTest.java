package utils;

import org.junit.Test;
import org.springframework.context.support.ClassPathXmlApplicationContext;

/*
获取已经注入ioc容器中的bean
 */
public class BeanTest {
    @Test
    public void test() {
        ClassPathXmlApplicationContext ctx = new ClassPathXmlApplicationContext("classpath:applicationContext.xml");
        String[] beanNames = ctx.getBeanDefinitionNames();
        int allBeansCount = ctx.getBeanDefinitionCount();

        System.out.println("所有beans的数量是：" + allBeansCount);
        for (String beanName : beanNames) {
            Class<?> beanType = ctx.getType(beanName);
            Package beanPackage = beanType.getPackage();

            Object bean = ctx.getBean(beanName);
            System.out.println("*****************************");
            System.out.println("名字:" + beanName);
            System.out.println("类型：" + beanType);
            System.out.println("Bean所在的包：" + beanPackage);


        }
    }

}
