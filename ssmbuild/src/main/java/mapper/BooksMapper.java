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
