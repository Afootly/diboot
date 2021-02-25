package service;

import mapper.BooksMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import pojo.Books;

import java.util.List;

@Service //将实现类注入到spring容器中（使用@Sevice注解）
public class BookServiceImpl implements BookService {

    @Autowired //将接口属性注入到实现类中
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

//    public void setBooksMapper(BooksMapper booksMapper) {
//    }
}

