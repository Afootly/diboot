package controller;




import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import pojo.Books;
import service.BookService;
import utils.Msg;

import java.util.List;

@Controller
@RequestMapping("/book")
public class BookController {
    @Autowired
    private BookService bookService;


    //查询全部书籍,返回到展示页面
    /*
    使用json改造数据返回形式
    导入jackson包
     */
    @GetMapping("/books")
    @ResponseBody //以json形式返回数据
    public Msg getBooksWithJosn(@RequestParam(value = "pn", defaultValue = "1") Integer pn, Model model) {

        PageHelper.startPage(pn, 5);
        List<Books> list = bookService.queryAllBook();
        //使用PageInfo包装查询后的结果
        //封装了详细的分页信息，包括有我们查询出来的数据
        PageInfo pageInfo = new PageInfo(list, 5);//传入连续显示的页数
        //使用自定义类添加了要返回的信息
        return Msg.success().add("pageinfo_list",pageInfo);
    }

//      @GetMapping("/books")
    //前端传入页码：pn ,
    public String list(@RequestParam(value = "pn", defaultValue = "1") Integer pn, Model model) {

        //在查询前只需要调用，传入页码，每页的大小
        PageHelper.startPage(pn, 5);
        List<Books> list = bookService.queryAllBook();
        //使用PageInfo包装查询后的结果
        //封装了详细的分页信息，包括有我们查询出来的数据
        PageInfo pageInfo = new PageInfo(list, 5);//传入连续显示的页数

model.addAttribute("pageinfo_list",pageInfo);
        return "allBook";
    }

    //来到书籍添加页面
    @RequestMapping("/toaddbookpage")
    public String toAddBooks() {

        return "addbooks";
    }

    //添加书籍
    @PostMapping ("/book")
    @ResponseBody
    public Msg addBooks(Books books) {
        System.out.println(books);
        bookService.addBook(books);

        return  Msg.success();

    }

    //来到修改页面，查出当前员工，在页面回显
    @GetMapping("/book/{id}")
    public String toEditBookspage(@PathVariable("id") Integer id, Model model) {
        Books books = bookService.queryBookById(id);
        model.addAttribute("book", books);
        return "editbook";
    }

    //修改书籍
    @RequestMapping(value = "/book", method = RequestMethod.PUT)
    public String editbooks(Books books) {
        int i = bookService.updateBook(books);
        System.out.println(books);
        System.out.println(i);
        return "redirect:/book/books";
    }

    @DeleteMapping("/book/{id}")
    public String deletebooks(@PathVariable("id") Integer id) {
        int i = bookService.deleteBookById(id);
        return "redirect:/book/books";
    }

    @RequestMapping("/booklike")
    public String queryBookNameLike(String queryBookName, Model model) {
        System.out.println(queryBookName);
        List<Books> list = bookService.queryBookNameLike(queryBookName);
        model.addAttribute("list", list);
        return "allBook";
    }
//    @RequestMapping("/json1")
//    @ResponseBody
//    public String json1() throws JsonProcessingException {
//        //创建一个jackson的对象映射器，用来解析数据
//        ObjectMapper mapper = new ObjectMapper();
//        //创建一个对象
// Books books =new Books(1,"ddd",45,"dfsd");
//        //将我们的对象解析成为json格式
//        String str = mapper.writeValueAsString(books);
//        //由于@ResponseBody注解，这里会将str转成json格式返回；十分方便
//        return str;
//    }}
    @RequestMapping("/tobooks")
    public String tobooks(){
        return "allBook";


    }
}
