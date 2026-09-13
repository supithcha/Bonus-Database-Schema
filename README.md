# Bonus-Database-Schema
Prepared by Supithcha Jongphoemwatthanaphon in partial fulfillment of the requirements for the Project Manager (Software) interview.

มี Table 3 tables 
- Worker.csv - เก็บข้อมูลชื่อพนักงาน โดย column Salary คือเงินเดือนที่ได้ทั้งปี
- Bonus.csv - เก็บข้อมูลโบนัสที่เคยให้พนักงาน (worker_ref_id จะเชื่อมกับ worker_id ของ table Worker)
- Title.csv - เก็บข้อมูลตำแหน่งของพนักงานแต่ละคน (worker_ref_id จะเชื่อมกับ worker_id ของ table Worker) ถ้าคนไหนไม่มีตำแหน่งให้ตีเป็น Executive

A.ให้เขียน SQL Query ในแต่ละข้อดังต่อไปนี้ 
- A1 แสดงเงินเดือนเฉลี่ยของแต่ละแผนก
<img height="100" alt="Screenshot 2569-09-14 at 01 18 12" src="https://github.com/user-attachments/assets/8bc0ee08-71d3-4419-a273-8fa2442634dd" />

- A2 แสดงจำนวนพนักงานในแต่ละแผนก โดยให้เรียงจากมากไปน้อย
<img height="100" alt="Screenshot 2569-09-14 at 01 18 48" src="https://github.com/user-attachments/assets/3852f47e-771a-4a50-b627-16b7d5c7e925" />

- A3 แสดงพนักงานที่มีเงินเดือนเท่ากัน
<img height="120" alt="Screenshot 2569-09-14 at 01 21 28" src="https://github.com/user-attachments/assets/0d1c43b3-1e4a-4064-8077-ffbdc3bcbfea" />

- A4 แสดงแผนกที่มีการจ่ายโบนัสเยอะที่สุด
<img height="100" alt="Screenshot 2569-09-14 at 01 23 38" src="https://github.com/user-attachments/assets/51650ccf-5a3d-40a5-a39f-c05465d80684" />

- A5 แสดงชื่อพนักงานที่เงินเดือนรวมกับโบนัสเยอะที่สุดในแต่ละแผนก
<img height="120" alt="Screenshot 2569-09-14 at 01 22 33" src="https://github.com/user-attachments/assets/1ddc74ec-9670-49d0-9574-47eded09ee8b" />
  
- A5 แสดงชื่อตำแหน่งที่เงินเดือนรวมกันเยอะที่สุดในแต่ละแผนก
<img height="100" alt="Screenshot 2569-09-14 at 01 26 37" src="https://github.com/user-attachments/assets/3097d6ae-ec9b-46a9-b6f8-692789a84498" />
