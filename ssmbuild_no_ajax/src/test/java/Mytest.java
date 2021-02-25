import mapper.BooksMapper;
import org.junit.Test;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import pojo.Books;
import service.BookService;

import java.util.List;

public class Mytest {
    @Test
    public void test(){
    ClassPathXmlApplicationContext context =new ClassPathXmlApplicationContext("applicationContext.xml");
        BooksMapper bean = context.getBean(BooksMapper.class);
        for(Books attribute :  bean.queryAllBook()) {
            System.out.println(attribute);
        }
        }
        @Test
        public void test2(){
        ClassPathXmlApplicationContext context =new ClassPathXmlApplicationContext("applicationContext.xml");
            BooksMapper bean = context.getBean(BooksMapper.class);
            List<Books> list = bean.queryBookNameLike("J");
           for (Books books:list){
               System.out.println(books);
           }
        }


}
