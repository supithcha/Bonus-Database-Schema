# Bonus-Database-Schema
Prepared by Supithcha Jongphoemwatthanaphon in partial fulfillment of the requirements for the Project Manager (Software) interview.

มี Table 3 tables 
Worker.csv - เก็บข้อมูลชื่อพนักงาน โดย column Salary คือเงินเดือนที่ได้ทั้งปี
Bonus.csv - เก็บข้อมูลโบนัสที่เคยให้พนักงาน (worker_ref_id จะเชื่อมกับ worker_id ของ table Worker)
Title.csv - เก็บข้อมูลตำแหน่งของพนักงานแต่ละคน (worker_ref_id จะเชื่อมกับ worker_id ของ table Worker) ถ้าคนไหนไม่มีตำแหน่งให้ตีเป็น Executive

A.ให้เขียน SQL Query ในแต่ละข้อดังต่อไปนี้ 
A1 แสดงเงินเดือนเฉลี่ยของแต่ละแผนก
A2 แสดงจำนวนพนักงานในแต่ละแผนก โดยให้เรียงจากมากไปน้อย
A3 แสดงพนักงานที่มีเงินเดือนเท่ากัน
A4 แสดงแผนกที่มีการจ่ายโบนัสเยอะที่สุด
A5 แสดงชื่อพนักงานที่เงินเดือนรวมกับโบนัสเยอะที่สุดในแต่ละแผนก
A5 แสดงชื่อตำแหน่งที่เงินเดือนรวมกันเยอะที่สุดในแต่ละแผนก

