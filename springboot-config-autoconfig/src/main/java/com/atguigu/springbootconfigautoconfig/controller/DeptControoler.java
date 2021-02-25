package com.atguigu.springbootconfigautoconfig.controller;

import com.atguigu.springbootconfigautoconfig.dao.DepartmentDao;
import com.atguigu.springbootconfigautoconfig.entities.Department;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.Collection;
@Controller
public class DeptControoler {
    @Autowired
    DepartmentDao departmentDao;
    @GetMapping("/depts")
    public String list(Model model){
        Collection<Department> departments = departmentDao.getDepartments();
        model.addAttribute("depts",departments);
        return  "dept/list";

    }
    //来到部门添加页面
    @GetMapping ("/dept")
    public  String toAdddept(){
        return "dept/add";
    }
    //部门添加
    @PostMapping("/dept")
    public  String adddept(Department department){
        departmentDao.save(department);
        return "redirect:/depts";
    }
    //来到部门编辑页面/查出当前部门，在页面上回显
    @GetMapping("/dept/{id}")
    public  String toEditPage(@PathVariable("id") Integer id, Model model){
        Department department = departmentDao.getDepartment(id);
        model.addAttribute("dept",department);
        return "dept/edit";
    }

//部门修改，需要提交部门id
    @PutMapping("editdept")
    public String updatedept( Department department){
        System.out.println("修改的员工数据"+department);
        departmentDao.save(department);
        return "redirect:/depts";
    }
    //部门删除
    @DeleteMapping("/dept/{id}")
    public  String deletedetp(@PathVariable("id") Integer id){
        departmentDao.delete(id);
        return "redirect:/depts";

}}
