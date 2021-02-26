import mapper.BooksMapper;
import org.apache.ibatis.session.ExecutorType;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import org.springframework.stereotype.Component;
import pojo.Books;
import service.BookService;

import java.util.List;
import java.util.UUID;

public class Mytest {
    //获取sqlsession
//从spring注入原有的sqlSessionTemplate
private     ClassPathXmlApplicationContext context =new ClassPathXmlApplicationContext("applicationContext.xml");
private     BooksMapper booksMapper = context.getBean(BooksMapper.class);
    @Test
    public void test(){


        for(Books attribute :  booksMapper.queryAllBook()) {
            System.out.println(attribute);
        }
        }
        @Test
        public void test2(){


            List<Books> list = booksMapper.queryBookNameLike("J");
           for (Books books:list){
               System.out.println(books);
           }
        }
//        //批量插入数据测试
    @Test
    public void test3(){
//        // 新获取一个模式为BATCH，自动提交为false的session
//// 如果自动提交设置为true,将无法控制提交的条数，改为最后统一提交，可能导致内存溢出
//        SqlSession sqlSession = sqlSessionFactory.openSession(ExecutorType.BATCH, false);//跟上述sql区别
//        for (int i = 0; i < 100; i++) {
//            String kid= UUID.randomUUID().toString().substring(0,5)+i;
//            sqlSession.getMapper(BooksMapper.class).addBook(new Books(1,kid+"name",i,"fdaf"));
//
//        }      sqlSession.commit();
//        System.out.println("测试完成");
        for (int i = 0; i < 100; i++) {
            String kid= UUID.randomUUID().toString().substring(0,5)+i;
            booksMapper.addBook(new Books(null,kid+"boookname",i,"描述"));



        }
    }





}
