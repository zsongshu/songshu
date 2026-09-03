# JDK8语法糖





|     |     |
| --- | --- |
| JDK7 | JDK8 |
| List<Student> students = Arrays.asList(student1, student2, student3, student4);<br>students.sort((studentP1, studentP2) -> Student.compareByScore(studentP1, studentP2));<br> | students.sort(Student::compareByScore);<br> |





    Created at: 2019-12-15T22:56:26+08:00
    Updated at: 2019-12-15T22:59:17+08:00

