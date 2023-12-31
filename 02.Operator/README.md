## Divider

* X = D x Q + R
* X is dividend, D is divisor
* our calculation is X / D.
* Therefore, Q width = X width - D width

### Divider method
![image](https://github.com/ChloeeeYoo/Verilog_CommonBlock/assets/51250746/448b22a5-f745-4d3b-8f44-50131381eeaf)

### Verilog explanation
* divisor_shift = { 0, divisor, {(Q width - 1) 0}}  ; X와 자리 맞춤
* diff = { 0, dividend} - { 0, divisor_shift}       ; 나눗셈 빼기
* q = diff[MSB]값이 양수이면 0, 음수이면 1.
* remainder = q=0 이면 dividend(X), q=1 이면 diff 값이 됨 

### Verilog parameter table
![image](https://github.com/ChloeeeYoo/Verilog_CommonBlock/assets/51250746/1fc0d890-38e2-4f87-bf93-c9491ef491f7)



## Rounding

* shift round
* unsigned / signed

### Figures
![image](https://github.com/ChloeeeYoo/Verilog_CommonBlock/assets/51250746/a20b3e86-8729-43d7-b0a5-f018b7eeb671)
![image](https://github.com/ChloeeeYoo/Verilog_CommonBlock/assets/51250746/2a5d1997-e948-41e3-a8d8-26fdaea887ab)
