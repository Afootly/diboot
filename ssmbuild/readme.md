ssm框架整合步骤(crud)

主要重点是将个个框架的配置文件分开，个个层的配置文件分离，再导入到sring主配置文件中



环境要求

环境：

- IDEA
- MySQL 5.7.19
- Tomcat 9
- Maven 3.6

数据库环境

创建一个存放书籍数据的数据库表

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

基本环境搭建

1、新建一Maven项目！ssmbuild 



添加web支持



2、导入相关的pom依赖！

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
    

3、建立基本结构和配置框架！





- com.kuang.pojo
- com.kuang.dao
- com.kuang.service
- com.kuang.controller
- mybatis-config.xml(mybatis配置文件)

    <?xml version="1.0" encoding="UTF-8" ?>
    <!DOCTYPE configuration
           PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
           "http://mybatis.org/dtd/mybatis-3-config.dtd">
    <configuration>
    
    </configuration>

- applicationContext.xml（spring主配置文件）
      <?xml version="1.0" encoding="UTF-8"?>
      <beans xmlns="http://www.springframework.org/schema/beans"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.springframework.org/schema/beans
             http://www.springframework.org/schema/beans/spring-beans.xsd">
      
      </beans>

Mybatis层编写

1、数据库配置文件 database.properties

    jdbc.driver=com.mysql.jdbc.Driver
    jdbc.url=jdbc:mysql://localhost:3306/ssmbuild?useSSL=true&useUnicode=true&characterEncoding=utf8
    jdbc.username=root
    jdbc.password=123456
    #使用8.0以上把版本数据库加上时区参数serverTimezone=UTC
    

2.编写MyBatis的核心配置文件

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

3、编写数据库对应的实体类 pojo.Books

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
    

4、编写Dao层的 Mapper接口！

接口：

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

5、编写接口对应的 Mapper.xml 文件。需要导入MyBatis的包；

- BooksMapper.xml

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

如果不想编写实体和接口可以使用mybatis的逆向工程过根据数据库自动生成实体类和映射文件

1.添加依赖

    <!-- https://mvnrepository.com/artifact/org.mybatis.generator/mybatis-generator-core mybatis 逆向工程 -->
    <dependency>
        <groupId>org.mybatis.generator</groupId>
        <artifactId>mybatis-generator-core</artifactId>
        <version>1.3.7</version>
    </dependency>
    

2.编写工程配置文件generatorConfig.xml

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
    

3.编写启动生成类Generator

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
    

4.运行main 方法生成

6、编写Service层的接口和实现类

接口：

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

实现类：

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
    
    

OK，到此，底层需求操作编写完毕！

Spring层

1、配置Spring整合MyBatis，我们这里数据源使用c3p0连接池；

2、我们去编写Spring整合Mybatis的相关的配置文件；

- spring-mapper.xml

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
    

3、Spring整合service层

- spring-sevice.xml
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
      

SpringMVC层

1、web.xml

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
    

2、spring-mvc.xml

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
    

3、Spring配置整合文件，applicationContext.xml

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
    

配置暂时结束，next：controller和视图层编写

1、BookController 类编写 

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
    

2、编写首页 index.jsp

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

3、书籍列表页面 allbook.jsp

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
    

4.*添加书籍页面addbooks.jsp*

提交的form表单的input的name属性名称要与实体类的属性名称一致

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

5。书籍修改页面editbook.jsp

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
    

最后配置tomcat启动
