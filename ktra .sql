-- khoi tao csdl
CREAT DATABASE bkinside;
USE bkinside;


-- khoi tao bang
CREATE TABLE students(
	studentId INT(4) PRIMARY KEY AUTO_INCREMENT,
    studentName VARCHAR(50),
    age INT(4) CHECK (age > 15 AND age < 50),
    email VARCHAR(100)
);

CREATE TABLE subjects(
	subjectId INT(4) PRIMARY KEY AUTO_INCREMENT,
    subjectName VARCHAR(50)
);

CREATE TABLE classes(
	classId INT(4) PRIMARY KEY AUTO_INCREMENT,
    className VARCHAR(50)
);

CREATE TABLE marks(
	mark INT,
    subjectId INT,
    FOREIGN KEY (subjectId) REFERENCES subjects(subjectId),
    studentId INT,
    FOREIGN KEY (studentId) REFERENCES students(studentId)
);

CREATE TABLE classStudent(
	studentId INT(4),
    FOREIGN KEY (studentId) REFERENCES students(studentId),
    classId INT(4),
    FOREIGN KEY (classId) REFERENCES classes(classId)
);

-- chen du lieu
INSERT INTO students VALUES 
	(null,'Nguyễn Quang Anh',19,'anh@gmail.com'),
    (null,'Nguyễn Văn Lâm',21,'lam@gmail.com'),
    (null,'Phạm Văn Quyết',27,'quyet'),
    (null,'Nguyễn Quang Hải',25,'hai@gmail.com'),
    (null,'Phạm Văn Đức',24,'duc@gmail.com')

INSERT INTO classes VALUES
	(null,'C2110I1'),
    (null,'C2110I2')

INSERT INTO subjects VALUES
	(null,'SQL'),
    (null,'Java'),
    (null,'C'),
    (null,'Visual Basic')

INSERT INTO marks VALUES
	(8,1,1),
    (4,2,1),
    (9,1,1),
    (7,1,3),
    (3,1,4),
    (5,2,5),
    (8,3,3),
    (1,3,5),
    (3,2,4)

INSERT INTO classstudent VALUES
	(1,1),
    (2,1),
    (3,2),
    (4,2),
    (5,2)

-- Question 4
-- y/c 1: hiển thị danh sách tất cả học viên sắp xếp theo tên học viên
SELECT * FROM students ORDER BY studentName

-- y/c 2: hiển thị danh sách tất cả các môn
SELECT * FROM subjects

-- y/c 3: hiển thị danh sách những học viên nào có địa chỉ email chính xác
SELECT * FROM `students` WHERE email LIKE '%@gmail.com' -- mang tính tương đối

-- y/c 4: hiển thị danh sách những bạn học viên có họ Nguyễn
SELECT * FROM `students` WHERE `studentName` LIKE 'Nguyễn%';

-- y/c 5: hiển thị danh sách các bạn học viên lớp C2110I2
SELECT s.studentName, c.className FROM students s 
	INNER JOIN classstudent cl ON cl.studentId = s.studentId
    INNER JOIN classes c ON c.classId = cl.classId 
		WHERE c.className = 'C2110I2';

-- y/c 6: hiển thị danh sách và điểm học viên ứng với môn học
SELECT s.studentName, sj.subjectName,m.mark FROM students s 
	INNER JOIN marks m ON m.studentId = s.studentId 
    INNER JOIN subjects sj ON m.subjectId = sj.subjectId;

-- y/c 7: hiển thị danh sách học viên chưa thi môn nào (chưa có điểm)
SELECT s.studentName, sj.subjectName, m.mark FROM students s 
	LEFT JOIN marks m ON m.studentId = s.studentId 
	LEFT JOIN subjects sj ON sj.subjectId = m.subjectId
		WHERE m.studentId IS NULL;

-- y/c 8: hiển thị môn nào chưa được học viên nào thi
SELECT sj.subjectName FROM subjects sj 
	LEFT JOIN marks m ON sj.subjectId = m.subjectId 
		WHERE m.subjectId IS NULL;

-- y/c 9: tính điểm trung bình cho các học viên
SELECT s.studentName, AVG(m.mark) FROM marks m 
	LEFT JOIN students s ON m.studentId = s.studentId GROUP BY s.studentName;

-- y/c 10: hiển thị môn nào được thi nhiều nhất
SELECT sj.subjectName , COUNT(m.subjectId) FROM marks m 
	INNER JOIN subjects sj ON sj.subjectId=m.subjectId
		GROUP BY sj.subjectName ORDER BY COUNT(m.subjectId) DESC;

-- y/c 11: hiển thị môn nào có học viên thi được điểm cao nhất
SELECT sj.subjectName, MAX(m.mark) FROM subjects sj
	INNER JOIN marks m ON m.subjectId = sj.subjectId;

-- y/c 12: hiển thị môn học nào có nhiều điểm dưới trung bình nhất (<5)
SELECT sj.subjectName, COUNT(m.mark) FROM marks m 
	INNER JOIN subjects sj ON m.subjectId = sj.subjectId WHERE m.mark<5 
	GROUP BY sj.subjectName ORDER BY COUNT(m.mark) DESC;

-- Question 5
-- y/c 1
ALTER TABLE students
	ADD CONSTRAINT CHECK (age > 15 AND age < 50);

-- y/c 2: xóa học viên có studentId = 1
DELETE FROM marks WHERE studentId = 1;
DELETE FROM classstudent WHERE studentId = 1;
DELETE FROM students WHERE studentId = 1;

-- y/c 3
ALTER TABLE students ADD COLUMN status BIT DEFAULT 1;

-- y/c 4
UPDATE students SET status = 0 WHERE studentId = 3;

-- y/c bổ sung: hiển thị học viên, tên môn học có điểm > 5
SELECT s.studentName,sj.subjectName,m.mark FROM marks m 
	INNER JOIN subjects sj ON m.subjectId = sj.subjectId 
    INNER JOIN students s ON s.studentId = m.studentId
    	WHERE m.mark>5;