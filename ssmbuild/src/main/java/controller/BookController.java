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
