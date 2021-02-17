# ssm框架问题解析

## ssm框架整合步骤(crud)

主要重点是将个个框架的配置文件分开，个个层的配置文件分离，再导入到sring主配置文件中



### 环境要求

环境：

- IDEA
- MySQL 5.7.19
- Tomcat 9
- Maven 3.6

#### 数据库环境

创建一个存放书籍数据的数据库表

```sql
CREATE DATABASE `ssmbuild`;

USE `ssmbuild`;

DROP TABLE IF EXISTS `books`;

CREATE TABLE `books` (
`bookID` INT(10) NOT NULL AUTO_INCREMENT COMMENT '书id',
`bookName` VARCHAR(100) NOT NULL COMMENT '书名',
`bookCounts` INT(11) NOT NULL COMMENT '数量',
`detail` VARCHAR(200) NOT NULL COMMENT '描述',
KEY `bookID` (`bookID`)
) ENGINE=INNODB DEFAULT CHARSET=utf8

INSERT  INTO `books`(`bookID`,`bookName`,`bookCounts`,`detail`)VALUES 
(1,'Java',1,'从入门到放弃'),
(2,'MySQL',10,'从删库到跑路'),
(3,'Linux',5,'从进门到进牢');
```

#### 基本环境搭建

1、新建一Maven项目！ssmbuild 

![QQ截图20210217215337](D:\桌面\截图\QQ截图20210217215337.png)

添加web支持

![QQ截图20210217215750](D:\桌面\截图\QQ截图20210217215750.png)

2、导入相关的pom依赖！

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>org.example</groupId>
    <artifactId>ssmbuild</artifactId>
    <version>1.0-SNAPSHOT</version>

    <properties>
        <kotlin.version>1.4.30</kotlin.version>
    </properties>


    <dependencies>
        <!--Junit = 单元测试-->
        <dependency>
            <groupId>junit</groupId>
            <artifactId>junit</artifactId>
            <version>4.12</version>
        </dependency>
        <!--数据库驱动-->
        <dependency>
            <groupId>mysql</groupId>
            <artifactId>mysql-connector-java</artifactId>
            <version>5.1.47</version>
        </dependency>
        <!-- 数据库连接池  c3po-->
        <dependency>
            <groupId>com.mchange</groupId>
            <artifactId>c3p0</artifactId>
            <version>0.9.5.2</version>
        </dependency>

        <!--Servlet - JSP -->
        <dependency>
            <groupId>javax.servlet</groupId>
            <artifactId>servlet-api</artifactId>
            <version>2.5</version>
        </dependency>
        <dependency>
            <groupId>javax.servlet.jsp</groupId>
            <artifactId>jsp-api</artifactId>
            <version>2.2</version>
        </dependency>
        <dependency>
            <groupId>javax.servlet</groupId>
            <artifactId>jstl</artifactId>
            <version>1.2</version>
        </dependency>

        <!--Mybatis-->
        <dependency>
            <groupId>org.mybatis</groupId>
            <artifactId>mybatis</artifactId>
            <version>3.5.2</version>
        </dependency>
        <dependency>
            <groupId>org.mybatis</groupId>
            <artifactId>mybatis-spring</artifactId>
            <version>2.0.2</version>
        </dependency>

        <!--Spring-->
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-webmvc</artifactId>
            <version>5.1.9.RELEASE</version>
        </dependency>
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-jdbc</artifactId>
            <version>5.1.9.RELEASE</version>
        </dependency>
        <!-- https://mvnrepository.com/artifact/org.mybatis.generator/mybatis-generator-core mybatis 逆向工程 -->
        <dependency>
            <groupId>org.mybatis.generator</groupId>
            <artifactId>mybatis-generator-core</artifactId>
            <version>1.3.7</version>
        </dependency>
        <dependency>
            <groupId>org.jetbrains.kotlin</groupId>
            <artifactId>kotlin-test</artifactId>
            <version>${kotlin.version}</version>
            <scope>test</scope>
        </dependency>
    </dependencies>
<!--静态资源导出-->
    <build>
        <resources>
            <resource>
                <directory>src/main/java</directory>
                <includes>
                    <include>**/*.properties</include>
                    <include>**/*.xml</include>
                </includes>
                <filtering>false</filtering>
            </resource>
            <resource>
                <directory>src/main/resources</directory>
                <includes>
                    <include>**/*.properties</include>
                    <include>**/*.xml</include>
                </includes>
                <filtering>false</filtering>
            </resource>
        </resources>
        <plugins>
            <plugin>
                <groupId>org.jetbrains.kotlin</groupId>
                <artifactId>kotlin-maven-plugin</artifactId>
                <version>${kotlin.version}</version>
                <executions>
                    <execution>
                        <id>compile</id>
                        <phase>compile</phase>
                        <goals>
                            <goal>compile</goal>
                        </goals>
                    </execution>
                    <execution>
                        <id>test-compile</id>
                        <phase>test-compile</phase>
                        <goals>
                            <goal>test-compile</goal>
                        </goals>
                    </execution>
                </executions>
                <configuration>
                    <jvmTarget>1.8</jvmTarget>
                </configuration>
            </plugin>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-compiler-plugin</artifactId>
                <executions>
                    <execution>
                        <id>compile</id>
                        <phase>compile</phase>
                        <goals>
                            <goal>compile</goal>
                        </goals>
                    </execution>
                    <execution>
                        <id>testCompile</id>
                        <phase>test-compile</phase>
                        <goals>
                            <goal>testCompile</goal>
                        </goals>
                    </execution>
                </executions>
            </plugin>
        </plugins>
    </build>
</project>

```

3、建立基本结构和配置框架！



![QQ截图20210217221158](D:\桌面\截图\QQ截图20210217221158.png)

- com.kuang.pojo
- com.kuang.dao
- com.kuang.service
- com.kuang.controller
- mybatis-config.xml(mybatis配置文件)

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE configuration
       PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
       "http://mybatis.org/dtd/mybatis-3-config.dtd">
<configuration>

</configuration>
```

- applicationContext.xml（spring主配置文件）

  ```

  <?xml version="1.0" encoding="UTF-8"?>
  <beans xmlns="http://www.springframework.org/schema/beans"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="http://www.springframework.org/schema/beans
         http://www.springframework.org/schema/beans/spring-beans.xsd">

  </beans>
  ```

### Mybatis层编写

1、数据库配置文件 **database.properties**

```properties
jdbc.driver=com.mysql.jdbc.Driver
jdbc.url=jdbc:mysql://localhost:3306/ssmbuild?useSSL=true&useUnicode=true&characterEncoding=utf8
jdbc.username=root
jdbc.password=123456
#使用8.0以上把版本数据库加上时区参数serverTimezone=UTC

```

2.编写MyBatis的核心配置文件

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE configuration
       PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
       "http://mybatis.org/dtd/mybatis-3-config.dtd">
<configuration>
   <!--    配置数据源，交给spirng去做-->
   <typeAliases>
       <package name="com.kuang.pojo"/>
   </typeAliases>
   <!--    将映射配置文件写入主配置文件-->
   <mappers>
       <mapper resource="com/kuang/dao/BookMapper.xml"/>
   </mappers>

</configuration>
```

3、编写数据库对应的实体类 pojo.Books

```java
package pojo;
/*数据库字段名与实体类属性名尽量保持一致*/
public class Books {
    private Integer bookID;
    private String bookName;
    public Integer getBookID() {
        return bookID;
    }
    public void setBookID(Integer bookID) {
        this.bookID = bookID;
    }
    public String getBookName() {
        return bookName;
    }
    public void setBookName(String bookName) {
        this.bookName = bookName;
    }
    public Integer getBookCounts() {
        return bookCounts;
    }
    public void setBookCounts(Integer bookCounts) {
        this.bookCounts = bookCounts;
    }
    private Integer bookCounts;
    private String detail;
    public String getDetail() {
        return detail;
    }
    public void setDetail(String detail) { this.detail = detail == null ? null : detail.trim(); }
    @Override
    public String toString() {
        return "Books{" +
                "bookIDd=" + bookID +
                ", bookName='" + bookName + '\'' +
                ", bookCounts=" + bookCounts +
                ", detail='" + detail + '\'' +
                '}';

    }}

```

4、编写Dao层的 Mapper接口！

接口：

```java
package mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import pojo.Books;

public interface BooksMapper {
    //增加一个Book
    int addBook(Books book);

    //根据id删除一个Book
    int deleteBookById(int id);

    //更新Book
    int updateBook(Books books);

    //根据id查询,返回一个Book
    Books queryBookById(int id);

