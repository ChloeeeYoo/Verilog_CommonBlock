## Divider

* X = D x Q + R
* X is dividend, D is divisor
* our calculation is X / D.
* Therefore, Q width = X width - D width

### Verilod explanation
* divisor_shift = { 0, divisor, {(Q width - 1) 0}}  ; X와 자리 맞춤
* diff = { 0, dividend} - { 0, divisor_shift}       ; 나눗셈 빼기
* q = diff[MSB]값이 양수이면 0, 음수이면 1.
* remainder = q값에 따라 q=0 이면 dividend(X), q=1 이면 diff 값이 됨 
