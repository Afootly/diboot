package Controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class RestfulController {
    @RequestMapping("/add")
    public String test1(int a, int b, Model model) {
        model.addAttribute("msg", "结果为" + a + b);
        return "hello";
    }@RequestMapping(value = "/add/{a}/{b}" ,method = RequestMethod.GET)
    public String test2(@PathVariable("a") int a,  @PathVariable("b") int b, Model model){
        model.addAttribute("msg", "结果为" + a + b);
        return  "hello";
    }
}