    //查询全部Book,返回list集合
    List<Books> queryAllBook();
    //根据名称模糊查询
   List< Books>  queryBookNameLike(String BoookName);

}
```

5、编写接口对应的 Mapper.xml 文件。需要导入MyBatis的包；

- BooksMapper.xml

```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="mapper.BooksMapper">
<!--    <resultMap id="Books1" type="pojo.Books">-->
<!--        <result column="bookID" jdbcType="INTEGER" property="bookid"/>-->
<!--        <result column="bookName" jdbcType="VARCHAR" property="bookname"/>-->
<!--        <result column="bookCounts" jdbcType="INTEGER" property="bookcounts"/>-->
<!--        <result column="detail" jdbcType="VARCHAR" property="detail"/>-->
<!--    </resultMap>-->
    <!--增加一个Book-->
    <insert id="addBook" parameterType="pojo.Books">
      insert into ssmbuild.books(bookName,bookCounts,detail)
      values (#{bookName}, #{bookCounts}, #{detail})
   </insert>

    <!--根据id删除一个Book-->
    <delete id="deleteBookById" parameterType="int">
      delete from ssmbuild.books where bookID=#{bookID}
   </delete>

    <!--更新Book-->
    <update id="updateBook" parameterType="pojo.Books">
      update ssmbuild.books
      set bookName = #{bookName},bookCounts = #{bookCounts},detail = #{detail}
      where bookID = #{bookID}
   </update>

    <!--根据id查询,返回一个Book-->
    <select id="queryBookById" resultType="pojo.Books">
      select * from ssmbuild.books
      where bookID = #{bookID}
   </select>

    <!--查询全部Book-->
    <select id="queryAllBook" resultType="pojo.Books">
      SELECT * from ssmbuild.books
   </select>
    <select id="queryBookNameLike" resultType="pojo.Books">
        SELECT * from ssmbuild.books where bookName like  concat('%',#{bookName},'%')
    </select>

</mapper>
```

如果不想编写实体和接口可以使用mybatis的逆向工程过根据数据库自动生成实体类和映射文件

1.添加依赖

```xml
<!-- https://mvnrepository.com/artifact/org.mybatis.generator/mybatis-generator-core mybatis 逆向工程 -->
<dependency>
    <groupId>org.mybatis.generator</groupId>
    <artifactId>mybatis-generator-core</artifactId>
    <version>1.3.7</version>
</dependency>

```

2.编写工程配置文件generatorConfig.xml

```xml
<?xml version='1.0' encoding='UTF-8'?>
<!DOCTYPE generatorConfiguration
        PUBLIC "-//mybatis.org//DTD MyBatis Generator Configuration 1.0//EN"
        "http://mybatis.org/dtd/mybatis-generator-config_1_0.dtd">

<generatorConfiguration>
    <context id="mybatisGenerator" targetRuntime="MyBatis3">
        <commentGenerator>
            <!-- 是否去除自动生成的注释 true：是 ： false:否 -->
            <property name="suppressAllComments" value="true" />
        </commentGenerator>
        <!--数据库连接的信息：驱动类、连接地址、用户名、密码 -->
        <jdbcConnection driverClass="com.mysql.jdbc.Driver"
                        connectionURL="jdbc:mysql://localhost:3306/ssmbuild?
                                useUnicode=true&amp;characterEncoding=utf-8&amp;allowMultiQueries=true" userId="root"
                        password="123456">
        </jdbcConnection>

        <!-- 默认false，把JDBC DECIMAL 和 NUMERIC 类型解析为 Integer，为 true时把JDBC DECIMAL 和
            NUMERIC 类型解析为java.math.BigDecimal -->
        <javaTypeResolver>
            <property name="forceBigDecimals" value="false" />
        </javaTypeResolver>

        <!-- targetProject:生成PO类的位置 -->
        <javaModelGenerator targetPackage="pojo"
                            targetProject=".\src\main\java\pojo">
            <!-- enableSubPackages:是否让schema作为包的后缀 -->
            <property name="enableSubPackages" value="false" />
            <!-- 从数据库返回的值被清理前后的空格 -->
            <property name="trimStrings" value="true" />
        </javaModelGenerator>
        <!-- targetProject:mapper映射文件生成的位置 -->
        <sqlMapGenerator targetPackage="mapper"
                         targetProject=".\src\main\java">
            <!-- enableSubPackages:是否让schema作为包的后缀 -->
            <property name="enableSubPackages" value="false" />
        </sqlMapGenerator>
        <!-- targetPackage：mapper接口生成的位置 -->
        <javaClientGenerator type="XMLMAPPER"
                             targetPackage="mapper"
                             targetProject=".\src\main\java">
            <!-- enableSubPackages:是否让schema作为包的后缀 -->
            <property name="enableSubPackages" value="false" />
        </javaClientGenerator>
        <!-- 指定数据库表 -->
        <table tableName="books"></table>
        <!-- 有些表的字段需要指定java类型
         <table schema="" tableName="">
            <columnOverride column="" javaType="" />
        </table> -->
    </context>
</generatorConfiguration>

```

3.编写启动生成类Generator

```java
package utils;

import org.mybatis.generator.api.MyBatisGenerator;
import org.mybatis.generator.config.Configuration;
import org.mybatis.generator.config.xml.ConfigurationParser;
import org.mybatis.generator.internal.DefaultShellCallback;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

public class Generator {
    public void generator() throws Exception{
        List<String> warnings = new ArrayList<String>();
        boolean overwrite = true;
        /**指向逆向工程配置文件*/
        File configFile = new File("src/main/resources/generatorConfig.xml");
        ConfigurationParser parser = new ConfigurationParser(warnings);
        Configuration config = parser.parseConfiguration(configFile);
        DefaultShellCallback callback = new DefaultShellCallback(overwrite);
        MyBatisGenerator myBatisGenerator = new MyBatisGenerator(config,
                callback, warnings);
        myBatisGenerator.generate(null);
    }
    public static void main(String[] args) throws Exception {
        try {
            Generator generatorSqlmap = new Generator();
            generatorSqlmap.generator();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}

```

4.运行main 方法生成

6、编写Service层的接口和实现类

接口：

```java
package service;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Service;
import pojo.Books;

import java.util.List;

public interface BookService {

    //增加一个Book
    int addBook(Books book);
    //根据id删除一个Book
    int deleteBookById(int id);
    //更新Book
    int updateBook(Books books);
    //根据id查询,返回一个Book
    Books queryBookById(int id);
    //查询全部Book,返回list集合
    List<Books> queryAllBook();
    //根据名称模糊查询
    List<Books>  queryBookNameLike(String BoookName);

}
```

实现类：

```java
package service;

import mapper.BooksMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import pojo.Books;

import java.util.List;

@Service //将实现类注入到spring容器中（使用@Sevice注解）
public class BookServiceImpl implements BookService {

    @Autowired //将接口属性注入到实现类中（使用@Autowired注解）
    private  BooksMapper booksMapper;

    @Override
    public int addBook(Books book) {
        return booksMapper.addBook(book);
    }

    @Override
    public int deleteBookById(int id) {
        return booksMapper.deleteBookById(id);
    }

    @Override
    public int updateBook(Books books) {
        return booksMapper.updateBook(books);
    }

    @Override
    public Books queryBookById(int id) {
        return booksMapper.queryBookById(id);
    }

    @Override
    public List<Books> queryAllBook() {
        return booksMapper.queryAllBook();
    }

    @Override
    public List<Books> queryBookNameLike(String BoookName) {
        return booksMapper.queryBookNameLike(BoookName);
    }
}


```

**OK，到此，底层需求操作编写完毕！**

### Spring层

1、配置**Spring整合MyBatis**，我们这里数据源使用c3p0连接池；

2、我们去编写Spring整合Mybatis的相关的配置文件；

- spring-mapper.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!--spring配置整合mybatis(dao层)-->
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:context="http://www.springframework.org/schema/context"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd http://www.springframework.org/schema/context https://www.springframework.org/schema/context/spring-context.xsd">
    <!--关联数据库配置文件-->
    <context:property-placeholder location="classpath:database.properties" />
    <!--   配置数据库连接池-->
    <bean id="dataSource" class="com.mchange.v2.c3p0.ComboPooledDataSource">
        <property name="driverClass" value="${jdbc.driver}"></property>
        <property name="jdbcUrl" value="${jdbc.url}"></property>
        <property name="user" value="${jdbc.username}"></property>
        <property name="password" value="${jdbc.password}"></property>
        <property name="initialPoolSize" value="10"/>
        <!-- c3p0连接池的私有属性 -->
        <property name="maxPoolSize" value="30"/>
        <property name="minPoolSize" value="10"/>
        <!-- 关闭连接后不自动commit -->
        <property name="autoCommitOnClose" value="false"/>
        <!-- 获取连接超时时间 -->
        <property name="checkoutTimeout" value="10000"/>
        <!-- 当获取连接失败重试次数 -->
        <property name="acquireRetryAttempts" value="2"/>
    </bean>
    <!-- 3.配置SqlSessionFactory对象 -->
    <bean id="sqlSessionFactory" class="org.mybatis.spring.SqlSessionFactoryBean">
        <!-- 注入数据库连接池 -->
        <property name="dataSource" ref="dataSource"/>
        <!-- 配置MyBaties全局配置文件:mybatis-config.xml -->
        <property name="configLocation" value="classpath:mybatis-config.xml"/>
    </bean>

    <!-- 4.配置扫描Dao接口包，动态实现Dao接口注入到spring容器中 -->
    <!--解释 ：https://www.cnblogs.com/jpfss/p/7799806.html-->
    <bean class="org.mybatis.spring.mapper.MapperScannerConfigurer">
        <!-- 注入sqlSessionFactory -->
        <property name="sqlSessionFactoryBeanName" value="sqlSessionFactory"/>
        <!-- 给出需要扫描Dao接口包 -->
        <property name="basePackage" value="mapper"/>
    </bean>

</beans>

```

3、**Spring整合service层**

- spring-sevice.xml

  ```xml
  <?xml version="1.0" encoding="UTF-8"?>
  <!--spring整合service层)-->
  <beans xmlns="http://www.springframework.org/schema/beans"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xmlns:context="http://www.springframework.org/schema/context"
         xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd http://www.springframework.org/schema/context https://www.springframework.org/schema/context/spring-context.xsd">
      <!--    1.扫描service下的包（扫描sevice相关的bean）-->
      <context:component-scan base-package="service"/>
      <!--    2.将业务类注入到spring中，可以通过配置，也可以通过注解@service-->
  <!--    <bean id="bookServiceImpl" class="service.BookServiceImpl">-->
  <!--        <property name="booksMapper" ref="booksMapper"></property>-->
  <!--    </bean>-->
      <!--    3.声明式事务配置-->
      <bean id="dataSourceTransactionManager" class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
          <!--        注入数据库连接池-->
          <property name="dataSource" ref="dataSource"/>

      </bean>
  <!--4.aop事务支持-->

  </beans>

  ```

### SpringMVC层

1、**web.xml**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee http://xmlns.jcp.org/xml/ns/javaee/web-app_4_0.xsd"
         version="4.0">
    <!--    1.DispatcherServlet-->
    <servlet>
        <servlet-name>DispatcherServlet</servlet-name>
        <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
        <init-param>
            <param-name>contextConfigLocation</param-name>
          <!--一定要注意:我们这里加载的是总的配置文件，即spirng总配置文件-->  
            <param-value>classpath:applicationContext.xml</param-value>
        </init-param>
        <load-on-startup>1</load-on-startup>
    </servlet>
    <servlet-mapping>
        <servlet-name>DispatcherServlet</servlet-name>
        <url-pattern>/</url-pattern>

    </servlet-mapping>
    <!--    2乱码过滤-->
    <filter>
        <filter-name>encodingFilter</filter-name>
        <filter-class>org.springframework.web.filter.CharacterEncodingFilter</filter-class>
        <init-param>
            <param-name>encoding</param-name>
            <param-value>utf-8</param-value>
        </init-param>
    </filter>
    <filter-mapping>
        <filter-name>encodingFilter</filter-name>
        <url-pattern>/*</url-pattern>
    </filter-mapping>
    <!--    请求过滤器 转换支持put delete请求-->
    <filter>
        <filter-name>HiddenHttpMethodFilter</filter-name>
        <filter-class>org.springframework.web.filter.HiddenHttpMethodFilter</filter-class>
    </filter>
    <filter-mapping>
        <filter-name>HiddenHttpMethodFilter</filter-name>
        <url-pattern>/*</url-pattern>
    </filter-mapping>
    <!--    <filter>-->
    <!--        <filter-name>FormContentFilter</filter-name>-->
    <!--        <filter-class>org.springframework.web.filter.FormContentFilter</filter-class>-->
    <!--    </filter>-->
    <!--    <filter-mapping>-->
    <!--        <filter-name>FormContentFilter</filter-name>-->
    <!--        <url-pattern>/*</url-pattern>-->
    <!--    </filter-mapping>-->
    <!--    Session 过期时间-->
    <session-config>
        <session-timeout>15</session-timeout>
    </session-config>
</web-app>

```

2、**spring-mvc.xml**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:mav="http://www.springframework.org/schema/mvc"
       xmlns:mvc="http://www.springframework.org/schema/mvc" xmlns:contex="http://mybatis.org/schema/mybatis-spring"
       xmlns:context="http://www.springframework.org/schema/context"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
       http://www.springframework.org/schema/beans/spring-beans.xsd http://www.springframework.org/schema/mvc https://www.springframework.org/schema/mvc/spring-mvc.xsd http://mybatis.org/schema/mybatis-spring http://mybatis.org/schema/mybatis-spring.xsd http://www.springframework.org/schema/context https://www.springframework.org/schema/context/spring-context.xsd">
<!--配置springmvc  
<!--    1.开启springmvc注解驱动-->
    <mav:annotation-driven/>
   <!-- 2.静态资源默认servlet配置-->
    <mvc:default-servlet-handler/>
   <!-- 3.扫描web相关的bean -->
    <context:component-scan base-package="controller" />
   <!-- 4.配置jsp 显示ViewResolver视图解析器 -->
<bean class="org.springframework.web.servlet.view.InternalResourceViewResolver">
    <property name="prefix" value="/WEB-INF/jsp/"></property>
    <property name="suffix" value=".jsp"></property>
</bean>
</beans>

```

3、**Spring配置整合文件，applicationContext.xml**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
       http://www.springframework.org/schema/beans/spring-beans.xsd">
  <!--将三个配置文导入到spring主配置文件
    <import resource="classpath:spring-mapper.xml"/>
    <import resource="classpath:spring-service.xml"/>
    <import resource="classpath:spring-springmvc.xml"/>

</beans>

```

配置暂时结束，next：controller和视图层编写

1、BookController 类编写 

```java
package controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import pojo.Books;
import service.BookService;

import java.util.List;

@Controller
@RequestMapping("/book")
public class BookController {
    @Autowired
    private BookService bookService;
//查询全部书籍,返回到展示页面
    @GetMapping("/books")
    public String list(Model model) {
        List<Books> list = bookService.queryAllBook();
        model.addAttribute("list",list);
        return "allBook";
    }
    //来到书籍添加页面
    @RequestMapping("/toaddbookpage")
    public  String  toAddBooks(){

        return  "addbooks";
    }
    //添加书籍
    @RequestMapping("/book")
    public String addBooks(Books books){
      bookService.addBook(books);
        return "redirect:/book/books";
    }

    //来到修改页面，查出当前员工，在页面回显
    @GetMapping("/book/{id}")
    public String toEditBookspage(@PathVariable("id") Integer id,Model model){
        Books books = bookService.queryBookById(id);
        model.addAttribute("book",books);
        return "editbook";
    }
    //修改书籍
    @RequestMapping(value = "/book",method = RequestMethod.PUT)
    public String editbooks(Books books){
        int i = bookService.updateBook(books);
        System.out.println(books);
        System.out.println(i);
        return "redirect:/book/books";
    }
    @DeleteMapping("/book/{id}")
    public String deletebooks(@PathVariable("id") Integer id ){
        int i = bookService.deleteBookById(id);
        return "redirect:/book/books";
    }
    @RequestMapping("/booklike")
    public String queryBookNameLike( String queryBookName,Model model){
        System.out.println(queryBookName);
        List<Books> list = bookService.queryBookNameLike(queryBookName);
        model.addAttribute("list",list);
        return  "allBook";
}}

```

2、编写首页 **index.jsp**

```jsp
<%--
  Created by IntelliJ IDEA.
  User: 30606
  Date: 2021/2/14
  Time: 19:59
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>$Title$</title>
    <style>
        a {
            text-decoration: none;
            color: cyan;
            font-size: 18px;
        }
        h2 {
            height: 38px;
            width: 180px;
            margin: 200px auto;
            text-align: center;
            line-height: 38px;
            background: pink;
            border-radius: 5px;
        }
    </style>
</head>
<body>
<h2>
    <a href="${pageContext.request.contextPath}/book/books">进入书籍页面</a>
</h2>
</body>
</html>
```

3、书籍列表页面 **allbook.jsp**

```jsp
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: 30606
  Date: 2021/2/14
  Time: 20:30
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>booklist</title>

    <link href="https://cdn.staticfile.org/twitter-bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container">
    <div class="row clearfix">
        <div class="col-md-12 column">
            <div class="page-header">
                <h1>
                    <small>书籍列表</small>
                </h1>

            </div>
        </div>
    </div>
    <div class="col-md-4 column" style="float: left">
        <button type="button" class="btn btn-success">
            <a style="text-decoration: none;color: azure" href="${pageContext.request.contextPath}/book/toaddbookpage">添加书籍</a>
        </button>
    </div>
    <div class="col-md-4 column">
        <form  action="${pageContext.request.contextPath}/book/booklike" class="form-inline" method="post">
            <div class="form-group">
<%--                <label for="exampleInputName2">Name</label>--%>
                <input type="text" class="form-control"  name="queryBookName" id="exampleInputName2" placeholder="请输入要要查询书籍的名称">
            </div>
<%--            <div class="form-group">--%>
<%--                <label for="exampleInputEmail2">Email</label>--%>
<%--                <input type="email" class="form-control" id="exampleInputEmail2" placeholder="jane.doe@example.com">--%>
<%--            </div>--%>
            <button type="submit" class="btn btn-default">查询</button>
        </form>
    </div>
    <div class="row clearfix">
        <div class="col-md-12 column">
            <table class="table table-hover table-stript">

                <thead>
                <tr>
                    <td>书籍编号</td>
                    <td>书籍名称</td>
                    <td>书籍数量</td>
                    <td>书籍描述</td>
                    <td>编辑</td>
                </tr>
<%--                <div  class="alert alert-danger" role="alert">...</div>--%>
                </thead>
                <tbody>
                <c:forEach var="books" items="${list}">
                    <tr>
                        <td>${books.bookID}</td>
                        <td>${books.bookName}</td>
                        <td>${books.bookCounts}</td>
                        <td>${books.detail}</td>
                        <td>
                            <form action="/book/book/${books.bookID }" method="post">
                                <input type="hidden" name="_method" value="DELETE">
                                <input id="deletebtn" type="submit" class="" value="删除">
                              
                            </form>
                            &nbsp;|&nbsp; <a href="/book/book/${books.bookID}">修改</a>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
<style>
    form {
        float: left;
    }

    #deletebtn {
        background: transparent; /*按钮背景透明*/
        border-width: 0px; /*边框透明*/
        outline: none; /*点击后没边框*/
        color: #337ab7;
    }

</style>
</html>

```

**4.*****添加书籍页面addbooks.jsp***

提交的form表单的input的name属性名称要与实体类的属性名称一致

```
<%--
  Created by IntelliJ IDEA.
  User: 30606
  Date: 2021/2/15
  Time: 11:53
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>addbooks</title>
    <link href="https://cdn.staticfile.org/twitter-bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container">
    <div class="row clearfix">
        <div class="col-md-12 column">
            <div class="page-header">
                <h1>
                    <small>添加书籍</small>
                </h1>
            </div>
        </div>
    </div>
    <div>
        <form action="${pageContext.request.contextPath}/book/book" method="post">

            <div class="form-group">
                <label>书籍名称</label>
                <input type="text" class="form-control" name="bookName"  placeholder="name" required>
            </div>
            <div class="form-group">
                <label>书籍数量</label>
                <input type="text" class="form-control" name="bookCounts"   placeholder="quantity" required>
            </div>
            <div class="form-group">
                <label>书籍描述</label>
                <input type="text" class="form-control" name="detail"  placeholder="description" required>
            </div>
            <div class="form-group">
                <button type="submit" class="form-control">提交</button>
            </div>
        </form>
    </div>
</div>
</body>
</html>
```

5。**书籍修改页面editbook.jsp**

```xml
<%--
  Created by IntelliJ IDEA.
  User: 30606
  Date: 2021/2/15
  Time: 11:53
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>addbooks</title>
    <link href="https://cdn.staticfile.org/twitter-bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container">
    <div class="row clearfix">
        <div class="col-md-12 column">
            <div class="page-header">
                <h1>
                    <small>添加书籍</small>
                </h1>
            </div>
        </div>

    </div>
    <div>
        <form action="${pageContext.request.contextPath}/book/book" method="post">
            <input type="hidden" name="_method" value="PUT">
            <input type="hidden" name="bookID" value="${book.bookID}">
            <div class="form-group">
                <label>书籍名称</label>
                <input type="text" class="form-control" name="bookName" value="${book.bookName}" placeholder="name" required>
            </div>
            <div class="form-group">
                <label>书籍数量</label>
                <input type="text" class="form-control" name="bookCounts"  value="${book.bookCounts}" placeholder="quantity" required>
            </div>
            <div class="form-group">
                <label>书籍描述</label>
                <input type="text" class="form-control" name="detail" value="${book.detail}" placeholder="description" required>
            </div>
            <div class="form-group">
                <button type="submit" class="form-control">修改</button>
            </div>
        </form>
    </div>
</div>
</body>
</html>

```

最后配置tomcat启动

## ssm框架restful风格实现增删改查

### 1、什么是restful风格

大家在做Web开发的过程中，method常用的值是get和post. 可事实上，method值还可以是put和delete等等其他值。
既然method值如此丰富，那么就可以考虑使用同一个url，但是约定不同的method来实施不同的业务，这就是Restful的基本考虑。

## 2、restful风格独特之处

### 2.1 url的不同

- 非restful风格：http://.../queryItems.action?id=001&type=T01
- restful风格：http://..../items/001

### 2.2 请求方法的不同

学习javaweb的时候，我们只知道了get和post两种请求方法，当restful却不止这两种

- 获取数据：GET请求
- 增加数据：POST请求
- 修改数据：PUT请求
- 删除数据：DELETE请求

### 3、ssm实现restful风格增删改查

### 3.1 配置HiddenHttpMethodFilter过滤器

浏览器form表单只支持get和post请求，而delete和put请求并不支持。HiddenHttpMethodFilter是spring中自带的一个过滤器，可以将浏览器表单请求转换为标准的http请求，使它们支持get、post、delete、put请求。

```
<filter>
	<filter-name>HiddenHttpMethodFilter</filter-name>
	<filter-class>org.springframework.web.filter.HiddenHttpMethodFilter</filter-class>
</filter>
<filter-mapping>
	<filter-name>HiddenHttpMethodFilter</filter-name>
	<url-pattern>/*</url-pattern>
</filter-mapping>

```

### 3.2 在jsp中如何指定form表单的请求方式

在表单中加入隐藏域，name属性一定要为 ”_method“,这样刚才配的HiddenHttpMethodFilter拦截器才能够识别，value属性就是我们需要的请求方式。这样springmvc就会帮我们做

```
<input type="hidden" name="_method" value="PUT">

```

### 3.3 restful参数传递

在获取一条数据时或删除一条数据时，一般情况下前端要向后端传入一个id值，restful风格的参数传递与之前讲的注解@RequestMapping()注解映射请求中的URI模板一样，将参数作为变量放在URL中。
**示例：**
前端传入id值为10000,id为以参数变量

前端浏览器URL：<http://www.example.com/users/10000>
@RequestMapping()注解：@RequestMapping("/users/{id}")
方法中接收id：public String getOneUser(@PathVariable("id") int id){}

### 3.4增删改查实例

**controller：**

```
@Controller
public class UserController {

	@Resource(name="userService")
	UserService userService;
	
	/*
	 * 查询所有用户
	 */
	@RequestMapping(value="/users",method=RequestMethod.GET)
	public String index(Model model) {
		List<User> users = userService.getAllUser();
		model.addAttribute("users", users);
		return "users";
	}
	
	/*
	 * 转发到添加用户的视图
	 */
	@RequestMapping("/addUserView")
	public String addUserView() {
		return "add";
	}
	
	/*
	 * 添加用户
	 */
	@RequestMapping(value="/addUser",method=RequestMethod.POST)
	public String addUser(User user) {
		userService.addUser(user);
		return "redirect:/users";
	}
	
	/*
	 * 获取所要修改用户的信息
	 */
	@RequestMapping(value="/user/{id}",method=RequestMethod.GET)
	public String updateUserView(@PathVariable("id") Integer id,Model model) {
		User user = userService.getOneUserById(id);
		model.addAttribute("user",user);
		return "updateUserView";
	}
	
	/*
	 * 修改用户信息
	 */
	@RequestMapping(value="/user",method=RequestMethod.PUT)
	public String updateUser(User user) {
		userService.updateUser(user);
		return "redirect:/users";
	}
	
	/*
	 * 删除用户
	 */
	@RequestMapping(value="/user/{id}",method=RequestMethod.DELETE)
	public String deleteUser(@PathVariable("id") Integer id) {
		userService.deleteUser(id);
		return "redirect:/users";
	}
	
}

```

**jsp：**

**users.jsp：**

```
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>获取全部用户信息</title>
</head>
<body>
	<table border="1" >
		<tr>
			<th>编号</th>
			<th>用户名</th>
			<th>密码</th>
			<th colspan="2">操作</th>
		</tr>
		<c:forEach var="user" items="${requestScope.users }" >
			<tr>
				<td>${user.id }</td>
				<td>${user.username }</td>
				<td>${user.password }</td>
				<td><a href="/ssm/user/${user.id }">修改</a></td>
				<td><form action="/ssm/user/${user.id }" method="post">
					<input type="hidden" name="_method" value="DELETE">
					<input type="submit" value="删除">
				</form></td>
			</tr>
		</c:forEach>
	</table>
	<a href="/ssm/addUserView">添加员工</a>
	
</body>
</html>

```

**add.jsp：**

```
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
	<form action="/ssm/addUser" method="post">
		用户名：<input type="text" name="username"><br><br>
		密  码：<input type="text" name="password"><br><br>
		<input type="submit" value="提交">
	</form>
</body>
</html>

```

**updateUserView.jsp：**

```
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
	<form action="/ssm/user" method="post">
		<input type="hidden" name="_method" value="PUT">
		<table border="1">
			<tr>
				<th>编号</th>
				<td><input type="text" name="id"
					value="${requestScope.user.id }"></td>
			</tr>
			<tr>
				<th>用户名</th>
				<td><input type="text" name="username"
					value="${requestScope.user.username }"></td>
			</tr>
			<tr>
				<th>密码</th>
				<td><input type="text" name="password"
					value="${requestScope.user.password }"></td>
			</tr>
			<tr>
				<td><input type="submit" value="修改"></td>
			</tr>
		</table>
	</form>
</body>
</html>
```

# spring

 	

# springmvc 

### springmvc执行流程

#### 图解

![spring执行流程图](D:\桌面\截图\20190403225709389.png)

###### 流程描述：

1. 用户向服务器发送请求，请求被Spring 前端控制Servelt DispatcherServlet捕获；
2. DispatcherServlet对请求URL进行解析，得到请求资源标识符（URI）。然后根据该URI，调用HandlerMapping获得该Handler配置的所有相关的对象（包括Handler对象以及Handler对象对应的拦截器），最后以HandlerExecutionChain对象的形式返回；（简单点说就是去找COntroller）
3. DispatcherServlet 根据获得的Handler，选择一个合适的HandlerAdapter；（附注：如果成功获得HandlerAdapter后，此时将开始执行拦截器的preHandler(…)方法）
4. 提取Request中的模型数据，填充Handler入参，开始执行Handler（Controller)。 在填充Handler的入参过程中，根据你的配置，Spring将帮你做一些额外的工作：

> 1、HttpMessageConveter： 将请求消息（如Json、xml等数据）转换成一个对象，将对象转换为指定的响应信息
> 2、数据转换：对请求消息进行数据转换。如String转换成Integer、Double等
> 3、数据根式化：对请求消息进行数据格式化。 如将字符串转换成格式化数字或格式化日期等
> 4、数据验证： 验证数据的有效性（长度、格式等），验证结果存储到BindingResult或Error中

1. Handler执行完成后，向DispatcherServlet 返回一个ModelAndView对象；

2. 根据返回的ModelAndView，选择一个适合的ViewResolver（必须是已经注册到Spring容器中的ViewResolver)返回给DispatcherServlet ；

3. ViewResolver 结合Model和View，来渲染视图；

4. 将渲染结果返回给客户端。

   #### Spring MVC的核心组件：

   - DispatcherServlet：中央控制器，把请求给转发到具体的控制类
   - Controller：具体处理请求的控制器
   - HandlerMapping：映射处理器，负责映射中央处理器转发给controller时的映射策略
   - ModelAndView：服务层返回的数据和视图层的封装类
   - ViewResolver：视图解析器，解析具体的视图
   - Interceptors ：拦截器，负责拦截我们定义的请求然后做处理工作

### 配置版

1、新建一个Moudle ， springmvc-02-hello ， 添加web的支持！

2、确定导入了SpringMVC 的依赖！

3、配置web.xml  ， 注册DispatcherServlet

```xml
<?xml version="1.0" encoding="UTF-8"?><web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee"        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"        xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee http://xmlns.jcp.org/xml/ns/javaee/web-app_4_0.xsd"        version="4.0">
   <!--1.注册DispatcherServlet-->  
  <servlet>     
    <servlet-name>springmvc</servlet-name> 
    <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>   
    <!--关联一个springmvc的配置文件:【servlet-name】-servlet.xml-->   
    <init-param>        
      <param-name>contextConfigLocation</param-name>     
       <param-value>classpath:springmvc-servlet.xml</param-value>
    </init-param>       <!--启动级别-1-->
    <load-on-startup>1</load-on-startup>   
  </servlet>
   <!--/ 匹配所有的请求；（不包括.jsp）--> 
  <!--/* 匹配所有的请求；（包括.jsp）--> 
  <servlet-mapping>       <servlet-name>springmvc</servlet-name>    
    <url-pattern>/</url-pattern>   </servlet-mapping>
</web-app>
```

4、编写SpringMVC 的 配置文件！名称：springmvc-servlet.xml  : [servletname]-servlet.xml

说明，这里的名称要求是按照官方来的

```xml
<?xml version="1.0" encoding="UTF-8"?><beans xmlns="http://www.springframework.org/schema/beans"      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"      xsi:schemaLocation="http://www.springframework.org/schema/beans       http://www.springframework.org/schema/beans/spring-beans.xsd">
</beans>
```

5、添加 处理映射器

```
<bean class="org.springframework.web.servlet.handler.BeanNameUrlHandlerMapping"/>
```

6、添加 处理器适配器

- ​

```xml
<bean class="org.springframework.web.servlet.mvc.SimpleControllerHandlerAdapter"/>
```

7、添加 视图解析器

```xml
<!--视图解析器:DispatcherServlet给他的ModelAndView--><bean class="org.springframework.web.servlet.view.InternalResourceViewResolver" id="InternalResourceViewResolver">   <!--前缀-->   <property name="prefix" value="/WEB-INF/jsp/"/>   <!--后缀-->   <property name="suffix" value=".jsp"/></bean>
```

8、编写我们要操作业务Controller ，要么实现Controller接口，要么增加注解；需要返回一个ModelAndView，装数据，封视图；

```java
package com.kuang.controller;
import org.springframework.web.servlet.ModelAndView;import org.springframework.web.servlet.mvc.Controller;
import javax.servlet.http.HttpServletRequest;import javax.servlet.http.HttpServletResponse;
//注意：这里我们先导入Controller接口public class HelloController implements Controller {
//也可以使用@Controller注解
   public ModelAndView handleRequest(HttpServletRequest request, HttpServletResponse response) throws Exception {  
     //ModelAndView 模型和视图       
     ModelAndView mv = new ModelAndView();
       //封装对象，放在ModelAndView中。Model    
     mv.addObject("msg","HelloSpringMVC!");    
     //封装要跳转的视图，放在ModelAndView中      
     mv.setViewName("hello"); //: /WEB-INF/jsp/hello.jsp  
     return mv; 
   }  
}
```

9、将自己的类交给SpringIOC容器，注册bean

```xml
<!--Handler--><bean id="/hello" class="com.kuang.controller.HelloController"/>
```

10、写要跳转的jsp页面，显示ModelandView存放的数据，以及我们的正常页面；

```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %><html><head>   <title>Kuangshen</title>
  </head>
  <body>${msg}
  </body>
</html>
```

11、配置Tomcat 启动测试

![tomcat验收](D:\桌面\微信截图_20201225162029.png)

可能遇到的问题：访问出现404，排查步骤：

1. 查看控制台输出，看一下是不是缺少了什么jar包。

2. 如果jar包存在，显示无法输出，就在IDEA的项目发布中，添加lib依赖！

   ![添加blib依赖](D:\桌面\截图\添加blib依赖.png)

3. 重启Tomcat 即可解决！

### 注解版

# mybatis

#### 逆向工程

mybaits需要程序员自己编写sql语句，mybatis官方提供逆向工程，可以针对单表自动生成mybatis执行所需要的代码（mapper.java,mapper.xml、po..）

### 1. 下载逆向工程，配置Maven pom.xml 文件

```
<build>
    <finalName>SpringMVCBasic</finalName>
    <!-- 添加mybatis-generator-maven-plugin插件 -->
    <plugins>
      <plugin>
        <groupId>org.mybatis.generator</groupId>
        <artifactId>mybatis-generator-maven-plugin</artifactId>
        <version>1.3.2</version>
        <configuration>
          <verbose>true</verbose>
          <overwrite>true</overwrite>
        </configuration>
      </plugin>
    </plugins>
  </build>

```

### 1. 生成代码配置文件

在maven项目下的src/main/resources 目录下新建`generatorConfig.xml`和`generator.properties`配置文件

**generator.properties**

```
jdbc.driverLocation=C:\\Users\\Yvettee\\.m2\\repository\\mysql\\mysql-connector-java\\5.1.18\\mysql-connector-java-5.1.18.jar
jdbc.driverClass=com.mysql.jdbc.Driver
jdbc.connectionURL=jdbc:mysql://localhost:3306/mybatis?useUnicode=true&amp;characterEncoding=utf-8
jdbc.userId=root
jdbc.password=root

```

**generatorConfig.xml**

```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE generatorConfiguration
        PUBLIC "-//mybatis.org//DTD MyBatis Generator Configuration 1.0//EN"
        "http://mybatis.org/dtd/mybatis-generator-config_1_0.dtd">

<generatorConfiguration>
    <!--导入属性配置-->
    <properties resource="generator.properties"></properties>

    <!--指定特定数据库的jdbc驱动jar包的位置(绝对路径)-->
    <classPathEntry location="${jdbc.driverLocation}"/>

    <context id="default" targetRuntime="MyBatis3">

        <!-- optional，旨在创建class时，对注释进行控制 -->
        <commentGenerator>
            <!--是否去掉自动生成的注释 true:是-->
            <property name="suppressDate" value="true"/>
            <property name="suppressAllComments" value="true"/>
        </commentGenerator>

        <!--jdbc的数据库连接：驱动类、链接地址、用户名、密码-->
        <jdbcConnection
                driverClass="${jdbc.driverClass}"
                connectionURL="${jdbc.connectionURL}"
                userId="${jdbc.userId}"
                password="${jdbc.password}">
        </jdbcConnection>


        <!-- 非必需，类型处理器，在数据库类型和java类型之间的转换控制-->
        <javaTypeResolver>
            <property name="forceBigDecimals" value="false"/>
        </javaTypeResolver>


        <!-- Model模型生成器,用来生成含有主键key的类，记录类 以及查询Example类
            targetPackage     指定生成的model生成所在的包名
            targetProject     指定在该项目下所在的路径
        -->
        <javaModelGenerator targetPackage="com.eurasia.pojo"
                            targetProject="src/main/java">

            <!-- 是否允许子包，即targetPackage.schemaName.tableName -->
            <property name="enableSubPackages" value="false"/>
            <!-- 是否对model添加 构造函数 -->
            <property name="constructorBased" value="true"/>
            <!-- 是否对类CHAR类型的列的数据进行trim操作 -->
            <property name="trimStrings" value="true"/>
            <!-- 建立的Model对象是否 不可改变  即生成的Model对象不会有 setter方法，只有构造方法 -->
            <property name="immutable" value="false"/>
        </javaModelGenerator>

        <!--Mapper映射文件生成所在的目录 为每一个数据库的表生成对应的SqlMap文件 -->
        <sqlMapGenerator targetPackage="com.eurasia.dao"
                         targetProject="src/main/java">
            <property name="enableSubPackages" value="false"/>
        </sqlMapGenerator>

        <!-- 客户端代码，生成易于使用的针对Model对象和XML配置文件 的代码
                type="ANNOTATEDMAPPER",生成Java Model 和基于注解的Mapper对象
                type="MIXEDMAPPER",生成基于注解的Java Model 和相应的Mapper对象
                type="XMLMAPPER",生成SQLMap XML文件和独立的Mapper接口
        -->
        <javaClientGenerator targetPackage="com.eurasia.mapper"
                             targetProject="src/main/java" type="XMLMAPPER">
            <property name="enableSubPackages" value="true"/>
        </javaClientGenerator>

        <!-- 数据表进行生成操作 tableName:表名; domainObjectName:对应的DO -->
        <table tableName="items" domainObjectName="Items"
               enableCountByExample="false" enableUpdateByExample="false"
               enableDeleteByExample="false" enableSelectByExample="false"
               selectByExampleQueryId="false">
        </table>

        <table tableName="orderdetail" domainObjectName="Orderdetail"
               enableCountByExample="false" enableUpdateByExample="false"
               enableDeleteByExample="false" enableSelectByExample="false"
               selectByExampleQueryId="false">
        </table>
        <table tableName="orders" domainObjectName="Orders"
               enableCountByExample="false" enableUpdateByExample="false"
               enableDeleteByExample="false" enableSelectByExample="false"
               selectByExampleQueryId="false">
        </table>
        <table tableName="user" domainObjectName="User"
               enableCountByExample="false" enableUpdateByExample="false"
               enableDeleteByExample="false" enableSelectByExample="false"
               selectByExampleQueryId="false">
        </table>

    </context>
</generatorConfiguration>

```

#### 2. 在Intellij IDEA添加一个“Run运行”选项

使用maven运行mybatis-generator-maven-plugin插件

![img](http://upload-images.jianshu.io/upload_images/1037735-86549bcd76a36fe1.png?imageMogr2/auto-orient/strip|imageView2/2/w/530/format/webp)

添加插件1

![img](http://upload-images.jianshu.io/upload_images/1037735-298dc7614958358f.png?imageMogr2/auto-orient/strip|imageView2/2/w/317/format/webp)

新添加Maven运行选项

### 3. 在name和Commond line分别填上如上图所示，再点击Apply和OK。

![img](http://upload-images.jianshu.io/upload_images/1037735-40a49e1e6f7b796e.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)

image.png

### 4. 最后再运行generate

![img](http://upload-images.jianshu.io/upload_images/1037735-c72941a42083dbef.png?imageMogr2/auto-orient/strip|imageView2/2/w/491/format/webp)

点击generate

### 5. 结果

![img](http://upload-images.jianshu.io/upload_images/1037735-39b588ff07c90161.png?imageMogr2/auto-orient/strip|imageView2/2/w/338/format/webp)

结果

# Git

预警：因为详细，所以行文有些长，新手边看边操作效果出乎你的预料）
一：Git是什么？
Git是目前世界上最先进的分布式版本控制系统。
工作原理 / 流程：
![图片描述](http://img1.sycdn.imooc.com/59c31e4400013bc911720340.png)
Workspace：工作区
Index / Stage：暂存区
Repository：仓库区（或本地仓库）
Remote：远程仓库

二：SVN与Git的最主要的区别？

SVN是集中式版本控制系统，版本库是集中放在中央服务器的，而干活的时候，用的都是自己的电脑，所以首先要从中央服务器哪里得到最新的版本，然后干活，干完后，需要把自己做完的活推送到中央服务器。集中式版本控制系统是必须联网才能工作，如果在局域网还可以，带宽够大，速度够快，如果在互联网下，如果网速慢的话，就纳闷了。

Git是分布式版本控制系统，那么它就没有中央服务器的，每个人的电脑就是一个完整的版本库，这样，工作的时候就不需要联网了，因为版本都是在自己的电脑上。既然每个人的电脑都有一个完整的版本库，那多个人如何协作呢？比如说自己在电脑上改了文件A，其他人也在电脑上改了文件A，这时，你们两之间只需把各自的修改推送给对方，就可以互相看到对方的修改了。

三、在windows上如何安装Git？

msysgit是 windows版的Git,如下：
![图片描述](http://img1.sycdn.imooc.com/59c1cfa400019aee02460029.jpg)
需要从网上下载一个，然后进行默认安装即可。安装完成后，在开始菜单里面找到 "Git --> Git Bash",如下：
![图片描述](http://img1.sycdn.imooc.com/59c1cfd20001c2d602530073.jpg)
会弹出一个类似的命令窗口的东西，就说明Git安装成功。如下：
![图片描述](http://img1.sycdn.imooc.com/59c1cfe70001462e06680380.jpg)

安装完成后，还需要最后一步设置，在命令行输入如下：

![图片描述](http://img1.sycdn.imooc.com/59c1d041000110d906460213.jpg)
因为Git是分布式版本控制系统，所以需要填写用户名和邮箱作为一个标识。

注意：git config --global 参数，有了这个参数，表示你这台机器上所有的Git仓库都会使用这个配置，当然你也可以对某个仓库指定的不同的用户名和邮箱。

**四：如何操作？**

一：创建版本库。

什么是版本库？版本库又名仓库，英文名repository,你可以简单的理解一个目录，这个目录里面的所有文件都可以被Git管理起来，每个文件的修改，删除，Git都能跟踪，以便任何时刻都可以追踪历史，或者在将来某个时刻还可以将文件”还原”。

所以创建一个版本库也非常简单，如下我是D盘 –> www下 目录下新建一个testgit版本库。

![图片描述](http://img1.sycdn.imooc.com/59c1d1060001909005780268.png)
pwd 命令是用于显示当前的目录。

1. 通过命令 git init 把这个目录变成git可以管理的仓库，如下：

   ![图片描述](http://img1.sycdn.imooc.com/59c1d12b0001b08305270077.png)

   这时候你当前testgit目录下会多了一个.git的目录，这个目录是Git来跟踪管理版本的，没事千万不要手动乱改这个目录里面的文件，否则，会把git仓库给破坏了。如下：

   ![图片描述](http://img1.sycdn.imooc.com/59c1d143000112df06120173.png)

   1. 把文件添加到版本库中。

      首先要明确下，所有的版本控制系统，只能跟踪文本文件的改动，比如txt文件，网页，所有程序的代码等，Git也不列外，版本控制系统可以告诉你每次的改动，但是图片，视频这些二进制文件，虽能也能由版本控制系统管理，但没法跟踪文件的变化，只能把二进制文件每次改动串起来，也就是知道图片从1kb变成2kb，但是到底改了啥，版本控制也不知道。

   **下面先看下demo如下演示：**

   我在版本库testgit目录下新建一个记事本文件 readme.txt 内容如下：11111111

   第一步：使用命令 git add readme.txt添加到暂存区里面去。如下：
   ![图片描述](http://img1.sycdn.imooc.com/59c1d2080001e4bb04490080.png)
   如果和上面一样，没有任何提示，说明已经添加成功了。

   第二步：用命令 git commit告诉Git，把文件提交到仓库。
   ![图片描述](http://img1.sycdn.imooc.com/59c1d2200001f05b04930121.png)
   现在我们已经提交了一个readme.txt文件了，我们下面可以通过命令git status来查看是否还有文件未提交，如下：
   ![图片描述](http://img1.sycdn.imooc.com/59c1d2340001a87904690107.png)
   说明没有任何文件未提交，但是我现在继续来改下readme.txt内容，比如我在下面添加一行2222222222内容，继续使用git status来查看下结果，如下：
   ![图片描述](http://img1.sycdn.imooc.com/59c1d2500001634606170171.png)
   上面的命令告诉我们 readme.txt文件已被修改，但是未被提交的修改。

接下来我想看下readme.txt文件到底改了什么内容，如何查看呢？可以使用如下命令：

git diff readme.txt 如下：
![图片描述](http://img1.sycdn.imooc.com/59c1d2cb00010a0304960202.png)
如上可以看到，readme.txt文件内容从一行11111111改成 二行 添加了一行22222222内容。

知道了对readme.txt文件做了什么修改后，我们可以放心的提交到仓库了，提交修改和提交文件是一样的2步(第一步是git add 第二步是：git commit)。

如下：
![图片描述](http://img1.sycdn.imooc.com/59c1d2ff00015a9606180342.png)
**二：版本回退：**
如上，我们已经学会了修改文件，现在我继续对readme.txt文件进行修改，再增加一行

内容为33333333333333.继续执行命令如下：

![图片描述](http://img1.sycdn.imooc.com/59c1d32b00012ba604570139.png)
现在我已经对readme.txt文件做了三次修改了，那么我现在想查看下历史记录，如何查呢？我们现在可以使用命令 git log 演示如下所示：
![图片描述](http://img1.sycdn.imooc.com/59c1d34e0001a1ac06050304.png)
git log命令显示从最近到最远的显示日志，我们可以看到最近三次提交，最近的一次是,增加内容为333333.上一次是添加内容222222，第一次默认是 111111.如果嫌上面显示的信息太多的话，我们可以使用命令 git log –pretty=oneline 演示如下：
![图片描述](http://img1.sycdn.imooc.com/59c1d3fc00013ad206040097.png)
现在我想使用版本回退操作，我想把当前的版本回退到上一个版本，要使用什么命令呢？可以使用如下2种命令，第一种是：git reset --hard HEAD^ 那么如果要回退到上上个版本只需把HEAD^ 改成 HEAD^^ 以此类推。那如果要回退到前100个版本的话，使用上面的方法肯定不方便，我们可以使用下面的简便命令操作：git reset --hard HEAD~100 即可。未回退之前的readme.txt内容如下：
![图片描述](http://img1.sycdn.imooc.com/59c1d4140001a0c404490165.png)
如果想回退到上一个版本的命令如下操作：

![图片描述](http://img1.sycdn.imooc.com/59c1d429000199fc04610105.png)

再来查看下 readme.txt内容如下：通过命令cat readme.txt查看
![图片描述](http://img1.sycdn.imooc.com/59c1d4470001fcdc04360085.png)

可以看到，内容已经回退到上一个版本了。我们可以继续使用git log 来查看下历史记录信息，如下：
![图片描述](http://img1.sycdn.imooc.com/59c1d45300012d9604800219.png)

我们看到 增加333333 内容我们没有看到了，但是现在我想回退到最新的版本，如：有333333的内容要如何恢复呢？我们可以通过版本号回退，使用命令方法如下：

git reset --hard 版本号 ，但是现在的问题假如我已经关掉过一次命令行或者333内容的版本号我并不知道呢？要如何知道增加3333内容的版本号呢？可以通过如下命令即可获取到版本号：git reflog 演示如下：
![图片描述](http://img1.sycdn.imooc.com/59c1d51a0001d5fc05100122.png)

通过上面的显示我们可以知道，增加内容3333的版本号是 6fcfc89.我们现在可以命令

git reset --hard 6fcfc89来恢复了。演示如下：
![图片描述](http://img1.sycdn.imooc.com/59c1d53a0001b8b305050153.png)

可以看到 目前已经是最新的版本了。

**三：理解工作区与暂存区的区别？**
工作区：就是你在电脑上看到的目录，比如目录下testgit里的文件(.git隐藏目录版本库除外)。或者以后需要再新建的目录文件等等都属于工作区范畴。
版本库(Repository)：工作区有一个隐藏目录.git,这个不属于工作区，这是版本库。其中版本库里面存了很多东西，其中最重要的就是stage(暂存区)，还有Git为我们自动创建了第一个分支master,以及指向master的一个指针HEAD。

我们前面说过使用Git提交文件到版本库有两步：

第一步：是使用 git add 把文件添加进去，实际上就是把文件添加到暂存区。

第二步：使用git commit提交更改，实际上就是把暂存区的所有内容提交到当前分支上。

我们继续使用demo来演示下：

我们在readme.txt再添加一行内容为4444444，接着在目录下新建一个文件为test.txt 内容为test，我们先用命令 git status来查看下状态，如下：

![图片描述](http://img1.sycdn.imooc.com/59c1d55a0001a3c306430241.png)

现在我们先使用git add 命令把2个文件都添加到暂存区中，再使用git status来查看下状态，如下：

![图片描述](http://img1.sycdn.imooc.com/59c1d56a0001a28704700241.png)

接着我们可以使用git commit一次性提交到分支上，如下：

![图片描述](http://img1.sycdn.imooc.com/59c1d57b0001b4fe06190166.png)

**四：Git撤销修改和删除文件操作。**
一：撤销修改：
比如我现在在readme.txt文件里面增加一行 内容为555555555555，我们先通过命令查看如下：
![图片描述](http://img1.sycdn.imooc.com/59c1d5e40001806803930139.png)
在我未提交之前，我发现添加5555555555555内容有误，所以我得马上恢复以前的版本，现在我可以有如下几种方法可以做修改：

第一：如果我知道要删掉那些内容的话，直接手动更改去掉那些需要的文件，然后add添加到暂存区，最后commit掉。

第二：我可以按以前的方法直接恢复到上一个版本。使用 git reset --hard HEAD^

但是现在我不想使用上面的2种方法，我想直接想使用撤销命令该如何操作呢？首先在做撤销之前，我们可以先用 git status 查看下当前的状态。如下所示：

![图片描述](http://img1.sycdn.imooc.com/59c1d5fa0001b07806400168.png)

可以发现，Git会告诉你，git checkout -- file 可以丢弃工作区的修改，如下命令：
git checkout -- readme.txt,如下所示：

![图片描述](http://img1.sycdn.imooc.com/59c1d6390001419705210140.png)

命令 git checkout --readme.txt 意思就是，把readme.txt文件在工作区做的修改全部撤销，这里有2种情况，如下：

1.readme.txt自动修改后，还没有放到暂存区，使用 撤销修改就回到和版本库一模一样的状态。
2.另外一种是readme.txt已经放入暂存区了，接着又作了修改，撤销修改就回到添加暂存区后的状态。
对于第二种情况，我想我们继续做demo来看下，假如现在我对readme.txt添加一行 内容为6666666666666，我git add 增加到暂存区后，接着添加内容7777777，我想通过撤销命令让其回到暂存区后的状态。如下所示：

![图片描述](http://img1.sycdn.imooc.com/59c1d6ca0001782f06160482.png)

注意：命令git checkout -- readme.txt 中的 -- 很重要，如果没有 -- 的话，那么命令变成创建分支了。

二：删除文件。
假如我现在版本库testgit目录添加一个文件b.txt,然后提交。如下：
![图片描述](http://img1.sycdn.imooc.com/59c1d6de0001a31606390392.png)

如上：一般情况下，可以直接在文件目录中把文件删了，或者使用如上rm命令：rm b.txt ，如果我想彻底从版本库中删掉了此文件的话，可以再执行commit命令 提交掉，现在目录是这样的，

![图片描述](http://img1.sycdn.imooc.com/59c1d78200017e8f07030192.png)

只要没有commit之前，如果我想在版本库中恢复此文件如何操作呢？

可以使用如下命令 git checkout -- b.txt，如下所示：

![图片描述](http://img1.sycdn.imooc.com/59c1d7980001368e05570244.png)

再来看看我们testgit目录，添加了3个文件了。如下所示：

![图片描述](http://img1.sycdn.imooc.com/59c1d7b70001308907550258.png)

**五：远程仓库**。
在了解之前，先注册github账号，由于你的本地Git仓库和github仓库之间的传输是通过SSH加密的，所以需要一点设置：
第一步：创建SSH Key。在用户主目录下，看看有没有.ssh目录，如果有，再看看这个目录下有没有id_rsa和id_rsa.pub这两个文件，如果有的话，直接跳过此如下命令，如果没有的话，打开命令行，输入如下命令：

ssh-keygen -t rsa –C “youremail@example.com”, 由于我本地此前运行过一次，所以本地有，如下所示：

![图片描述](http://img1.sycdn.imooc.com/59c1d7d7000120d107530169.png)

id_rsa是私钥，不能泄露出去，id_rsa.pub是公钥，可以放心地告诉任何人。

第二步：登录github,打开” settings”中的SSH Keys页面，然后点击“Add SSH Key”,填上任意title，在Key文本框里黏贴id_rsa.pub文件的内容。
![图片描述](http://img1.sycdn.imooc.com/59c1d7ef0001c75411330860.png)

点击 Add Key，你就应该可以看到已经添加的key。
![图片描述](http://img1.sycdn.imooc.com/59c1d8540001eb3707620373.png)

如何添加远程库？
现在的情景是：我们已经在本地创建了一个Git仓库后，又想在github创建一个Git仓库，并且希望这两个仓库进行远程同步，这样github的仓库可以作为备份，又可以其他人通过该仓库来协作。

首先，登录github上，然后在右上角找到“create a new repo”创建一个新的仓库。如下：

![图片描述](http://img1.sycdn.imooc.com/59c1d86a0001044b10840605.png)

在Repository name填入testgit，其他保持默认设置，点击“Create repository”按钮，就成功地创建了一个新的Git仓库：
![图片描述](http://img1.sycdn.imooc.com/59c1d8850001b5ea10260661.png)

```
目前，在GitHub上的这个testgit仓库还是空的，GitHub告诉我们，可以从这个仓库克隆出新的仓库，也可以把一个已有的本地仓库与之关联，然后，把本地仓库的内容推送到GitHub仓库。
```

现在，我们根据GitHub的提示，在本地的testgit仓库下运行命令：

git remote add origin <https://github.com/tugenhua0707/testgit.git>

所有的如下：
![图片描述](http://img1.sycdn.imooc.com/59c1d8a70001c86206320252.png)

把本地库的内容推送到远程，使用 git push命令，实际上是把当前分支master推送到远程。

由于远程库是空的，我们第一次推送master分支时，加上了 –u参数，Git不但会把本地的master分支内容推送的远程新的master分支，还会把本地的master分支和远程的master分支关联起来，在以后的推送或者拉取时就可以简化命令。推送成功后，可以立刻在github页面中看到远程库的内容已经和本地一模一样了，上面的要输入github的用户名和密码如下所示：
![图片描述](http://img1.sycdn.imooc.com/59c1d8bb00019ff310480655.png)

从现在起，只要本地作了提交，就可以通过如下命令：

git push origin master

把本地master分支的最新修改推送到github上了，现在你就拥有了真正的分布式版本库了。

1. 如何从远程库克隆？

   上面我们了解了先有本地库，后有远程库时候，如何关联远程库。

   现在我们想，假如远程库有新的内容了，我想克隆到本地来 如何克隆呢？

   首先，登录github，创建一个新的仓库，名字叫testgit2.如下：

![图片描述](http://img1.sycdn.imooc.com/59c1d95e0001f0fc10450604.png)

如下，我们看到：

![图片描述](http://img1.sycdn.imooc.com/59c1d97400014d4e10360484.png)

现在，远程库已经准备好了，下一步是使用命令git clone克隆一个本地库了。如下所示：

![图片描述](http://img1.sycdn.imooc.com/59c1d9860001e0d806370127.png)

接着在我本地目录下 生成testgit2目录了，如下所示：

![图片描述](http://img1.sycdn.imooc.com/59c1d99500016a2e07130197.png)

**六：创建与合并分支**。
在 版本回填退里，你已经知道，每次提交，Git都把它们串成一条时间线，这条时间线就是一个分支。截止到目前，只有一条时间线，在Git里，这个分支叫主分支，即master分支。HEAD严格来说不是指向提交，而是指向master，master才是指向提交的，所以，HEAD指向的就是当前分支。

首先，我们来创建dev分支，然后切换到dev分支上。如下操作：

![图片描述](http://img1.sycdn.imooc.com/59c1d9aa0001c15604080167.png)

git checkout 命令加上 –b参数表示创建并切换，相当于如下2条命令

git branch dev

git checkout dev

git branch查看分支，会列出所有的分支，当前分支前面会添加一个星号。然后我们在dev分支上继续做demo，比如我们现在在readme.txt再增加一行 7777777777777

首先我们先来查看下readme.txt内容，接着添加内容77777777，如下：

![图片描述](http://img1.sycdn.imooc.com/59c1da3f0001b5b703890392.png)

现在dev分支工作已完成，现在我们切换到主分支master上，继续查看readme.txt内容如下：

![图片描述](http://img1.sycdn.imooc.com/59c1da520001d44c06340206.png)

现在我们可以把dev分支上的内容合并到分支master上了，可以在master分支上，使用如下命令 git merge dev 如下所示：
![图片描述](http://img1.sycdn.imooc.com/59c1da69000145ca05320255.png)

git merge命令用于合并指定分支到当前分支上，合并后，再查看readme.txt内容，可以看到，和dev分支最新提交的是完全一样的。

注意到上面的Fast-forward信息，Git告诉我们，这次合并是“快进模式”，也就是直接把master指向dev的当前提交，所以合并速度非常快。

合并完成后，我们可以接着删除dev分支了，操作如下：

![图片描述](http://img1.sycdn.imooc.com/59c1da91000120cd06430139.png)

总结创建与合并分支命令如下：

查看分支：git branch

创建分支：git branch name

切换分支：git checkout name

创建+切换分支：git checkout –b name

合并某分支到当前分支：git merge name

删除分支：git branch –d name

如何解决冲突？
下面我们还是一步一步来，先新建一个新分支，比如名字叫fenzhi1，在readme.txt添加一行内容8888888，然后提交，如下所示：
![图片描述](http://img1.sycdn.imooc.com/59c1db410001036105690462.png)
同样，我们现在切换到master分支上来，也在最后一行添加内容，内容为99999999，如下所示：

![图片描述](http://img1.sycdn.imooc.com/59c1daaf0001133205840500.png)

现在我们需要在master分支上来合并fenzhi1，如下操作：

![图片描述](http://img1.sycdn.imooc.com/59c1daff000106eb06340589.png)

Git用<<<<<<<，=======，>>>>>>>标记出不同分支的内容，其中<<<HEAD是指主分支修改的内容，>>>>>fenzhi1 是指fenzhi1上修改的内容，我们可以修改下如下后保存：
![图片描述](http://img1.sycdn.imooc.com/59c1dbaf00015f2205770266.png)

如果我想查看分支合并的情况的话，需要使用命令 git log.命令行演示如下：
![图片描述](http://img1.sycdn.imooc.com/59c1dbc50001076c04970869.png)

```
3.分支管理策略。

  通常合并分支时，git一般使用”Fast forward”模式，在这种模式下，删除分支后，会丢掉分支信息，现在我们来使用带参数 –no-ff来禁用”Fast forward”模式。首先我们来做demo演示下：
```

创建一个dev分支。
修改readme.txt内容。
添加到暂存区。
切换回主分支(master)。
合并dev分支，使用命令 git merge –no-ff -m “注释” dev
查看历史记录
截图如下：
![图片描述](http://img1.sycdn.imooc.com/59c1dbdc0001836d06030780.png)

分支策略：首先master主分支应该是非常稳定的，也就是用来发布新版本，一般情况下不允许在上面干活，干活一般情况下在新建的dev分支上干活，干完后，比如上要发布，或者说dev分支代码稳定后可以合并到主分支master上来。

**七：bug分支：**
在开发中，会经常碰到bug问题，那么有了bug就需要修复，在Git中，分支是很强大的，每个bug都可以通过一个临时分支来修复，修复完成后，合并分支，然后将临时的分支删除掉。

比如我在开发中接到一个404 bug时候，我们可以创建一个404分支来修复它，但是，当前的dev分支上的工作还没有提交。比如如下：

![图片描述](http://img1.sycdn.imooc.com/59c1dc4e000141b306260166.png)

并不是我不想提交，而是工作进行到一半时候，我们还无法提交，比如我这个分支bug要2天完成，但是我issue-404 bug需要5个小时内完成。怎么办呢？还好，Git还提供了一个stash功能，可以把当前工作现场 ”隐藏起来”，等以后恢复现场后继续工作。如下：

![图片描述](http://img1.sycdn.imooc.com/59c1dc63000121ff06510188.png)

所以现在我可以通过创建issue-404分支来修复bug了。

首先我们要确定在那个分支上修复bug，比如我现在是在主分支master上来修复的，现在我要在master分支上创建一个临时分支，演示如下：

![图片描述](http://img1.sycdn.imooc.com/59c1dc7000010f8506010533.png)

修复完成后，切换到master分支上，并完成合并，最后删除issue-404分支。演示如下：

![图片描述](http://img1.sycdn.imooc.com/59c1dce00001c1ed06120441.png)
现在，我们回到dev分支上干活了。
![图片描述](http://img1.sycdn.imooc.com/59c1dcfa00019c8104220136.png)

工作区是干净的，那么我们工作现场去哪里呢？我们可以使用命令 git stash list来查看下。如下：

![图片描述](http://img1.sycdn.imooc.com/59c1dd07000152b404340093.png)

工作现场还在，Git把stash内容存在某个地方了，但是需要恢复一下，可以使用如下2个方法：

1.git stash apply恢复，恢复后，stash内容并不删除，你需要使用命令git stash drop来删除。
2.另一种方式是使用git stash pop,恢复的同时把stash内容也删除了。
演示如下

![图片描述](http://img1.sycdn.imooc.com/59c1dd1f000174d406380466.png)

**八：多人协作**。
当你从远程库克隆时候，实际上Git自动把本地的master分支和远程的master分支对应起来了，并且远程库的默认名称是origin。

要查看远程库的信息 使用 git remote
要查看远程库的详细信息 使用 git remote –v
如下演示：

![图片描述](http://img1.sycdn.imooc.com/59c1dd7d000136fd06190169.png)

一：推送分支：

```
  推送分支就是把该分支上所有本地提交到远程库中，推送时，要指定本地分支，这样，Git就会把该分支推送到远程库对应的远程分支上：

  使用命令 git push origin master
```

比如我现在的github上的readme.txt代码如下：

![图片描述](http://img1.sycdn.imooc.com/59c1dd90000164a508280459.png)

本地的readme.txt代码如下：
![图片描述](http://img1.sycdn.imooc.com/59c1dda60001771804210205.png)

现在我想把本地更新的readme.txt代码推送到远程库中，使用命令如下：
![图片描述](http://img1.sycdn.imooc.com/59c1ddbf0001271e05410203.png)

我们可以看到如上，推送成功，我们可以继续来截图github上的readme.txt内容 如下：

![图片描述](http://img1.sycdn.imooc.com/59c1ddcf0001771f08100484.png)

可以看到 推送成功了，如果我们现在要推送到其他分支，比如dev分支上，我们还是那个命令 git push origin dev

那么一般情况下，那些分支要推送呢？

master分支是主分支，因此要时刻与远程同步。
一些修复bug分支不需要推送到远程去，可以先合并到主分支上，然后把主分支master推送到远程去。
二：抓取分支：

多人协作时，大家都会往master分支上推送各自的修改。现在我们可以模拟另外一个同事，可以在另一台电脑上（注意要把SSH key添加到github上）或者同一台电脑上另外一个目录克隆，新建一个目录名字叫testgit2

但是我首先要把dev分支也要推送到远程去，如下

![图片描述](http://img1.sycdn.imooc.com/59c1ded800014adf05030151.jpg)

接着进入testgit2目录，进行克隆远程的库到本地来，如下：
![图片描述](http://img1.sycdn.imooc.com/59c1deb70001ec7605080170.png)

现在目录下生成有如下所示：
![图片描述](http://img1.sycdn.imooc.com/59c1defe0001942707180256.png)
现在我们的小伙伴要在dev分支上做开发，就必须把远程的origin的dev分支到本地来，于是可以使用命令创建本地dev分支：git checkout –b dev origin/dev

现在小伙伴们就可以在dev分支上做开发了，开发完成后把dev分支推送到远程库时。

如下：
![图片描述](http://img1.sycdn.imooc.com/59c1df160001ef1e06020730.png)

小伙伴们已经向origin/dev分支上推送了提交，而我在我的目录文件下也对同样的文件同个地方作了修改，也试图推送到远程库时，如下：
![图片描述](http://img1.sycdn.imooc.com/59c1df340001209306470759.png)

由上面可知：推送失败，因为我的小伙伴最新提交的和我试图推送的有冲突，解决的办法也很简单，上面已经提示我们，先用git pull把最新的提交从origin/dev抓下来，然后在本地合并，解决冲突，再推送。

![图片描述](http://img1.sycdn.imooc.com/59c1dfa60001473e05940282.png)

git pull也失败了，原因是没有指定本地dev分支与远程origin/dev分支的链接，根据提示，设置dev和origin/dev的链接：如下：

![图片描述](http://img1.sycdn.imooc.com/59c1dfc8000159c106460199.png)

这回git pull成功，但是合并有冲突，需要手动解决，解决的方法和分支管理中的 解决冲突完全一样。解决后，提交，再push：
我们可以先来看看readme.txt内容了。

![图片描述](http://img1.sycdn.imooc.com/59c1dff70001a87605190277.png)

现在手动已经解决完了，我接在需要再提交，再push到远程库里面去。如下所示：
![图片描述](http://img1.sycdn.imooc.com/59c1e0130001843906050480.png)

因此：多人协作工作模式一般是这样的：

首先，可以试图用git push origin branch-name推送自己的修改.
如果推送失败，则因为远程分支比你的本地更新早，需要先用git pull试图合并。
如果合并有冲突，则需要解决冲突，并在本地提交。再用git push origin branch-name推送。

感谢龙恩的贡献：<http://www.cnblogs.com/tugenhua0707/p/4050072.html>

------

------

参考阮老师整理的部分命令：<http://www.ruanyifeng.com/blog/2015/12/git-cheat-sheet.html>。
**一、新建代码库**

```shell
# 在当前目录新建一个Git代码库
$ git init

# 新建一个目录，将其初始化为Git代码库
$ git init [project-name]

# 下载一个项目和它的整个代码历史
$ git clone [url]
```

**二、配置**

```shell
# 显示当前的Git配置
$ git config --list

# 编辑Git配置文件
$ git config -e [--global]

# 设置提交代码时的用户信息
$ git config [--global] user.name "[name]"
$ git config [--global] user.email "[email address]"
```

**三、增加/删除文件**

```shell
# 添加指定文件到暂存区
$ git add [file1] [file2] ...

# 添加指定目录到暂存区，包括子目录
$ git add [dir]

# 添加当前目录的所有文件到暂存区
$ git add .

# 添加每个变化前，都会要求确认
# 对于同一个文件的多处变化，可以实现分次提交
$ git add -p

# 删除工作区文件，并且将这次删除放入暂存区
$ git rm [file1] [file2] ...

# 停止追踪指定文件，但该文件会保留在工作区
$ git rm --cached [file]

# 改名文件，并且将这个改名放入暂存区
$ git mv [file-original] [file-renamed]
```

**四、代码提交**

```shell
# 提交暂存区到仓库区
$ git commit -m [message]

# 提交暂存区的指定文件到仓库区
$ git commit [file1] [file2] ... -m [message]

# 提交工作区自上次commit之后的变化，直接到仓库区
$ git commit -a

# 提交时显示所有diff信息
$ git commit -v

# 使用一次新的commit，替代上一次提交
# 如果代码没有任何新变化，则用来改写上一次commit的提交信息
$ git commit --amend -m [message]

# 重做上一次commit，并包括指定文件的新变化
$ git commit --amend [file1] [file2] ...
```

**五、分支**

```shell
# 列出所有本地分支
$ git branch

# 列出所有远程分支
$ git branch -r

# 列出所有本地分支和远程分支
$ git branch -a

# 新建一个分支，但依然停留在当前分支
$ git branch [branch-name]

# 新建一个分支，并切换到该分支
$ git checkout -b [branch]

# 新建一个分支，指向指定commit
$ git branch [branch] [commit]

# 新建一个分支，与指定的远程分支建立追踪关系
$ git branch --track [branch] [remote-branch]

# 切换到指定分支，并更新工作区
$ git checkout [branch-name]

# 切换到上一个分支
$ git checkout -

# 建立追踪关系，在现有分支与指定的远程分支之间
$ git branch --set-upstream [branch] [remote-branch]

# 合并指定分支到当前分支
$ git merge [branch]

# 选择一个commit，合并进当前分支
$ git cherry-pick [commit]

# 删除分支
$ git branch -d [branch-name]

# 删除远程分支
$ git push origin --delete [branch-name]
$ git branch -dr [remote/branch]
```

**六、标签**

```shell
# 列出所有tag
$ git tag

# 新建一个tag在当前commit
$ git tag [tag]

# 新建一个tag在指定commit
$ git tag [tag] [commit]

# 删除本地tag
$ git tag -d [tag]

# 删除远程tag
$ git push origin :refs/tags/[tagName]

# 查看tag信息
$ git show [tag]

# 提交指定tag
$ git push [remote] [tag]

# 提交所有tag
$ git push [remote] --tags

# 新建一个分支，指向某个tag
$ git checkout -b [branch] [tag]
```

**七、查看信息**

```shell
# 显示有变更的文件
$ git status

# 显示当前分支的版本历史
$ git log

# 显示commit历史，以及每次commit发生变更的文件
$ git log --stat

# 搜索提交历史，根据关键词
$ git log -S [keyword]

# 显示某个commit之后的所有变动，每个commit占据一行
$ git log [tag] HEAD --pretty=format:%s

# 显示某个commit之后的所有变动，其"提交说明"必须符合搜索条件
$ git log [tag] HEAD --grep feature

# 显示某个文件的版本历史，包括文件改名
$ git log --follow [file]
$ git whatchanged [file]

# 显示指定文件相关的每一次diff
$ git log -p [file]

# 显示过去5次提交
$ git log -5 --pretty --oneline

# 显示所有提交过的用户，按提交次数排序
$ git shortlog -sn

# 显示指定文件是什么人在什么时间修改过
$ git blame [file]

# 显示暂存区和工作区的差异
$ git diff

# 显示暂存区和上一个commit的差异
$ git diff --cached [file]

# 显示工作区与当前分支最新commit之间的差异
$ git diff HEAD

# 显示两次提交之间的差异
$ git diff [first-branch]...[second-branch]

# 显示今天你写了多少行代码
$ git diff --shortstat "@{0 day ago}"

# 显示某次提交的元数据和内容变化
$ git show [commit]

# 显示某次提交发生变化的文件
$ git show --name-only [commit]

# 显示某次提交时，某个文件的内容
$ git show [commit]:[filename]

# 显示当前分支的最近几次提交
$ git reflog
```

**八、远程同步**

```shell
# 下载远程仓库的所有变动
$ git fetch [remote]

# 显示所有远程仓库
$ git remote -v

# 显示某个远程仓库的信息
$ git remote show [remote]

# 增加一个新的远程仓库，并命名
$ git remote add [shortname] [url]

# 取回远程仓库的变化，并与本地分支合并
$ git pull [remote] [branch]

# 上传本地指定分支到远程仓库
$ git push [remote] [branch]

# 强行推送当前分支到远程仓库，即使有冲突
$ git push [remote] --force

# 推送所有分支到远程仓库
$ git push [remote] --all
```

**九、撤销**

```shell
# 恢复暂存区的指定文件到工作区
$ git checkout [file]

# 恢复某个commit的指定文件到暂存区和工作区
$ git checkout [commit] [file]

# 恢复暂存区的所有文件到工作区
$ git checkout .

# 重置暂存区的指定文件，与上一次commit保持一致，但工作区不变
$ git reset [file]

# 重置暂存区与工作区，与上一次commit保持一致
$ git reset --hard

# 重置当前分支的指针为指定commit，同时重置暂存区，但工作区不变
$ git reset [commit]

# 重置当前分支的HEAD为指定commit，同时重置暂存区和工作区，与指定commit一致
$ git reset --hard [commit]

# 重置当前HEAD为指定commit，但保持暂存区和工作区不变
$ git reset --keep [commit]

# 新建一个commit，用来撤销指定commit
# 后者的所有变化都将被前者抵消，并且应用到当前分支
$ git revert [commit]

# 暂时将未提交的变化移除，稍后再移入
$ git stash
$ git stash pop
```

##### 十、IDEA配置git

- 为IDEA指定git路径
  默认情况下，IDEA是不自带git运行程序的，所以需要通过
  菜单->settings->Version Control->Git->Path to Git executable: 设置为安装git中所安装的git.exe
  ![在这里插入图片描述](https://img-blog.csdnimg.cn/20190608203251970.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9pbG92ZW1zcy5ibG9nLmNzZG4ubmV0,size_16,color_FFFFFF,t_70)
- 设置github账号

接下来为github设置账号密码：
菜单->settings->Version Control->GitHub->Add account
设置好了之后，IDEA的git准备工作就做好了
![在这里插入图片描述](https://img-blog.csdnimg.cn/2019060820360536.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9pbG92ZW1zcy5ibG9nLmNzZG4ubmV0,size_16,color_FFFFFF,t_70)

###### 3.用IDEA从github上pull一个现成的项目到本地，并使用

- checkout
  菜单->VCS->Chekout from Version Control->Github（或者Git）

![在这里插入图片描述](https://img-blog.csdnimg.cn/20190608204028265.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9pbG92ZW1zcy5ibG9nLmNzZG4ubmV0,size_16,color_FFFFFF,t_70)

- 输入项目参数
  输入URL，点击test即可
  这里的URL就是GitHub上的项目git地址
  Git Repositor URL:<https://github.com/how2j/higit.git>
  Parent Directory: e:\project
  Directory Name: higit
  然后点击 Clone
  ![在这里插入图片描述](https://img-blog.csdnimg.cn/20190608204156753.png)
- 如此就拿到了Git上的项目 higit,里面有一个HiGit类，运行即可看到 “HiGit”
  ![在这里插入图片描述](https://img-blog.csdnimg.cn/2019060820444618.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9pbG92ZW1zcy5ibG9nLmNzZG4ubmV0,size_16,color_FFFFFF,t_70)

###### 4.IDEA 创建的本地项目push到GitHub上

- 首先在github创建一个仓库
  登陆 [github.com](http://github.com/)
  然后点击右上角账号左边的加号，点击New repository创建仓库。
  Git上仓库就相当于项目的意思
  ![在这里插入图片描述](https://img-blog.csdnimg.cn/20190608204732648.png)
  这里输入仓库名称hiworld
  ![在这里插入图片描述](https://img-blog.csdnimg.cn/20190608204756316.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9pbG92ZW1zcy5ibG9nLmNzZG4ubmV0,size_16,color_FFFFFF,t_70)
- 创建成功，得到git地址
  <https://github.com/how2j/hiworld>
  ![在这里插入图片描述](https://img-blog.csdnimg.cn/201906082048487.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9pbG92ZW1zcy5ibG9nLmNzZG4ubmV0,size_16,color_FFFFFF,t_70)
- 本地创建一个项目
  接着在本地创建一个项目hiworld，并且新建一个Java类
  ![在这里插入图片描述](https://img-blog.csdnimg.cn/2019060820493889.png)

```
public class HiWorld {
    public static void main(String args[]){
        System.out.println("Hi World");
    }
}
12345
```

- 创建本地仓库

菜单->VCS->import into Version Control->Create Git Repository->e:\project\hiworld-OK
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190608205034963.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9pbG92ZW1zcy5ibG9nLmNzZG4ubmV0,size_16,color_FFFFFF,t_70)

- 把项目加入到本地仓库的stage区暂存
  右键项目->Git->Add
  ![在这里插入图片描述](https://img-blog.csdnimg.cn/2019060820510769.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9pbG92ZW1zcy5ibG9nLmNzZG4ubmV0,size_16,color_FFFFFF,t_70)
- 将暂存的项目提交到本地仓库然后提交到远程仓库(IDEA里将这两步骤简化为一步 即Commit and Push)

右键项目->Git->Commit Directory之后弹出如图所示的窗口，在Commit Message 输入 test， 然后点击 Commit And Push

![在这里插入图片描述](https://img-blog.csdnimg.cn/20190608205652705.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9pbG92ZW1zcy5ibG9nLmNzZG4ubmV0,size_16,color_FFFFFF,t_70)

- 这里会询问你要提交的哪里去，点击Define remote,并输入在" 创建成功，得到git地址 "步骤中的：

```
https://github.com/how2j/hiworld
1
```

![在这里插入图片描述](https://img-blog.csdnimg.cn/20190608205858962.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9pbG92ZW1zcy5ibG9nLmNzZG4ubmV0,size_16,color_FFFFFF,t_70)

-查看github
再次刷新github地址：
<https://github.com/how2j/hiworld>
就可以看到都push上去了
![在这里插入图片描述](https://img-blog.csdnimg.cn/20190608205959611.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9pbG92ZW1zcy5ibG9nLmNzZG4ubmV0,size_16,color_FFFFFF,t_70)

###### 5.IDEA里代码提交和项目更新

- 把HiWorld随便改改，只要和以前不一样就行

![在这里插入图片描述](https://img-blog.csdnimg.cn/20190608210141537.png)

- 使用快捷键CTRL+K,就会弹出提交的界面，点击Commit and Push即可
  ![在这里插入图片描述](https://img-blog.csdnimg.cn/20190608210208446.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9pbG92ZW1zcy5ibG9nLmNzZG4ubmV0,size_16,color_FFFFFF,t_70)
- 点击快捷键Ctrl+T，就会弹出更新的界面，点击OK即可
  ![在这里插入图片描述](https://img-blog.csdnimg.cn/20190608210229895.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9pbG92ZW1zcy5ibG9nLmNzZG4ubmV0,size_16,color_FFFFFF,t_70)


# springboot

导入springboot项目 po'm.xml 报红，出现

		Invalid Maven home directory configured 
				D:/Maven/apache-maven-3.6.3 
				Bundled maven 3.6.1 will be used
![QQ截图20210105093608](D:\桌面\截图\QQ截图20210105093608.png)

需要检查maven配置，因项目重加载的时候对maven中的地址有所影响需重新检查配置

原因是自己原来写项目用的maven路径和新导入的工程用的maven路径不一致，需要将导入工程的maven路径设置为自己原来使用的maven路径。

如果是SpringBoot应用则在Edit Configurations中找到Templates,往下拉找到Maven-》General 把Use project settings勾选掉

![QQ截图20210105094058](D:\桌面\截图\QQ截图20210105094058.png)



但是配置的环境如果和你机器中的maven地址找不到的话就会报上面的错误