package com.atguigu.springbootconfigautoconfig.controller;


import com.atguigu.springbootconfigautoconfig.dao.DepartmentDao;
import com.atguigu.springbootconfigautoconfig.dao.EmployeeDao;
import com.atguigu.springbootconfigautoconfig.entities.Department;
import com.atguigu.springbootconfigautoconfig.entities.Employee;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.Collection;
@Controller
public class EmployeeController {
    //查询所有员工返回列表页面
    // classpath:/templates/xxxx.html
    @Autowired
    EmployeeDao employeeDao;
    @Autowired
    DepartmentDao departmentDao;
    @GetMapping("/emps")
    public String  list( Model model){
        Collection<Employee> all = employeeDao.getAll();
        //放在请求域中
        model.addAttribute("emps",all);
        return "emp/list";

    }
    //来到员工添加页面
    @GetMapping("/emp")
    public String toAddPage( Model model){
        //来到添加页面,查出所有部门，在页面显示
        Collection<Department> departments = departmentDao.getDepartments();
        model.addAttribute("depts",departments);

        return "emp/add";

    }
    //员工添加
    //SpringMVC自动将请求参数和入参对象的属性进行一一绑定；要求请求参数的名字和javaBean入参的对象里面的属性名是一样的
    @PostMapping("/emp")
 public String  addEmp( Employee employee){
     // redirect: 表示重定向到一个地址  /代表当前项目路径
     // forward: 表示转发到一个地址
     System.out.println("添加的员工信息"+employee);
     //保存员工
     employeeDao.save(employee);
        return "redirect:/emps";
 }
    //来到修改页面，查出当前员工，在页面回显
    @GetMapping("/emp/{id}")
    public String toEditPage(@PathVariable("id") Integer id,Model model){
        Employee employee = employeeDao.get(id);

        model.addAttribute("emp",employee);


        //页面要显示所有的部门列表
        Collection<Department> departments = departmentDao.getDepartments();
        model.addAttribute("depts",departments);
        //回到修改页面
        return "emp/edit";
    }
    //员工修改；需要提交员工id；
    @PutMapping ("/editemp")
    public String updateEmployee(Employee employee){
        System.out.println("修改的员工数据："+employee);
        employeeDao.save(employee);
        return "redirect:/emps";
    }
    //员工删除
    @DeleteMapping("/emp/{id}")
    public String deleteEmp(  @  PathVariable Integer id){
        employeeDao.delete(id);
        return  "redirect:/emps";


    }
}
