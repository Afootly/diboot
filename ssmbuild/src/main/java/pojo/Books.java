package pojo;

import org.hibernate.validator.constraints.Email;
import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Pattern;
import javax.validation.constraints.Size;

public class Books {
    private Integer bookID;
   // 用户名必须是2-5位中文或者6-16位英文和数字的组合
//    @Pattern(regexp="(^[a-zA-Z0-9_-]{6,16}$)|(^[\\u2E80-\\u9FFF]{2,5})"
//            ,message="书籍名称格式错误")
   @NotNull
   @Size(min = 1, max = 2)
    private String bookName;
    public Integer getBookID() {
        return bookID;
    }
    public void setBookID(Integer bookID) {
        this.bookID = bookID;
    }
    public String getBookName() {
        return bookName;
    }
    public void setBookName(String bookName) {
        this.bookName = bookName;
    }
    public Integer getBookCounts() {
        return bookCounts;
    }
    public void setBookCounts(Integer bookCounts) {
        this.bookCounts = bookCounts;
    }
    private Integer bookCounts;
    @Email
    private String detail;
    public String getDetail() {
        return detail;
    }
    public void setDetail(String detail) { this.detail = detail == null ? null : detail.trim(); }

    public Books(Integer bookID, String bookName, Integer bookCounts, String detail) {
        this.bookID = bookID;
        this.bookName = bookName;
        this.bookCounts = bookCounts;
        this.detail = detail;
    }

    @Override
    public String toString() {
        return "Books{" +
                "bookIDd=" + bookID +
                ", bookName='" + bookName + '\'' +
                ", bookCounts=" + bookCounts +
                ", detail='" + detail + '\'' +
                '}';

    }}
