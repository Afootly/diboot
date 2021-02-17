package Controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
public class RestfulController {
    @RequestMapping("/add")
    public String test1(int a, int b, Model model) {
        model.addAttribute("msg", "结果为" + a + b);
        return "hello";
    }

    @RequestMapping(value = "/add/{a}/{b}", method = RequestMethod.GET)
    public String test2(@PathVariable("a") int a, @PathVariable("b") int b, Model model) {
        model.addAttribute("msg", "结果为" + a + b);
        return "hello";
    }@GetMapping("/test3")
    public String test( String name , Model model){
        System.out.println(name);
        model.addAttribute("msg",name);
        return  "hello";
    }


}
